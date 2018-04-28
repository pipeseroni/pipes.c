#include <config.h>

#include <stdlib.h>
#include "pipe.h"
#include "pipe_cell_list.h"

struct pipe_cell_list *pipe_cell_list_alloc(void) {
    struct pipe_cell_list *p;
    p = malloc(sizeof(*p));

    pipe_cell_list_init(p);
    return p;
}

void pipe_cell_list_init(struct pipe_cell_list *list) {
    list->head = list->tail = NULL;
}

cpipes_errno pipe_cell_list_push(
        struct pipe_cell_list *list,
        const char *pipe_char, struct pipe *pipe) {

    struct pipe_cell *cell;
    cell = malloc(sizeof(*cell));
    if(!cell)
        return set_error(ERR_OUT_OF_MEMORY);

    cell->pipe_char = pipe_char;
    cell->color = pipe->color;
    cell->pipe = pipe;

    cell->next = list->head;
    cell->prev = NULL;

    if(!list->head)
        list->tail = cell;
    else
        list->head->prev = cell;
    list->head = cell;

    return 0;
}

void pipe_cell_list_remove(struct pipe_cell_list *list, struct pipe *pipe) {
    for(struct pipe_cell *c = list->tail; c; c = c->prev) {
        if(c->pipe == pipe) {
            if(c == list->head)
                list->head = c->next;
            if(c == list->tail)
                list->tail = c->prev;
            if(c->prev)
                c->prev->next = c->next;
            if(c->next)
                c->next->prev = c->prev;
            free(c);
            break;
        }
    }
}

void pipe_cell_list_free(struct pipe_cell_list *list) {
    for(struct pipe_cell *c = list->head; c; c = c->next)
        free(c->prev);
    free(list->tail);
}

