#ifndef PIPE_CELL_LIST_H_
#define PIPE_CELL_LIST_H_
#include <stdint.h>

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


#endif /* PIPE_CELL_LIST_H_ */

