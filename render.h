#ifndef RENDER_H_
#define RENDER_H_

typedef void (*anim_function)(void *data);

void init_colours();
void animate(int fps, anim_function renderer,
        volatile sig_atomic_t *interrupted, void *data);

#endif //RENDER_H_
