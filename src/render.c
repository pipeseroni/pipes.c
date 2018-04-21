#include <config.h>

#include <math.h>
#include <time.h>
#include <signal.h>
#include <curses.h>
#include <stddef.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <term.h>
#include "err.h"
#include "render.h"
#include "pipe.h"
#include "util.h"

#define NS 1000000000L //1ns

#define ESCAPE_CODE_SIZE 256

// Number of reserved pairs in indirect mode (just color pair 0)
#define RESERVED_INDIRECT_PAIRS 1

static int hsl2rgb(float hue, float sat, float light);
static bool have_direct_colors(void);
static int set_color_pair_direct(int color_index, uint32_t color);
static int set_color_pair_indirect(int color_index, uint32_t color);
static int set_pair(int pair_index, int fg, int bg);
static size_t palette_size(void);

static cpipes_errno query_terminal(const char *escape, char *buffer, int bufsz);

// Cribbed straight from Wikipedia :)
int hsl2rgb(float hue, float sat, float light) {
    float chroma = (1.0f - fabsf(2.0f*light - 1)) * sat;
    float hue_segment = hue / 60;
    float cpt2 = chroma * (1 - fabsf(fmodf(hue_segment, 2.0f) - 1));
    float r, g, b;
    switch((int)hue_segment){
        case 0: r = chroma; g = cpt2  ; b = 0     ; break;
        case 1: r = cpt2  ; g = chroma; b = 0     ; break;
        case 2: r = 0     ; g = chroma; b = cpt2  ; break;
        case 3: r = 0     ; g = cpt2  ; b = chroma; break;
        case 4: r = cpt2  ; g = 0     ; b = chroma; break;
        case 5: r = chroma; g = 0     ; b = cpt2  ; break;
        default: r = 0; g = 0; b = 0;
    }
    float offset = light - chroma/2;
    r += offset;
    g += offset;
    b += offset;

    int ir = (int)(r * 255);
    int ig = (int)(g * 255);
    int ib = (int)(b * 255);
    return (ir << 16) | (ig << 8) | ib;
}

// Check whether this terminal has the RGB capability (direct colors).
// This is adapted from `parse_rgb.h` header with the ncurses test programs.
bool have_direct_colors(void) {
    // Required because terminfo on mac requires a non-const name
    char rgbcap[4];
    strcpy(rgbcap, "RGB");

    if (tigetflag(rgbcap) > 0) {
        return true;
    } else if (tigetnum(rgbcap) > 0) {
        return true;
    } else {
        char *strval = tigetstr(rgbcap);
        if(strval != (char *) -1 && strval)
            return true;
    }
    return false;
}

/// Returns the effective size of the palette that we can use.
size_t palette_size(void) {
    bool direct = have_direct_colors();

    // On terminals that support direct color, COLORS can be greater than
    // COLOR_PAIRS. We can only display `COLOR_PAIRS` different colors,
    // though, so that is the size of our palette.
    //
    // Note that for terminals that do not support direct color, we reduce the
    // possible number of colors by 8, because we should not alter the default
    // 8 colors.
    int max_pipe_colors = min(COLORS, COLOR_PAIRS);

#if !defined HAVE_ALLOC_PAIR
    // On systems that do not support alloc_pair, the max. number of pairs
    // that can actually be used is 32767, because that is the limit of
    // the positive numbers in a 16-bit unsigned short. Apparently this
    // applies even with `init_extended_pair`.
    max_pipe_colors = min(max_pipe_colors, 32767);
#endif

#if !defined HAVE_EXTENDED_COLOR
    // Similarly, if we cannot call `init_extended_color`, then we cannot
    // set more than 32767 colors, no matter how many pairs we have.
    max_pipe_colors = min(max_pipe_colors, 32767);
#endif

    // If we *can* change colors, we remove 1 because we can't write to color
    // pair 0. If we can't change colors, the we should use the full color
    // range, minus one because that one will be the background.
    //
    // If we're using direct colors, we never actually
    // call `init_color` or `init_extended_color`, so we don't have to worry
    // about preserving any colors.
    if(can_change_color() && !direct)
        max_pipe_colors -= RESERVED_INDIRECT_PAIRS;
    else if(!can_change_color())
        max_pipe_colors -= 1;

    return max_pipe_colors;
}

/**
 * If `colors` is not `NULL`, then the color palette is initialised to each of
 * the `num_colors` elements in `colors`. Colors are interpreted as `0xRRGGBB`.
 * Each color is assigned a palette ID (color pair number, in curses-speak),
 * which are returned in order in `palette->colors`. The number of colors in
 * the palette is returned in `palette->num_colors`.
 *
 * In the special case that `palette` is non-NULL, but `num_colors` is zero,
 * `palette` is set to the default palette.  The default color palette is a
 * sweep of HSL space with maximum saturation and lightness. Each color is
 * evenly spaced in hue space.
 *
 * The color palette should be freed using `palette_destroy` when it is no
 * longer needed.
 *
 * If `backup` is non-`NULL`, then the terminal is queried for the escape
 * codes used to reset the original colors. These are stored in `backup`.
 *
 * This function will return 0 on success, and a negative value on failure. An
 * error is printed to standard output upon error. Possible error modes:
 *
 * - Specifying more than `COLOR_PAIRS` colors (return `ERR_TOO_MANY_COLORS`).
 *
 * - Specifying more than 32767 colors on a system that does not support
 *   `alloc_pair`. On systems without `alloc_pair`, the classic `init_pair`
 *   interface must be used, which only supports as many numbers as can fit
 *   in the positive part of a signed 16-bit short (return
 *   `ERR_TOO_MANY_COLORS`).
 *
 * - Specifying colors in a terminal that does not support redefining colors.
 *   That is, setting `colors` to a non-`NULL` value when `can_change_color` is
 *   false results in an error (return `ERR_CANNOT_CHANGE_COLOR`). If the
 *   default palette is used, there is no error; instead, the default palette
 *   is the hardcoded terminal palette.
 *
 * - If colors are not supported (return `ERR_NO_COLOR`).
 *
 * - If an error is encountered by ncurses when allocating colors or color
 *   pairs, `ERR_CURSES_ERR` is returned.
 *
 * - Alternatively, `ERR_OUT_OF_MEMORY` may be returned if allocation of the
 *   color palette fails.
 */
cpipes_errno init_color_palette(uint32_t *colors, size_t num_colors,
        struct palette *palette, struct color_backup *backup) {
    clear_error();
    if(!has_colors()) {
        set_error(ERR_NO_COLOR);
        return ERR_NO_COLOR;
    }

    // With direct colors, we set the color directly in the pair
    // e.g. init_extended_pair(i, COLOR_BLACK, rgb);
    bool direct = have_direct_colors();

    // If we aren't using direct colors and we can't change colors to match
    // the specified palette, that is an error.
    if(!direct && (colors && !can_change_color())) {
        set_error(ERR_CANNOT_CHANGE_COLOR);
        return ERR_CANNOT_CHANGE_COLOR;
    }

    start_color();
    size_t max_pipe_colors = palette_size();

    // Use supplied palette, if any.
    if(colors) {
        if(num_colors > max_pipe_colors) {
            set_error(ERR_TOO_MANY_COLORS, num_colors, max_pipe_colors);
            return ERR_TOO_MANY_COLORS;
        }
        max_pipe_colors = num_colors;
    }

    // Make backup of colors by querying terminal.
    if(backup) {
        if(!direct) {
            cpipes_errno err = create_color_backup(max_pipe_colors, backup);
            if(err)
                return err;
        } else {
            backup->num_colors = 0;
        }
    }

    palette->num_colors = max_pipe_colors;
    palette->colors = malloc(sizeof(*palette->colors) * palette->num_colors);
    if(!palette->colors) {
        set_error(ERR_OUT_OF_MEMORY);
        return ERR_OUT_OF_MEMORY;
    }

    // Set palette, either to the value specified in colors or to an HSL sweep.
    // Note that calls to init_color or init_extended_color must have the
    // color index increased by 1 to avoid writing to color pair 0.
    for(size_t i=0; i < max_pipe_colors; i++) {
        if(!can_change_color() && !direct){
            // Just use the colors in the default palette if we can't change
            // colors. The color is `i + 1` because we don't want to use
            // the backgroudn color for the foreground.
            palette->colors[i] = set_pair(i, i + 1, COLOR_BLACK);
        }else{
            int color;
            if(colors)
                color = colors[i];
            else
                color = hsl2rgb(((float) i) * 360 / max_pipe_colors, 1, 0.5);

            int pair_index;
            if(direct) {
                pair_index = set_color_pair_direct(
                        i + RESERVED_INDIRECT_PAIRS, color);
            }else{
                pair_index = set_color_pair_indirect(
                        i + RESERVED_INDIRECT_PAIRS, color);
            }
            if(pair_index < 0) {
                set_error(ERR_CURSES_ERR, "Setting color pair failed");
                return pair_index;
            }
            palette->colors[i] = pair_index;
        }
    }
    return 0;
}

/// Free memory associated with color palette.
void palette_destroy(struct palette *palette) {
    free(palette->colors);
}


/**
 * Set the color pair `pair_index` to the given color in as version agnostic
 * a way as possible. If `alloc_pair` is available, then `pair_index` is
 * ignored; otherwise it is passed as the pair ID to `init_pair`.
 *
 * Returns -1 on error, or the pair index
 */
int set_pair(int pair_index, int fg, int bg) {
    int retval;
    int alloced_index = pair_index;
#if defined HAVE_ALLOC_PAIR
    retval = alloc_pair(fg, bg);
    alloced_index = retval;
#elif defined HAVE_EXTENDED_COLOR
    retval = init_extended_pair(pair_index, fg, bg);
#else
    retval = init_pair(pair_index, fg, bg);
#endif
    if(retval == ERR)
        return retval;
    return alloced_index;
}

/**
 * Set the foreground of a color pair to `color` (in `0xRRGGBB` form).
 * The index `color_index` will be used as the pair index if
 * `alloc_pair` is not supported: otherwise, the index returned can be
 * unrelated.
 *
 * Returns the ID of the new pair, or `ERR_CURSES_ERR` on error.
 *
 * Note that the color should be zero-indexed. This function internally
 * adds 1 to it to avoid overwriting any of the default colors.
 */
int set_color_pair_indirect(int color_index, uint32_t color) {
    int r = ((color >> 16) & 0xFF) * 1000 / 255;
    int g = ((color >>  8) & 0xFF) * 1000 / 255;
    int b = ((color      ) & 0xFF) * 1000 / 255;

    int retval;
#if defined HAVE_EXTENDED_COLOR
    retval = init_extended_color(color_index, r, g, b);
#else
    retval = init_color(color_index, r, g, b);
#endif
    // Error initing color
    if(retval == ERR)
        return ERR_CURSES_ERR;

    return set_pair(color_index, color_index, COLOR_BLACK);
}

/**
 * Set the foreground color of a pair to `color`, given in the form
 * `0xRRGGBB`. The index of the pair will be `color_index` if `alloc_pair`
 * is not supported; it can be arbitrary otherwise.
 */
int set_color_pair_direct(int color_index, uint32_t color) {
    return set_pair(color_index, color, COLOR_BLACK);
}

void animate(int fps, anim_function renderer,
        unsigned int *width, unsigned int *height,
        volatile sig_atomic_t *interrupted, void *data){
    //Store start time
    struct timespec start_time;
    long delay_ns = NS / fps;

    // Continue while we haven't received a SIGINT
    while(!(*interrupted)){
        int key = getch();

        // If we received a SIGWINCH, update width and height
        if(key == KEY_RESIZE) {
            getmaxyx(stdscr, *height, *width);
        }else if(key != ERR) {
            // Any actual keypresses should quit the program.
            break;
        }

        clock_gettime(CLOCK_REALTIME, &start_time);

        //Render
        (*renderer)(*width, *height, data);

        //Get end time
        struct timespec end_time;
        clock_gettime(CLOCK_REALTIME, &end_time);
        //Work out how long that took
        long took_ns =
              NS * (end_time.tv_sec - start_time.tv_sec)
                 + (end_time.tv_nsec - start_time.tv_nsec);
        //Sleep for delay_ns - render time
        struct timespec sleep_time = {
            .tv_sec  = (delay_ns - took_ns) / NS,
            .tv_nsec = (delay_ns - took_ns) % NS
        };
        nanosleep(&sleep_time, NULL);
    }
}

/**
 * Some terminals (looking at you, urxvt), do not properly reset the
 * terminal colors when ncurses exits. Some terminals support querying
 * the current terminal colors (via OSC 4 ?), which should allow us to
 * reset the colors later.
 */
cpipes_errno create_color_backup(size_t num_colors,
        struct color_backup *backup){
    cpipes_errno err = 0;

    char **escape_codes;
    escape_codes = malloc(sizeof(*escape_codes) * num_colors);
    if(!escape_codes) {
        set_error(ERR_OUT_OF_MEMORY);
        return ERR_OUT_OF_MEMORY;
    }

    backup->escape_codes = escape_codes;
    backup->num_colors = num_colors;

    char buffer[ESCAPE_CODE_SIZE];
    size_t i;
    for(i=0; i < num_colors; i++) {

        // Query the value of color "i". If the terminal understands the
        // escape sequence, it will write the response to the standard input of
        // the program, terminating with a BEL.
        sprintf(buffer, "\033]4;%zu;?\007", i + 1);
        err = query_terminal(buffer, buffer, ESCAPE_CODE_SIZE);
        if(err) {
            add_error_info(
                "Could not back up color codes. Terminal does not "
                "support querying colors.");
            goto error;
        }

        // xterm and urxvt give different responses to the query. Xterm is
        // sensible, and includes the color index in the response
        // (\033]4;i;rgb:), but urxvt doesn't (\033]4;rgb:).
        // We get around this by explicitly inserting the index here if it
        // is not present.
        size_t ignore;
        if(sscanf(buffer, "\033]%zu;rgb", &ignore)) {
            char *start = strstr(buffer, "rgb");

            int escape_sz = snprintf(NULL, 0, "\033]4;%zu;%s", i + 1, start);
            if(escape_sz < 0) {
                set_error(ERR_C_ERROR,
                        "'snprintf' to calculate length of escape buffer");
                err = ERR_C_ERROR;
                goto error;
            }

            char *escape_buf = calloc(escape_sz + 1, 1);
            if(escape_sz < 0) {
                set_error(ERR_OUT_OF_MEMORY);
                err = ERR_OUT_OF_MEMORY;
                goto error;
            }

            sprintf(escape_buf, "\033]4;%zu;%s", i + 1, start);
            escape_codes[i] = escape_buf;
        }else{
            escape_codes[i] = strdup(buffer);
            if(!escape_codes[i]) {
                set_error(ERR_OUT_OF_MEMORY);
                err = ERR_OUT_OF_MEMORY;
                goto error;
            }
        }
    }
    return 0;

error:
    while(i > 0)
        free(escape_codes[--i]);
    free(escape_codes);
    backup->escape_codes = NULL;
    backup->num_colors = 0;
    return err;
}


/** Print backup escape codes to terminal. */
void restore_colors(struct color_backup *backup) {
    for(size_t i=0; i < backup->num_colors; i++) {
        putp(backup->escape_codes[i]);
    }
}

/** Free the list of escape codes used for restoring colors. */
void free_colors(struct color_backup *backup) {
    for(size_t i=0; i < backup->num_colors; i++) {
        free(backup->escape_codes[i]);
    }
}

/**
 * Write a query sequence to the terminal, and wait for a response.
 * The reponse is written to `buffer`.
 */
cpipes_errno query_terminal(const char *escape, char *buffer, int bufsz) {
    putp(escape);
    int c;
    int i = 0;
    timeout(100);
    do {
        if(i >= bufsz) {
            set_error(ERR_BUFFER_TOO_SMALL, i, bufsz);
            return ERR_BUFFER_TOO_SMALL;
        }

        c = getch();
        if(c == ERR) {
            set_error(ERR_QUERY_UNSUPPORTED);
            return ERR_QUERY_UNSUPPORTED;
        }

        buffer[i++] = c;
    } while(c != '\7');
    buffer[i] = '\0';
    return 0;
}

void render_pipe(struct pipe *p, char **trans, char **pipe_chars,
        int old_state, int new_state){

    move(p->y, p->x);

    // ABI 6 and up can pass the color in the opts pointer as a pointer to an
    // int. otherwise, we need to use the pair parameter, which is a short.
    // The overflow should have been taken care of in palette_size, so we
    // should just need the ABI version check.
# if NCURSES_VERSION_MAJOR >= 6
    attr_set(A_NORMAL, 1, &p->color);
#else
    attr_set(A_NORMAL, p->color, NULL);
#endif

    if(old_state != new_state) {
        addstr(transition_char(trans, old_state, new_state));
    }else{
        addstr(pipe_chars[old_state % 2]);
    }
    attr_off(A_NORMAL, NULL);
}
