#include <config.h>

#include <stdio.h>
#include <stdbool.h>
#include <string.h>

#include "pipe.h"
#include "err.h"
/**
 * Check locale-encoding functions.
 */
#define NUM_TESTS 30

// TAP-producing ok() function
static int testnum = 1;
static int failures = 0;

static void ok(bool condition, const char* msg);
static void ok(bool condition, const char* msg) {
    printf("%s %d - %s\n", condition ? "ok" : "not ok", testnum++, msg);
    if(!condition)
        failures++;
}

// These are the same in UTF8 and GB18030
const char *UTF8_ASCII = "123";
const char *GB18030_ASCII = "\x31\x32\x33";
const char *GB18030_ASCII_SPLIT = "\x31\0\x32\0\x33";

// These higher characters do differ: ━┃
const char *UTF8_BOX = "\xE2\x94\x81\xE2\x94\x83";
const char *GB18030_BOX = "\xA9\xA5\xA9\xA7";
const char *GB18030_BOX_SPLIT = "\xA9\xA5\0\xA9\xA7";

// Assigned to by assign_matrices
const char test_pipe_chars[] = "1\0" "2\0" "3\0" "4\0" "5\0" "6";
char *transition[16];
char *continuation[2];

int main(int argc, char **argv) {
    int r;

    size_t bufsz = 10;
    char in[bufsz];
    char out[bufsz];

    printf("1..%d\n", NUM_TESTS);

    // Identity conversion with ASCII bytes
    strcpy(in, UTF8_ASCII);
    r = locale_to_utf8(in, out, "UTF-8", 4);
    ok(r == 0,
        "ASCII UTF8 to UTF8 in 4 bytes: no error code.");
    ok(strcmp(out, UTF8_ASCII) == 0,
        "ASCII UTF8 to UTF8 copied correctly");
    clear_error();

    r = locale_to_utf8(in, out, "UTF-8", 3);
    ok(r == ERR_BUFFER_TOO_SMALL,
        "ASCII UTF8 to UTF8 in 3 bytes: buffer too small.");

    ok(strstr(string_error(), "Buffer (3 items) too small"),
        "Error text contains buffer size.");
    ok(strstr(string_error(), "tried to insert 4 items"),
        "Error text contains inserted size.");
    clear_error();

    // Identity conversion with higher bytes
    strcpy(in, UTF8_BOX);
    r = locale_to_utf8(in, out, "UTF-8", 7);
    ok(r == 0,
        "Box UTF8 to UTF8 in 7 bytes: no error code.");
    ok(strcmp(out, UTF8_BOX) == 0,
        "Box UTF8 to UTF8 copied correctly.");
    clear_error();

    r = locale_to_utf8(in, out, "UTF-8", 6);
    ok(r == ERR_BUFFER_TOO_SMALL,
        "Box UTF8 to UTF8 in 6 bytes: buffer too small.");
    clear_error();

    // Convert GB18030 to UTF-8 with ASCII bytes (no change)
    strcpy(in, GB18030_ASCII);
    r = locale_to_utf8(in, out, "GB18030", 4);
    ok(r == 0,
        "ASCII GB18030 to UTF8 in 4 bytes: no error code.");
    ok(strcmp(out, UTF8_ASCII) == 0,
        "ASCII UTF8 to GB18030 copied correctly");
    clear_error();

    r = locale_to_utf8(in, out, "GB18030", 3);
    ok(r == ERR_ICONV_ERROR,
        "ASCII GB18030 to UTF8 in 3 bytes: buffer too small.");
    clear_error();

    // Convert GB18030 to UTF-8 with box-drawing chars
    strcpy(in, GB18030_BOX);
    r = locale_to_utf8(in, out, "GB18030", 7);
    ok(r == 0,
        "Box GB18030 to UTF8 in 7 bytes: no error code.");
    ok(strcmp(out, UTF8_BOX) == 0,
        "Box GB18030 to UTF8 copied correctly.");
    clear_error();

    r = locale_to_utf8(in, out, "GB18030", 6);
    ok(r == ERR_ICONV_ERROR,
        "Box GB18030 to UTF8 in 6 bytes: buffer too small.");
    clear_error();

    // Convert UTF-8 to GB18030 with ASCII bytes
    strcpy(in, UTF8_ASCII);
    r = utf8_to_locale(in, out, 6, "GB18030");
    ok(r == 0,
        "ASCII UTF8 to GB18030 in 6 bytes: no error code.");
    ok(memcmp(out, GB18030_ASCII_SPLIT, 6) == 0,
        "ASCII UTF8 to GB18030 copied correctly.");
    clear_error();

    r = utf8_to_locale(in, out, 5, "GB18030");
    ok(r == ERR_BUFFER_TOO_SMALL,
        "ASCII UTF8 to GB18030 in 5 bytes: buffer too small.");
    clear_error();

    // Convert UTF-8 to GB18030 with box-drawing bytes
    strcpy(in, UTF8_BOX);
    r = utf8_to_locale(in, out, 6, "GB18030");
    ok(r == 0,
        "Box UTF8 to GB18030 in 6 bytes: no error code.");
    ok(memcmp(out, GB18030_BOX_SPLIT, 6) == 0,
        "Box UTF8 to GB18030 copied correctly.");
    clear_error();

    r = utf8_to_locale(in, out, 5, "GB18030");
    ok(r == ERR_ICONV_ERROR,
        "Box UTF8 to GB18030 in 5 bytes: buffer too small.");
    clear_error();

    // Assign transition and continuation matrices
    memcpy(in, test_pipe_chars, sizeof(test_pipe_chars));
    in[sizeof(test_pipe_chars)] = '\0';

    assign_matrices(in, transition, continuation);

    ok(!strcmp(continuation[0], "1"), "HORIZONTAL");
    ok(!strcmp(continuation[1], "2"), "VERTICAL");

    ok(!strcmp(transition[RIGHT * 4 + DOWN], "3"), "RIGHT / DOWN");
    ok(!strcmp(transition[UP * 4 + LEFT], "3"), "UP / LEFT");

    ok(!strcmp(transition[RIGHT * 4 + UP], "4"), "RIGHT / UP");
    ok(!strcmp(transition[DOWN * 4 + LEFT], "4"), "DOWN / LEFT");

    ok(!strcmp(transition[LEFT * 4 + UP], "5"), "LEFT / UP");
    ok(!strcmp(transition[DOWN * 4 + RIGHT], "5"), "DOWN / RIGHT");

    ok(!strcmp(transition[LEFT * 4 + DOWN], "6"), "LEFT / DOWN");
    ok(!strcmp(transition[UP * 4 + RIGHT], "6"), "UP / RIGHT");
    clear_error();
    return (failures > 0) ? 1 : 0;
}
