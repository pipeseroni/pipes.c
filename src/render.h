#ifndef RENDER_H_
#define RENDER_H_
#include <signal.h>
#include <stddef.h>
#include <stdint.h>
#include "pipe.h"
#include "err.h"

struct palette {
    uint32_t *colors;
    size_t num_colors;
};

struct color_backup {
    size_t num_colors;
    char **escape_codes;
};

typedef void (*anim_function)(unsigned int width, unsigned int height,
        void *data);

cpipes_errno init_color_palette(uint32_t *colors, size_t num_colors,
        struct palette *palette, struct color_backup *backup);

void init_colors(void);
void animate(int fps, anim_function renderer,
        unsigned int *width, unsigned int *height,
        volatile sig_atomic_t *interrupted, void *data);
void render_pipe(struct pipe *p, char **trans, char **pipe_chars,
        int old_state, int new_state);

void palette_destroy(struct palette *palette);
cpipes_errno create_color_backup(size_t num_colors,
        struct color_backup *backup);
void restore_colors(struct color_backup *backup);
void free_colors(struct color_backup *backup);

#endif //RENDER_H_
