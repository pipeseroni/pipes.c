#ifndef ERR_H_
#define ERR_H_

/** Error numbers returned by various functions. */
enum PIPES_C_ERRORS {
    ERR_CURSES_ERR = -1,
    ERR_TOO_MANY_COLORS = -2,
    ERR_CANNOT_CHANGE_COLOR = -3,
    ERR_NO_COLOR = -4,
    ERR_OUT_OF_MEMORY = -5,
    ERR_QUERY_UNSUPPORTED = -6,
    ERR_BUFFER_TOO_SMALL = -7,
    ERR_C_ERROR = -8,
    ERR_ICONV_ERROR = -9
};

/** This is to make it more obvious which functions return an error and which
 * return a meaningful int. */
typedef enum PIPES_C_ERRORS cpipes_errno;

#define set_error(...) set_error_( \
        __FILE__, __LINE__, __func__, \
        __VA_ARGS__)

#define add_error_info(...) add_error_info_( \
        __FILE__, __LINE__, __func__, \
        __VA_ARGS__)

/** Called by set_error macro with __FILE__, __LINE__ and __func__ */
void set_error_(const char *file, int line, const char *function,
        cpipes_errno err_num, ...);
void add_error_info_(const char *file, int line, const char *function,
        const char *fmt, ...);
void clear_error(void);
void print_error(void);
const char *string_error(void);

#endif /* ERR_H_ */

