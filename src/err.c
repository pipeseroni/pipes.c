#include <stdarg.h>
#include <stdio.h>
#include <string.h>

#include "err.h"

// Maximum size of an error message. Any messages longer than this are just
// truncated: I don't want to handle errors within errors.
#define ERR_BUF_SZ 256

// Buffer containing an error message
static char ERR_BUF[ERR_BUF_SZ];
// Offset into ERR_BUF: new messages should be appended after this.
static size_t ERR_OFFSET = 0;

/** These correspond to the numbers PIPES_C_ERRORS multipled by -1. */
static const char *PIPES_C_ERROR_STRINGS[] = {
    "Success. If you see this an error message, please raise an issue!",

    // Parameter 1: Detailed message indicating ncurses error
    "An error was encountered in ncurses: %s.",

    // Parameter 1: Number of colors in the palette
    // Parameter 2: Number of available colors.
    "Too many colors for the terminal to handle were given in the palette."
        " %d colors were specified, but only %d are available.",

    "A color palette was supplied, but the terminal cannot redefine colors.",
    "A color palette was supplied, but the terminal cannot use color.",
    "Error allocating memory.",
    "Terminal did not reply to query.",
    "Buffer (%d items) too small: tried to insert %d items.",
    "Error encountered calling standard library function: %s",
    "An error occurred when calling iconv."
};

static void err_provenance(const char *file, int line, const char *function);

/// Write prefix containing file name, line and function.
static void err_provenance(const char *file, int line, const char *function) {
    ERR_OFFSET += snprintf(ERR_BUF + ERR_OFFSET,
            ERR_BUF_SZ - ERR_OFFSET,
            "[%s:%d (%s)] ", file, line, function);
}


/** Store message in buffer. */
void set_error_(const char *file, int line, const char *function,
        cpipes_errno err_num, ...) {
    err_provenance(file, line, function);

    va_list extra_args;
    va_start(extra_args, err_num);
    ERR_OFFSET += vsnprintf(
            ERR_BUF + ERR_OFFSET, ERR_BUF_SZ - ERR_OFFSET,
            PIPES_C_ERROR_STRINGS[-err_num], extra_args);
    va_end(extra_args);

    // Always terminate with a nul, even if snprintf didn't allow anything to
    // actually be appended.
    ERR_BUF[ERR_BUF_SZ - 1] = '\0';
}

void add_error_info_(const char *file, int line, const char *function,
        const char *fmt, ...) {
    ERR_OFFSET += snprintf(
            ERR_BUF + ERR_OFFSET,
            ERR_BUF_SZ - ERR_OFFSET,
            "%s", "\n");
    err_provenance(file, line, function);

    va_list extra_args;
    va_start(extra_args, fmt);
    ERR_OFFSET += vsnprintf(
            ERR_BUF + ERR_OFFSET, ERR_BUF_SZ - ERR_OFFSET,
            fmt, extra_args);
    va_end(extra_args);
}

/** Clear error buffer. */
void clear_error(void) {
    ERR_BUF[0] = '\0';
    ERR_OFFSET = 0;
}


void print_error(void) {
    fprintf(stderr, "%s\n", ERR_BUF);
}

const char *string_error(void) {
    return ERR_BUF;
}
