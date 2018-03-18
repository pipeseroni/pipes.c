#include <config.h>

#include <math.h>
#include <time.h>
#include <signal.h>
#include <curses.h>
#include <stdlib.h>
#include <term.h>
#include "render.h"
#include "pipe.h"
#include "util.h"

#define NS 1000000000L //1ns

static int hsl2rgb(float hue, float sat, float light);
static bool have_direct_colours(void);
static int set_color_pair_direct(int color_index, int color);
static int set_color_pair_indirect(int color_index, int color);
static int set_pair(int pair_index, int fg, int bg);
static int palette_size(void);

// Cribbed straight from Wikipedia :)
int hsl2rgb(float hue, float sat, float light) {
    float chroma = (1.0f - fabs(2*light - 1)) * sat;
    float hue_segment = hue / 60;
    float cpt2 = chroma * (1 - fabs(fmod(hue_segment, 2) - 1));
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
bool have_direct_colours(void) {
    if (tigetflag("RGB") > 0) {
        return true;
    } else if (tigetnum("RGB") > 0) {
        return true;
    } else {
        char *strval = tigetstr("RGB");
        if(strval != (char *) -1 && strval)
            return true;
    }
    return false;
}

/// Returns the effective size of the palette that we can use.
int palette_size(void) {
    bool direct = have_direct_colours();

    // On terminals that support direct colour, COLORS can be greater than
    // COLOR_PAIRS. We can only display `COLOR_PAIRS` different colours,
    // though, so that is the size of our palette.
    //
    // Note that for terminals that do not support direct colour, we reduce the
    // possible number of colours by 8, because we should not alter the default
    // 8 colours.
    int max_pipe_colors = min(COLORS, COLOR_PAIRS);

#if !HAVE_ALLOC_PAIR
    // On systems that do not support alloc_pair, the max. number of pairs
    // that can actually be used is 32767, because that is the limit of
    // the positive numbers in a 16-bit unsigned short. Apparently this
    // applies even with `init_extended_pair`.
    max_pipe_colors = min(max_pipe_colors, 32767);
#endif

#if !HAVE_EXTENDED_COLOR
    // Similarly, if we cannot call `init_extended_color`, then we cannot
    // set more than 32767 colours, no matter how many pairs we have.
    max_pipe_colors = min(max_pipe_colors, 32767);
#endif

    // If we *can* change colours, we remove 8 because we can't write to the
    // default 8 colours. If we can't change colours, the we should use the
    // full colour range, minus one because that one will be the backgorund.
    //
    // If we're using direct colors, we never actually
    // call `init_color` or `init_extended_color`, so we don't have to worry
    // about preserving the first 8 colours.
    if(can_change_color() && !direct)
        max_pipe_colors -= 8;
    else if(!can_change_color())
        max_pipe_colors -= 1;

    return max_pipe_colors;
}

/**
 * If `colors` is not `NULL`, then the color palette is initialised to each of
 * the `num_colors` elements in `colors`. Colors are interpreted as `0xRRGGBB`.
 * Each colour is assigned a palette ID (color pair number, in curses-speak),
 * which are returned in order in `palette->colors`. The number of colours in
 * the palette is returned in `palette->num_colors`.
 *
 * In the special case that `palette` is non-NULL, but `num_colors` is zero,
 * `palette` is set to the default palette.  The default color palette is a
 * sweep of HSL space with maximum saturation and lightness. Each colour is
 * evenly spaced in hue space.
 *
 * The colour palette should be freed using `palette_destroy` when it is no
 * longer needed.
 *
 * This function will return 0 on success, and a negative value on failure. An
 * error is printed to standard output upon error. Possible error modes:
 *
 * - Specifying more than `COLOR_PAIRS` colours (return `ERR_TOO_MANY_COLORS`).
 *
 * - Specifying more than 32767 colours on a system that does not support
 *   `alloc_pair`. On systems without `alloc_pair`, the classic `init_pair`
 *   interface must be used, which only supports as many numbers as can fit
 *   in the positive part of a signed 16-bit short (return
 *   `ERR_TOO_MANY_COLORS`).
 *
 * - Specifying colours in a terminal that does not support redefining colours.
 *   That is, setting `colors` to a non-`NULL` value when `can_change_color` is
 *   false results in an error (return `ERR_CANNOT_CHANGE_COLOR`). If the
 *   default palette is used, there is no error; instead, the default palette
 *   is the hardcoded terminal palette.
 *
 * - If colours are not supported (return `ERR_NO_COLOR`).
 *
 * - If an error is encountered by ncurses when allocating colours or colour
 *   pairs, `ERR_CURSES_ERR` is returned.
 *
 * - Alternatively, `ERR_OUT_OF_MEMORY` may be returned if allocation of the
 *   colour palette fails.
 */
int init_colour_palette(int *colors, int num_colors, struct palette *palette) {
    if(!has_colors())
        return ERR_NO_COLOR;
    if(colors && !can_change_color())
        return ERR_CANNOT_CHANGE_COLOR;

    start_color();

    // With direct colors, we set the color directly in the pair
    // e.g. init_extended_pair(i, COLOR_BLACK, rgb);
    bool direct = have_direct_colours();
    int max_pipe_colors = palette_size();

    // Use supplied palette, if any.
    if(colors) {
        if(num_colors > max_pipe_colors)
            return ERR_TOO_MANY_COLORS;
        max_pipe_colors = num_colors;
    }
    palette->num_colors = max_pipe_colors;
    palette->colors = malloc(sizeof(*palette->colors) * palette->num_colors);
    if(!palette->colors)
        return ERR_OUT_OF_MEMORY;

    // Set palette, either to the value specified in colors or to an HSL sweep.
    // Note that calls to init_color or init_extended_color must have the
    // colour index increased by 8 to avoid writing to the default 8 colours.
    for(int i=0; i < max_pipe_colors; i++) {
        if(!can_change_color() && !direct){
            palette->colors[i] = set_pair(i, i + 1, COLOR_BLACK);
        }else{
            int color;
            if(colors)
                color = colors[i];
            else
                color = hsl2rgb(((float) i) * 360 / max_pipe_colors, 1, 0.5);

            int pair_index;
            if(direct) {
                pair_index = set_color_pair_direct(i, color);
            }else{
                pair_index = set_color_pair_indirect(i, color);
            }
            if(pair_index < 0)
                return pair_index;
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
 * Set the colour pair `pair_index` to the given colour in as version agnostic
 * a way as possible. If `alloc_pair` is available, then `pair_index` is
 * ignored; otherwise it is passed as the pair ID to `init_pair`.
 *
 * Returns -1 on error, or the pair index
 */
int set_pair(int pair_index, int fg, int bg) {
    int retval;
    int alloced_index = pair_index;
#if HAVE_ALLOC_PAIR
    retval = alloc_pair(fg, bg);
    alloced_index = retval;
#elif HAVE_EXTENDED_COLOR
    retval = init_extended_pair(pair_index, fg, bg);
#else
    retval = init_pair(pair_index, fg, bg);
#endif
    if(retval == ERR)
        return retval;
    return alloced_index;
}

/**
 * Set the foreground of a colour pair to `color` (in `0xRRGGBB` form).
 * The index `color_index` will be used as the pair index if
 * `alloc_pair` is not supported: otherwise, the index returned can be
 * unrelated.
 *
 * Returns the ID of the new pair, or `ERR_CURSES_ERR` on error.
 *
 * Note that the color should be zero-indexed. This function internally
 * adds 8 to it to avoid overwriting any of the default colours.
 */
int set_color_pair_indirect(int color_index, int color) {
    int r = ((color >> 16) & 0xFF) * 1000 / 255;
    int g = ((color >>  8) & 0xFF) * 1000 / 255;
    int b = ((color      ) & 0xFF) * 1000 / 255;

    int retval;
#if HAVE_EXTENDED_COLOR
    retval = init_extended_color(color_index + 8, r, g, b);
#else
    retval = init_color(color_index + 8, r, g, b);
#endif
    // Error initing color
    if(retval == ERR)
        return ERR_CURSES_ERR;

    return set_pair(color_index, color_index + 8, COLOR_BLACK);
}

/**
 * Set the foreground colour of a pair to `color`, given in the form
 * `0xRRGGBB`. The index of the pair will be `color_index` if `alloc_pair`
 * is not supported; it can be arbitrary otherwise.
 */
int set_color_pair_direct(int color_index, int color) {
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

void render_pipe(struct pipe *p, char **trans, char **pipe_chars,
        int old_state, int new_state){

    move(p->y, p->x);
    attr_set(A_NORMAL, 1, &p->colour);
    if(old_state != new_state) {
        addstr(transition_char(trans, old_state, new_state));
    }else{
        addstr(pipe_chars[old_state % 2]);
    }
    attr_off(A_NORMAL, NULL);
}
