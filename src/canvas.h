#ifndef CANVAS_H_
#define CANVAS_H_

#include <stddef.h>
#include <stdint.h>
#include "err.h"

struct pipe;

struct pipe_cell {
    const char *pipe_char;
    uint32_t color;
    struct pipe *pipe;
    struct pipe_cell *next, *prev;
};

struct pipe_cell_list {
    struct pipe_cell *head, *tail;
};

struct pipe_cell_list *pipe_cell_list_alloc(void);
void pipe_cell_list_init(struct pipe_cell_list *list);
cpipes_errno pipe_cell_list_push(
        struct pipe_cell_list *list,
        const char *pipe_char, struct pipe *pipe);
void pipe_cell_list_remove(struct pipe_cell_list *list, struct pipe *pipe);
void pipe_cell_list_free(struct pipe_cell_list *list);

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
