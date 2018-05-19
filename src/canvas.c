#include <config.h>

#include <curses.h>
#include <stdlib.h>
#include "pipe.h"
#include "pipe_cell_list.h"
#include "location_buffer.h"
#include "canvas.h"

/** The canvas "cells" contain a list of the pipe characters (and colors) that
 * have been written to that (x, y) coordinate. Cells are stored in a row-major
 * array.
 *
 * Each cell is a linked list (struct pipe_cell_list) of "struct pipe_cell"s.
 *
 * The cells array is resized using "realloc" to be "width * height" cells. If
 * the number of cells are reduced, then the linked lists are all destroyed
 * before the array is resized.
 */
cpipes_errno canvas_resize(
        struct canvas *canvas,
        unsigned int width, unsigned int height) {

    size_t old_sz = canvas->width * canvas->height;
    size_t new_sz = width * height;
    for(size_t i = new_sz; i < old_sz; i++)
        pipe_cell_list_free(&canvas->cells[i]);

    canvas->cells = realloc(canvas->cells, sizeof(*canvas->cells) * new_sz);
    if(!canvas->cells)
        return set_error(ERR_OUT_OF_MEMORY);

    canvas->width = width;
    canvas->height = height;
    for(size_t i = old_sz; i < new_sz; i++)
        pipe_cell_list_init(&canvas->cells[i]);
    return 0;
}

/// Initialise a blank canvas. The "cells" list for each position is empty.
cpipes_errno canvas_init(
        struct canvas *canvas,
        unsigned int width, unsigned int height) {
    canvas->width = canvas->height = 0;
    canvas->cells = NULL;
    return canvas_resize(canvas, width, height);
}

/// Free canvas and all pipe_cell_lists
void canvas_free(struct canvas *canvas) {
    for(size_t i = 0; i < canvas->width * canvas->height; i++)
        pipe_cell_list_free(&canvas->cells[i]);
    free(canvas->cells);
}

/** Erase the tail of a pipe. We do this by removing the lowest pipe in the "tail" cell.
 * If this changes the "head" of the cell list, we write the new head to that cell.
 * If the cell is left empty, we clear it.
 */
void canvas_erase_tail(struct canvas *c,
        unsigned int tail, struct pipe *p) {
    unsigned int y = tail / c->width;
    unsigned int x = tail % c->width;

    // If the canvas has shrunk, the tail of the pipe can fall outside of the
    // current bounds. The cell should already have been freed and will be
    // invisible, so we can just skip it.
    if(x >= c->width || y >= c->height)
        return;

    struct pipe_cell_list *cells = &c->cells[tail];
    struct pipe_cell *head = cells->head;

    pipe_cell_list_remove(cells, p);
    if(!cells->head) {
        mvaddstr(y, x, " ");
    }else if(head != cells->head) {
        move(y, x);
# if NCURSES_VERSION_MAJOR < 6
        attr_set(A_NORMAL, 1, &c->palette.colors[head->color]);
#else
        attr_set(A_NORMAL, c->palette.colors[head->color], NULL);
#endif
        addstr(head->pipe_char);
        attr_off(A_NORMAL, NULL);
    }
}

