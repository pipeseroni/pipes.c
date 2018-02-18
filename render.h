#ifndef RENDER_H_
#define RENDER_H_
#include "pipe.h"

typedef void (*anim_function)(void *data);

void init_colours();
void animate(int fps, anim_function renderer,
        volatile sig_atomic_t *interrupted, void *data);
void render_pipe(struct pipe *p, const char **trans, const char **pipe_chars,
        int old_state, int new_state);

#endif //RENDER_H_
