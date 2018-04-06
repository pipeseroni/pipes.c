#include <config.h>

#include <errno.h>
#include <iconv.h>
#include <langinfo.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <wchar.h>
#include "pipe.h"
#include "util.h"
#include "render.h"

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
 * This function will return 0 upon success, or -1 upon error. Error messages
 * will be written to standard output.
 */
int locale_to_utf8(char *locale_bytes, char *utf8_bytes,
        const char *from_charset, size_t buflen) {
    if(!strcmp(from_charset, "UTF-8")){
        // No need to run iconv if we are already in UTF-8
        if(strlen(locale_bytes) >= buflen){
            fprintf(stderr, "Output buffer too small.\n");
            return -1;
        }
        strncpy(utf8_bytes, locale_bytes, buflen);
        return 0;
    }

    iconv_t cd = iconv_open("UTF-8", from_charset);
    if(cd == (iconv_t) -1) {
        perror("Error intialising iconv for charset conversion.");
        return -1;
    }

    // Length of string plus terminating nul byte, which we also want to
    // encode.
    size_t in_left = strlen(locale_bytes) + 1;
    size_t out_left = buflen;
    size_t nconv = iconv(cd, &locale_bytes, &in_left, &utf8_bytes, &out_left);

    if(nconv == (size_t) -1){
        perror("Error converting pipe chars to UTF-8");
        iconv_close(cd);
        return -1;
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
 * This function will return 0 on success or -1 on failre. Error messages are
 * printed to stderr on error.
 */
int utf8_to_locale(
        char *utf8_chars,
        char *out_chars, size_t buflen,
        const char *to_charset){

    iconv_t cd = iconv_open(to_charset, "UTF-8");
    if(cd == (iconv_t) -1){
        perror("Error converting characters");
        return -1;
    }

    char *utf8_char_start = utf8_chars;
    char *locale_char_start = out_chars;
    size_t remaining_bytes = buflen - 1;

    // i is index into utf8 array
    for(size_t i = 1; i <= strlen(utf8_chars); i++) {
        if(remaining_bytes <= 0){
            fprintf(stderr, "Output buffer too small\n");
            iconv_close(cd);
            return -1;
        }

        if(!utf8_continuation(utf8_chars[i])) {
            // Convert a single character
            size_t inbytes = (size_t) (&utf8_chars[i] - utf8_char_start);
            size_t nconv = iconv(cd,
                &utf8_char_start, &inbytes,
                &locale_char_start, &remaining_bytes);
            if(nconv == (size_t) -1){
                perror("Error converting UTF8 to target locale");
                iconv_close(cd);
                return -1;
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
 * This function will return 0 on success or -1 on error.
 */
int assign_matrices(char *pipe_chars,
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
                transition[RIGHT * 4 + DOWN] = c;
                transition[UP * 4 + LEFT] = c;
                break;
            case 3:
                transition[RIGHT * 4 + UP] = c;
                transition[DOWN * 4 + LEFT] = c;
                break;
            case 4:
                transition[LEFT * 4 + UP] = c;
                transition[DOWN * 4 + RIGHT] = c;
                break;
            case 5:
                transition[LEFT * 4 + DOWN] = c;
                transition[UP * 4 + RIGHT] = c;
                break;
            default:
                // No way to reach here.
                return -1;
        }
        nchars++;
        c = &pipe_chars[i + 1];
    }
    return 0;
}

/** Adjust possible states (i.e. the `states` global) to reflect width of
 * continuation chars. If the pipe continuation characters take two columns to
 * display, alter the possible left/right pipe velocities to reflect that.
 *
 * This function will return -1 on error (e.g. invalid byte sequence) or 0
 * on success.
 */
int multicolumn_adjust(char **continuation) {
    size_t width = max(charwidth(continuation[0]), charwidth(continuation[1]));
    if(width == (size_t) -1)
        return -1;
    states[0][0] = width;
    states[2][0] = -width;
    return 0;
}

/** Initialise a pipe. If there are multicolumn characters in use, this
 * function makes sure to only assign initial positions at full-character
 * boundaries.
 */
void init_pipe(struct pipe *pipe, struct palette *palette,
        int initial_state,
        unsigned int width, unsigned int height){
    // Multicolumn chars shouldn't be placed off the end of the screen
    size_t colwidth = max(states[0][0], -states[2][0]);
    width -= width % colwidth;

    if(initial_state < 0)
        pipe->state = randrange(0, 4);
    else
        pipe->state = initial_state;
    random_pipe_color(pipe, palette);
    pipe->length = 0;
    pipe->x = randrange(0, width / colwidth) * colwidth;
    pipe->y = randrange(0, height / colwidth) * colwidth;
}

/** Move a pipe by the amount given by the current state. If
 * `multicolumn_adjust` was called and detected that multicolumn characters are
 * in use, the `states` variable will have been updated to reflect the width of
 * the largest character in use.
 */
void move_pipe(struct pipe *pipe){
    pipe->x += states[pipe->state][0];
    pipe->y += states[pipe->state][1];
    pipe->length++;
}

/** Wrap a pipe at terminal boundaries.  If there are multi-column continuation
 * characters, wrap the pipe before it gets a chance to spit out incomplete
 * characters.
 */
bool wrap_pipe(struct pipe *pipe, unsigned int width, unsigned int height){
    // Take multi-column chars into account
    width -= width % max(states[0][1], -states[2][0]);

    if(pipe->x < 0 || (unsigned int) pipe->x >= width
            || pipe->y < 0 || (unsigned int) pipe->y >= height){
        if(pipe->x < 0){ pipe->x += width; }
        if(pipe->y < 0){ pipe->y += height; }
        if((unsigned int) pipe->x >= width) {pipe->x -= width; }
        if((unsigned int) pipe->y >= height) {pipe->y -= height; }
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

