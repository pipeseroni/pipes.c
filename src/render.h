#ifndef RENDER_H_
#define RENDER_H_
#include <signal.h>
#include "pipe.h"

enum COLOR_ERRS {
    ERR_CURSES_ERR = -1,
    ERR_TOO_MANY_COLORS = -2,
    ERR_CANNOT_CHANGE_COLOR = -3,
    ERR_NO_COLOR = -4,
    ERR_OUT_OF_MEMORY = -5
};

struct palette {
    int *colors;
    int num_colors;
};

typedef void (*anim_function)(unsigned int width, unsigned int height,
        void *data);

int init_colour_palette(int *colors, int num_colors, struct palette *palette);

void init_colours(void);
void animate(int fps, anim_function renderer,
        unsigned int *width, unsigned int *height,
        volatile sig_atomic_t *interrupted, void *data);
void render_pipe(struct pipe *p, char **trans, char **pipe_chars,
        int old_state, int new_state);

int * save_color_state(void);
void restore_color_state(int *colors);
void palette_destroy(struct palette *palette);

#endif //RENDER_H_
