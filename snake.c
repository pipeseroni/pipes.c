#define _POSIX_C_SOURCE 199309L
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <curses.h>
#include <signal.h>
#include <time.h>
#include <locale.h>
#include <getopt.h>
#include <errno.h>

#define NS 1000000000L //1ns

void interrupt_signal(int param);
void parse_options(int argc, char **argv);
float parse_float_opt(const char *optname);
int parse_int_opt(const char *optname);
void die();
void usage_msg(int exitval);

//The states describe the current "velocity" of a pipe.  Notice that the allowed
//transitions are given by a change of +/- 1. So, for example, a pipe heading
//left may go up or down but not right.
//              Right    Down   Left    Up
const char states[][2] = {{1,0}, {0,1}, {-1,0}, {0,-1}};

//The transition matrices here describe the character that should be output upon
//a transition from] one state (direction) to another. If you wanted, you could
//modify these to include the probability of a transition.
//┓ : U+2513
//┛ : U+251B
//┗ : U+2517
//┏ : U+250F
const char* trans_unicode[][4]  = {
//      R D L U
    {"",         "\u2513",     "",          "\u251B"  }, //R
    {"\u2517",    "",          "\u251B",     0       }, //D
    {"",         "\u250F",     "",          "\u2517"  }, //L
    {"\u250F",    "",          "\u2513",     0       }  //D
};
const char* trans_ascii[][4] = {
//       R D L U
    {"",     "+",    "",      "+"}, //R
    {"+",   "",      "+",    0  }, //D
    {"",     "+",    "",      "+"}, //L
    {"+",   "",      "+",    0  }  //U
};

//The characters to represent a travelling (or extending, I suppose) pipe.
const char* unicode_pipe_chars[] = {"\u2501", "\u2503"};
const char* ascii_pipe_chars[]   = {"-", "|"};

//Represents a pipe
struct pipe {
    unsigned char state;
    unsigned short colour;
    unsigned short length;
    int x, y;
};

//If set >= zero, this initial state is used.
int initial_state = -1;

const char *usage =
    "Usage: snake [OPTIONS]\n"
    "Options:\n"
    "    -p, --pipes=N   Number of pipes.                  (Default: 20    )\n"
    "    -f, --fps=F     Frames per second.                (Default: 75.0  )\n"
    "    -a, --ascii     ASCII mode.                       (Default: no    )\n"
    "    -l, --length=N  Minimum length of pipe.           (Default: 2     )\n"
    "    -r, --prob=N    Probability of chaning direction. (Default: 0.1   )\n"
    "    -i, --init=N    Initial state (0,1,2,3 => R,D,L,U)(Default: random)\n"
    "    -h, --help      This help message.\n";

static struct option opts[] = {
    {"pipes",   required_argument, 0,   'p'},
    {"fps",     required_argument, 0,   'f'},
    {"ascii",   no_argument,       0,   'a'},
    {"length",  required_argument, 0,   'l'},
    {"prob",    required_argument, 0,   'r'},
    {"help",    no_argument,       0,   'h'},
    {0,         0,                 0,    0 }
};


//All pipes
struct pipe *pipes;

//Signal flag for interrupts
volatile sig_atomic_t interrupted = 0;

//Width and height of terminal (in chars and lines)
unsigned int width, height;

unsigned int num_pipes = 20;
float fps = 75;
float prob = 0.1;
unsigned int min_len = 2;
const char* (*trans)[][4] = &trans_unicode;
const char* (*pipe_chars)[] = &unicode_pipe_chars;


int main(int argc, char **argv){
    setlocale(LC_ALL, "");
    //Set a flag upon interrupt to allow proper cleaning
    signal(SIGINT, interrupt_signal);

    parse_options(argc, argv);

    //Initialise ncurses, hide the cursor and get width/height.
    initscr();
    curs_set(0);
    getmaxyx(stdscr, height, width);
    //Initialise colour pairs if we can.
    if(has_colors()){
        start_color();
        for(short i=1; i < COLORS; i++){
            init_pair(i, i, COLOR_BLACK);
        }
    }

    //Init pipes. Use predetermined initial state, if any.
    pipes = malloc(num_pipes * sizeof(struct pipe));
    for(unsigned int i=0; i<num_pipes;i++){
        if(initial_state < 0)
            pipes[i].state = (rand() % 4);
        else
            pipes[i].state = initial_state;
        pipes[i].colour = (rand() % COLORS);
        pipes[i].length = 0;
        pipes[i].x = (rand() % width);
        pipes[i].y = (rand() % height);
    }

    struct timespec start_time;
    long delay_ns = NS / fps;

    while(!interrupted){
        clock_gettime(CLOCK_REALTIME, &start_time);
        for(int i=0; i<num_pipes && !interrupted; i++){
            pipes[i].x += states[pipes[i].state][0];
            pipes[i].y += states[pipes[i].state][1];
            pipes[i].length++;

            if(pipes[i].x < 0 || pipes[i].x == width
                    || pipes[i].y < 0 || pipes[i].y == height){
                if(pipes[i].x < 0){ pipes[i].x += width; }
                if(pipes[i].y < 0){ pipes[i].y += height; }
                if(pipes[i].x >= width) {pipes[i].x -= width; }
                if(pipes[i].y >= height) {pipes[i].y -= height; }
                pipes[i].colour = (rand() % COLORS);
            }

            move(pipes[i].y, pipes[i].x);
            attron(COLOR_PAIR(pipes[i].colour));
            if( rand() < prob*RAND_MAX && pipes[i].length > min_len){
                char new_state = pipes[i].state;
                char flip = ((rand() < RAND_MAX/2) ? -1 : 1 );
                new_state += flip;
                if(new_state < 0) { new_state = 3; }
                else if(new_state > 3){ new_state = 0; }

                addstr((*trans)[pipes[i].state][(int)new_state]);
                pipes[i].length = 0;
                pipes[i].state = new_state;
            }else{
                addstr((*pipe_chars)[pipes[i].state % 2]);
            }
            attroff(COLOR_PAIR(pipes[i].colour));
        }
        refresh();
        struct timespec end_time;
        clock_gettime(CLOCK_REALTIME, &end_time);
        long took_ns =
              NS * (end_time.tv_sec - start_time.tv_sec)
                 + (end_time.tv_nsec - start_time.tv_nsec);
        struct timespec sleep_time = {
            .tv_sec  = (delay_ns - took_ns) / NS,
            .tv_nsec = (delay_ns - took_ns) % NS
        };
        nanosleep(&sleep_time, NULL);
    }

    curs_set(1);
    endwin();
    free(pipes);
    return 0;
}

void interrupt_signal(int param){
    interrupted = 1;
}

void usage_msg(int exitval){
    fprintf(exitval == 0 ? stdout : stderr, "%s",   usage);
}

void die(){
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

void parse_options(int argc, char **argv){
    int c;
    while((c = getopt_long(argc, argv, "p:f:al:r:i:h", opts, NULL)) != -1){
        switch(c){
            errno = 0;
            case 'p':
                num_pipes = parse_int_opt("--pipes");
                break;
            case 'f':
                fps = parse_float_opt("--fps");
                break;
            case 'a':
                trans = &trans_ascii;
                pipe_chars = &ascii_pipe_chars;
                break;
            case 'l':
                min_len = parse_int_opt("--length");
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
