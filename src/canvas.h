#ifndef CANVAS_H_
#define CANVAS_H_

#include <stddef.h>
#include <stdint.h>
#include "err.h"

struct pipe;
struct pipe_cell_list;

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
    struct pipe_cell_list *cells;
};

cpipes_errno canvas_init(
        struct canvas *canvas,
        unsigned int width, unsigned int height);
cpipes_errno canvas_resize(
        struct canvas *canvas,
        unsigned int width, unsigned int height);
void canvas_free(struct canvas *canvas);
void canvas_erase_tail(struct canvas *c,
        unsigned int tail, struct pipe *p);

// Circular buffer containing the locations of a pipe
struct location_buffer {
    unsigned int *locations;
    size_t max, size, head;
};

cpipes_errno location_buffer_init(struct location_buffer *buffer, size_t max);
void location_buffer_free(struct location_buffer *buffer);

unsigned int *location_buffer_head(struct location_buffer *buffer);
unsigned int *location_buffer_tail(struct location_buffer *buffer);

void location_buffer_push(struct location_buffer *buffer, unsigned int loc);

#endif /* CANVAS_H_ */

