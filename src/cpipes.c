#include <config.h>

#include <inttypes.h>
#include <langinfo.h>
#include <string.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <curses.h>
#include <signal.h>
#include <time.h>
#include <locale.h>
#include <getopt.h>
#include <errno.h>

#include "canvas.h"
#include "pipe.h"
#include "pipe_cell_list.h"
#include "render.h"
#include "util.h"

// Use noreturn on die() if possible
#ifdef HAVE_STDNORETURN_H
#   include <stdnoreturn.h>
#else
#   define noreturn /* noreturn */
#endif

void interrupt_signal(int param);
void parse_options(int argc, char **argv);
static void find_num_colors(int argc, char **argv);
float parse_float_opt(const char *optname);
int parse_int_opt(const char *optname);
noreturn void die(void);
void usage_msg(int exitval);
void render(struct canvas *canvas, void *data);
int init_chars(void);

// Includes screen width, height, palette and any color backups.
static struct canvas canvas;

//If set >= zero, this initial state is used.
int initial_state = -1;

// If true, attempt to make a backup of the terminal's colors
bool backup_colors = false;

const char *usage =
    "Usage: cpipes [OPTIONS]\n"
    "Options:\n"
    "    -p, --pipes=N   Number of pipes.                  (Default: 20    )\n"
    "    -f, --fps=F     Frames per second.                (Default: 60.0  )\n"
    "    -a, --ascii     ASCII mode.                       (Default: no    )\n"
    "    -l, --length=N  Minimum length of pipe.           (Default: 2     )\n"
    "    -m, --max=N     Minimum length of pipe.           (Default: None  )\n"
    "    -r, --prob=N    Probability of changing direction.(Default: 0.1   )\n"
    "    -i, --init=N    Initial state (0,1,2,3 => R,D,L,U)(Default: random)\n"
    "    -c, --color=C   Add color C (in RRGGBB hexadecimal) to palette.\n"
    "    --backup-colors Backup colors and restore when exiting.\n"
    "    -h, --help      This help message.\n";

static struct option opts[] = {
    {"pipes",   required_argument, 0,   'p'},
    {"fps",     required_argument, 0,   'f'},
    {"ascii",   no_argument,       0,   'a'},
    {"length",  required_argument, 0,   'l'},
    {"max",     required_argument, 0,   'm'},
    {"prob",    required_argument, 0,   'r'},
    {"help",    no_argument,       0,   'h'},
    {"color",   required_argument, 0,   'c'},
    {"backup-colors", no_argument, 0,   'b'},
    {0,         0,                 0,    0 }
};


//All pipes
struct pipe *pipes;

//Signal flag for interrupts
volatile sig_atomic_t interrupted = 0;

unsigned int num_pipes = 20;
float fps = 60;
float prob = 0.1;
unsigned int min_len = 2;
unsigned int max_len = 0;

char *trans[16];
char *pipe_chars[2];

// If/when we supply user-configurable characters, this will need to be changed
// to point to the user's terminal encoding.
const char *source_charset = "UTF-8";

const char *ASCII_CHARS = "-|++++";
const char *UNICODE_CHARS = "━┃┓┛┗┏";
const char *selected_chars = NULL;

char pipe_char_buf[CHAR_BUF_SZ];

// Colours set by parse_options by the "-c" flag
uint32_t *custom_colors = NULL;
size_t num_custom_colors = 0;

// Convenience macro for bailing in init_chars
#define X(a) do { \
        if( ((a)) == -1 ) { \
            fprintf(stderr, "Error initialising pipe characters.\n"); \
            exit(1); \
        } \
    } while(0);

int init_chars(void) {
    if(!selected_chars)
        selected_chars = UNICODE_CHARS;
    if(strlen(selected_chars) >= CHAR_BUF_SZ)
        return -1;

    char *term_charset = nl_langinfo(CODESET);
    char inbuf[CHAR_BUF_SZ];
    char utf8buf[CHAR_BUF_SZ];
    strncpy(inbuf, selected_chars, CHAR_BUF_SZ);

    X(locale_to_utf8(inbuf, utf8buf, source_charset, CHAR_BUF_SZ));
    X(utf8_to_locale(utf8buf, pipe_char_buf, CHAR_BUF_SZ, term_charset));
    assign_matrices(pipe_char_buf, trans, pipe_chars);
    X(multicolumn_adjust(pipe_chars));
    return 0;
}

int main(int argc, char **argv){
    cpipes_errno err = 0;
    srand(time(NULL));
    setlocale(LC_ALL, "");
    //Set a flag upon interrupt to allow proper cleaning
    signal(SIGINT, interrupt_signal);

    parse_options(argc, argv);
    init_chars();

    //Initialise ncurses, hide the cursor and get width/height.
    initscr();
    curs_set(0);
    cbreak();
    noecho();
    setbuf(stdout, NULL);
    getmaxyx(stdscr, canvas.height, canvas.width);
    canvas_init(&canvas, canvas.width, canvas.height);

    err = init_color_palette(
            custom_colors, num_custom_colors,
            &canvas.palette, (backup_colors ? &canvas.backup : NULL));
    if(err)
        goto cleanup;

    // Called after init_color_palette because that needs to have a
    // timeout on getch() to determine whether the query worked.
    nodelay(stdscr, true);

    //Init pipes. Use predetermined initial state, if any.
    pipes = malloc(num_pipes * sizeof(struct pipe));
    for(unsigned int i=0; i<num_pipes;i++) {
        err = init_pipe(&pipes[i], &canvas, initial_state, max_len);
        if(err) {
            add_error_info("Error initialising pipe %u", i);
            goto cleanup;
        }
        random_pipe_color(&pipes[i], &canvas.palette);
    }

    animate(fps, render, &canvas, &interrupted, NULL);

cleanup:
    curs_set(1);
    endwin();

    if(err)
        print_error();

    if(backup_colors) {
        restore_colors(&canvas.backup);
        free_colors(&canvas.backup);
    }

    canvas_free(&canvas);
    free(custom_colors);
    free(pipes);
    palette_destroy(&canvas.palette);
    return 0;
}

void render(struct canvas *c, void *data){
    for(size_t i=0; i<num_pipes && !interrupted; i++){
        move_pipe(&pipes[i], c);

        if(wrap_pipe(&pipes[i], c))
            random_pipe_color(&pipes[i], &c->palette);

        char old_state = pipes[i].state;
        if(should_flip_state(&pipes[i], min_len, prob)){
            old_state = flip_pipe_state(&pipes[i]);
        }

        const char *pipe_char;
        if(old_state != pipes[i].state)
            pipe_char = transition_char(trans, old_state, pipes[i].state);
        else
            pipe_char = pipe_chars[old_state % 2];

        render_pipe(&pipes[i], trans, pipe_chars, old_state, pipes[i].state);
        if(pipes[i].locations) {
            size_t cell_idx = pipes[i].y * c->width + pipes[i].x;
            if(pipes[i].locations->size == max_len)
                erase_pipe_tail(&pipes[i], c);
            location_buffer_push(pipes[i].locations, cell_idx);
            pipe_cell_list_push(&c->cells[cell_idx], pipe_char, &pipes[i]);
        }
    }
    refresh();
}

void interrupt_signal(int param){
    interrupted = 1;
}

void usage_msg(int exitval){
    fprintf(exitval == 0 ? stdout : stderr, "%s",   usage);
}

noreturn void die(void){
    usage_msg(1);
    exit(1);
}

int parse_int_opt(const char *optname){
    errno = 0;
    int i_res = strtol(optarg, NULL, 10);
    if(errno || i_res < 1){
        fprintf(stderr, "%s must be a positive integer.\n", optname);
        die();
    }
    return i_res;
}

float parse_float_opt(const char *optname){
    errno = 0;
    float f_res = strtof(optarg, NULL);
    if(errno || f_res < 0){
        fprintf(stderr, "%s must be a real number (>= 0).\n", optname);
        die();
    }
    return f_res;
}

void find_num_colors(int argc, char **argv) {
    opterr = 0;
    // First work out how many colors were specified on the command line
    int c;
    while((c = getopt_long(argc, argv, "c:", opts, NULL)) != -1) {
        if(c == 'c')
            num_custom_colors++;
    }
    if(num_custom_colors > 0) {
        custom_colors = malloc(sizeof(*custom_colors) * num_custom_colors);
        if(!custom_colors) {
            // TODO: Use err.c to handle this
            perror("Error allocating memory for color palette.");
            exit(1);
        }
    }
    // Reset optind so we can do the proper parsing run
    optind = 0;
}

void parse_options(int argc, char **argv){
    opterr = 1;
    int c;

    find_num_colors(argc, argv);
    // Current color (`-c`) and index into `custom_colors`
    size_t color_index = 0;
    uint32_t color = 0;

    optind = 0;
    while((c = getopt_long(argc, argv, "p:f:al:m:r:i:c:h", opts, NULL)) != -1){
        switch(c){
            errno = 0;
            case 'p':
                num_pipes = parse_int_opt("--pipes");
                break;
            case 'f':
                fps = parse_float_opt("--fps");
                break;
            case 'a':
                selected_chars = ASCII_CHARS;
                break;
            case 'l':
                min_len = parse_int_opt("--length");
                break;
            case 'm':
                max_len = parse_int_opt("--max");
                break;
            case 'r':
                prob = parse_float_opt("--prob");
                if(prob > 1){
                    fprintf(stderr, "%s\n",
                            "--prob must be less than 1");
                    usage_msg(1);
                    exit(1);
                }
                break;
            case 'i':
                initial_state = strtol(optarg, NULL, 10);
                if(initial_state < 0 || initial_state > 3){
                    fprintf(stderr, "%s\n",
                            "--init must be between 0 and 3 (inclusive).");
                    usage_msg(1);
                    exit(1);
                }
                break;
            case 'b':
                backup_colors = true;
                break;
            case 'c':
                if(sscanf(optarg, "%" SCNx32, &color) != 1) {
                    fprintf(stderr, "Invalid color '%s'\n", optarg);
                    die();
                }
                custom_colors[color_index++] = color;
                break;
            case 'h':
                usage_msg(0);
                exit(0);
            case '?':
            default:
                usage_msg(1);
                exit(1);
        }
    }
}
