#include <config.h>

#include <errno.h>
#include <iconv.h>
#include <langinfo.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <wchar.h>
#include "canvas.h"
#include "err.h"
#include "pipe.h"
#include "util.h"
#include "render.h"
#include "location_buffer.h"

/* This file contains functions for managing the initialisation and movement of
 * a pipe.
 *
 * We want to take advantage of all the unicode characters for box drawing, so
 * there are some subtleties we have to take into account:
 *
 * - Pipe characters may consist of multiple bytes.
 *
 * - Predefined pipe characters in these source files are encoded in UTF-8, but
 *   characters supplied by the user will be in their locale encoding.
 *
 * - In some encodings, characters can print over multiple columns on the
 *   terminal. For example, "━" and "┃" in GB18030 will span two columns.
 *
 * To cope with this, the general strategy for building transition and
 * continuation matrices is:
 *
 * 1. Call `locale_to_utf8` to convert the list of pipe characters into a UTF-8
 *    encoded string. If the supplied characters are hard-coded presets or the
 *    user's locale is (sensibly) using UTF-8, this will simply copy the bytes.
 *    We do this because it is trivial to split a UTF-8-encoded string into
 *    characters, but impossible in an arbitrary encoding without prior
 *    knowledge of the encoding scheme.
 *
 * 2. Call `utf8_to_locale` with the UTF-8-encoded bytes to convert the pipe
 *    characters into a nul-separated list of multibyte characters encoded in
 *    the user's locale.
 *
 * 3. Call `assign_matrices` to assign the nul-separated locale-encoded
 *    characters to the transition matrix and list of continuation characters.
 *
 * 4. Call `multicolumn_adjust` to detect any characters that are encoded in
 *    multiple columns. This will adjust the values of the `states` global,
 *    ensuring that we always move the cursor by the correct increment. This
 *    affects the functions `wrap_pipe`, `move_pipe` and `init_pipe`, which
 *    must take care not to let half a multicolumn character fall of the right
 *    margin of the terminal and not to initialise pipes on half-character
 *    boundaries.
 */

static bool utf8_continuation(char byte);
static size_t charwidth(const char *pipe_char);

//The states describe the current "velocity" of a pipe.  Notice that the allowed
//transitions are given by a change of +/- 1. So, for example, a pipe heading
//left may go up or down but not right.
//              Right    Down   Left    Up
char states[][2] = {{1,0}, {0,1}, {-1,0}, {0,-1}};

const char * transition_char(char **list, int row, int col){
    return list[row * 4 + col];
}

// Number of columns used on the terminal to print a given pipe character.
static size_t charwidth(const char *pipe_char) {
    size_t nwide = mbstowcs(NULL, pipe_char, 0);
    if(nwide == (size_t) -1)
        return (size_t) -1;
    wchar_t wide_buf[nwide + 1];
    mbstowcs(wide_buf, pipe_char, nwide);
    return (size_t) wcswidth(wide_buf, nwide);
}

/** UTF-8 encoded characters have the top two bits encoded as 0b10 if they are
 * continution characters. That is, they can only be seen after a
 * character-start byte.
*/
static bool utf8_continuation(char byte) {
    return ((byte >> 6) & 0b11) == 0b10;
}

/** Convert characters encoded in the user's locale (`from_charset`) to our
 * internal representation, which is UTF-8. This function assumes that
 * `locale_bytes` is nul terminated.
 *
 * locale_bytes:
 *      Input bytes, representing some string of characters in `from_charset`.
 *
 * utf8_bytes:
 *      Output bytes, representing the same characters but encoded in UTF-8.
 *
 * from_charset:
 *      The name of the character set encoding `locale_bytes`.
 *
 * buflen:
 *      Space in bytes available in `utf8_bytes`.
 *
 * This function will return 0 upon success, or a negative number upon error.
 */
cpipes_errno locale_to_utf8(char *locale_bytes, char *utf8_bytes,
        const char *from_charset, size_t buflen) {
    if(!strcmp(from_charset, "UTF-8")){
        // No need to run iconv if we are already in UTF-8
        if(strlen(locale_bytes) >= buflen){
            // Add 1 to strlen for terminating nul
            set_error(ERR_BUFFER_TOO_SMALL, buflen, strlen(locale_bytes) + 1);
            return ERR_BUFFER_TOO_SMALL;
        }
        strncpy(utf8_bytes, locale_bytes, buflen);
        return 0;
    }

    iconv_t cd = iconv_open("UTF-8", from_charset);
    if(cd == (iconv_t) -1) {
        int errno_copy = errno;
        set_error(ERR_ICONV_ERROR);
        add_error_info("%s", strerror(errno_copy));
        return ERR_ICONV_ERROR;
    }

    // Length of string plus terminating nul byte, which we also want to
    // encode.
    size_t in_left = strlen(locale_bytes) + 1;
    size_t out_left = buflen;
    size_t nconv = iconv(cd, &locale_bytes, &in_left, &utf8_bytes, &out_left);

    if(nconv == (size_t) -1){
        int errno_copy = errno;
        set_error(ERR_ICONV_ERROR);
        add_error_info("Error converting pipe characters to UTF-8.");
        add_error_info("%s", strerror(errno_copy));
        iconv_close(cd);
        return ERR_ICONV_ERROR;
    }
    iconv_close(cd);
    return 0;
}


/** Convert a set of *characters* encoded in UTF-8 into nul-separated
 * characters in `to_charset`. This function is used to split a UTF-8 encoded
 * string of characters into a locale-encoded string. Nul bytes are inserted
 * between each character in the encoded string.
 *
 * We do this because it is very easy to split characters in UTF-8, but very
 * difficult to do so in an arbitrary character set.
 *
 * This function assumes that bare nul bytes are not valid in `to_charset`.
 * Since this is the user's locale, this is a fair assumption: it would take
 * real dedication (and masochism) to use an encoding that breaks C's
 * assumption about string termination.
 *
 * utf8_chars:
 *      Input buffer containing a UTF-8-encoded string of characters.
 *
 * out_chars:
 *      Output buffer that will contain `to_charset` encoded string of
 *      nul-separated characters.
 *
 * buflen:
 *      Size in bytes of the `out_chars` buffer.
 *
 * to_charset:
 *      Name of the character set into which we are converting.
 *
 * This function will return 0 on success or a negative number on error.
 */
cpipes_errno utf8_to_locale(
        char *utf8_chars,
        char *out_chars, size_t buflen,
        const char *to_charset){

    iconv_t cd = iconv_open(to_charset, "UTF-8");
    if(cd == (iconv_t) -1){
        int errno_copy = errno;
        set_error(ERR_ICONV_ERROR);
        add_error_info(
            "Error initialising iconv for UTF-8 to %s conversion.",
            to_charset);
        add_error_info("Iconv error: %s", strerror(errno_copy));
        return ERR_ICONV_ERROR;
    }

    char *utf8_char_start = utf8_chars;
    char *locale_char_start = out_chars;
    size_t remaining_bytes = buflen - 1;

    // i is index into utf8 array
    for(size_t i = 1; i <= strlen(utf8_chars); i++) {
        if(remaining_bytes <= 0){
            set_error(ERR_BUFFER_TOO_SMALL, buflen, strlen(utf8_chars));
            iconv_close(cd);
            return ERR_BUFFER_TOO_SMALL;
        }

        if(!utf8_continuation(utf8_chars[i])) {
            // Convert a single character
            size_t inbytes = (size_t) (&utf8_chars[i] - utf8_char_start);
            size_t nconv = iconv(cd,
                &utf8_char_start, &inbytes,
                &locale_char_start, &remaining_bytes);
            if(nconv == (size_t) -1){
                set_error(ERR_ICONV_ERROR);
                add_error_info("Error converting UTF8 to %s", to_charset);
                iconv_close(cd);
                return ERR_ICONV_ERROR;
            }
            (*locale_char_start) = '\0';
            locale_char_start++;
            remaining_bytes--;
        }
    }
    iconv_close(cd);
    return 0;
}

/** Assign transition and continuation characters from nul-separated multibyte
 * characters in `pipe_chars`.
 *
 * The input buffer must contain six characters in the order ━┃┓┛┗┏. If fewer
 * than six characters are present, then this function will continute to read
 * until it hits a nul character somewhere in memory.
 *
 * pipe_chars:
 *      Input buffer containing 6 nul-separated multibyte characters to be
 *      assigned to `transition` and `continuation`. The `char *` pointers
 *      in `transition` and `continuation` point to characters *in this
 *      buffer*, so you can't free this and expect `transition` or
 *      `continuation` to remain valid.
 *
 * transition:
 *      Row-major 4x4 transition matrix. Entries in this matrix initialised
 *      to NULL. Pointers to the transition characters are placed in this
 *      matrix.
 *
 * continuation:
 *      Two-character list containing the horizontal and vertical continuation
 *      characters.
 *
 * This function will return 0 on success or a negative number on error.
 */
void assign_matrices(char *pipe_chars,
        char **transition, char **continuation) {

    continuation[0] = continuation[1] = NULL;
    for(size_t i = 0; i < 16; i++)
        transition[i] = NULL;

    size_t nchars = 0;
    char *c = pipe_chars;
    // "i" indexes bytes, "nchars" indexes characters.
    // "nchars" and "c" are set after the switch statement.
    for(size_t i = 0; nchars < 6; i++){
        if(pipe_chars[i] != '\0')
            continue;
        switch(nchars) {
            // Pipe continuation characters ━,┃
            case 0:
            case 1:
                continuation[nchars] = c;
                break;
            // Transition chars go ┓,┛,┗,┏
            case 2:
                transition[CPIPES_RIGHT * 4 + CPIPES_DOWN] = c;
                transition[CPIPES_UP * 4 + CPIPES_LEFT] = c;
                break;
            case 3:
                transition[CPIPES_RIGHT * 4 + CPIPES_UP] = c;
                transition[CPIPES_DOWN * 4 + CPIPES_LEFT] = c;
                break;
            case 4:
                transition[CPIPES_LEFT * 4 + CPIPES_UP] = c;
                transition[CPIPES_DOWN * 4 + CPIPES_RIGHT] = c;
                break;
            case 5:
                transition[CPIPES_LEFT * 4 + CPIPES_DOWN] = c;
                transition[CPIPES_UP * 4 + CPIPES_RIGHT] = c;
                break;
            default:
                // No way to reach here.
                return;
        }
        nchars++;
        c = &pipe_chars[i + 1];
    }
}

/** Adjust possible states (i.e. the `states` global) to reflect width of
 * continuation chars. If the pipe continuation characters take two columns to
 * display, alter the possible left/right pipe velocities to reflect that.
 *
 * This function will ERR_C_ERROR on error (e.g. invalid byte sequence) or 0
 * on success.
 */
cpipes_errno multicolumn_adjust(char **continuation) {
    size_t width = max(charwidth(continuation[0]), charwidth(continuation[1]));
    if(width == (size_t) -1) {
        set_error(ERR_C_ERROR, "charwidth");
        return ERR_C_ERROR;
    }
    states[0][0] = width;
    states[2][0] = -width;
    return 0;
}

/** Initialise a pipe. If there are multicolumn characters in use, this
 * function makes sure to only assign initial positions at full-character
 * boundaries.
 */
cpipes_errno init_pipe(struct pipe *pipe, struct canvas *canvas,
        int initial_state, unsigned int max_len) {
    // Multicolumn chars shouldn't be placed off the end of the screen
    size_t colwidth = max(states[0][0], -states[2][0]);
    unsigned int width = canvas->width;
    width -= canvas->width % colwidth;

    if(initial_state < 0)
        pipe->state = randrange(0, 4);
    else
        pipe->state = initial_state;
    random_pipe_color(pipe, &canvas->palette);
    pipe->length = 0;
    pipe->x = randrange(0, width / colwidth) * colwidth;
    pipe->y = randrange(0, canvas->height / colwidth) * colwidth;

    // Initialise location buffer, or set it to NULL if max_len is 0
    if(max_len) {
        pipe->locations = malloc(sizeof(*pipe->locations));
        if(!pipe->locations)
            return set_error(ERR_OUT_OF_MEMORY);
        cpipes_errno err = location_buffer_init(pipe->locations, max_len);
        if(err)
            return err;
    } else {
        pipe->locations = NULL;
    }
    return 0;
}

// Free pipe, including the location buffer (if set)
void free_pipe(struct pipe *pipe) {
    if(pipe->locations) {
        location_buffer_free(pipe->locations);
        free(pipe->locations);
    }
}

/** Move a pipe by the amount given by the current state. If
 * `multicolumn_adjust` was called and detected that multicolumn characters are
 * in use, the `states` variable will have been updated to reflect the width of
 * the largest character in use.
 */
void move_pipe(struct pipe *pipe, struct canvas *canvas){
    pipe->x += states[pipe->state][0];
    pipe->y += states[pipe->state][1];
    pipe->length++;
}

/** If a pipe has a maximum length, erase the tail of the pipe. */
void erase_pipe_tail(struct pipe *pipe, struct canvas *canvas) {
    unsigned int *tail = location_buffer_tail(pipe->locations);
    if(tail)
        canvas_erase_tail(canvas, *tail, pipe);
}

/** Wrap a pipe at terminal boundaries.  If there are multi-column continuation
 * characters, wrap the pipe before it gets a chance to spit out incomplete
 * characters.
 */
bool wrap_pipe(struct pipe *pipe, struct canvas *canvas){
    // Take multi-column chars into account
    unsigned int width = canvas->width;
    width -= width % max(states[0][1], -states[2][0]);

    if(pipe->x < 0 || (unsigned int) pipe->x >= width
            || pipe->y < 0 || (unsigned int) pipe->y >= canvas->height){
        if(pipe->x < 0)
            pipe->x = width - 1;
        if(pipe->y < 0)
            pipe->y = canvas->height - 1;
        if((unsigned int) pipe->x >= canvas->width)
            pipe->x = 0;
        if((unsigned int) pipe->y >= canvas->height)
            pipe->y = 0;
        return true;
    }
    return false;
}

void random_pipe_color(struct pipe *pipe, struct palette *palette){
    pipe->color = palette->colors[randrange(0, palette->num_colors)];
}

char flip_pipe_state(struct pipe *pipe){
    char old_state = pipe->state;
    char new_state = pipe->state;
    char flip = randbool(0.5) ? -1 : 1;
    new_state += flip;
    if(new_state < 0) { new_state = 3; }
    else if(new_state > 3){ new_state = 0; }
    pipe->state = new_state;
    pipe->length = 0;
    return old_state;
}

bool should_flip_state(struct pipe *p, int min_len, float prob){
    return p->length > min_len && randbool(prob);
}

