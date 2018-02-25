#ifndef RENDER_H_
#define RENDER_H_
#include "pipe.h"

typedef void (*anim_function)(unsigned int width, unsigned int height,
        void *data);

void init_colours(void);
void animate(int fps, anim_function renderer,
        unsigned int *width, unsigned int *height,
        volatile sig_atomic_t *interrupted, void *data);
void render_pipe(struct pipe *p, char **trans, char **pipe_chars,
        int old_state, int new_state);

#endif //RENDER_H_
