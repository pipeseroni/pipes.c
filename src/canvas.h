#ifndef CANVAS_H_
#define CANVAS_H_

#include <stddef.h>
#include <stdint.h>
#include "err.h"

struct palette {
    uint32_t *colors;
    size_t num_colors;
};

struct color_backup {
    size_t num_colors;
    char **escape_codes;
};

struct canvas {
    unsigned int width, height;
    struct palette palette;
    struct color_backup backup;
};

#endif /* CANVAS_H_ */

