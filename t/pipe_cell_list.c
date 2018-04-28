#include <stdbool.h>
#include <stddef.h>
#include <stdio.h>
#include <string.h>

#include <tap.h>

#include <pipe.h>
#include <pipe_cell_list.h>

struct pipe pipes[3] = {
    {1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1}
};

static void test_order(const char *order, struct pipe_cell_list *list);

static void test_order(const char *order, struct pipe_cell_list *list) {
    struct pipe_cell *p;
    size_t i = 0;
    for(p = list->head, i = 0; p; p = p->next, i++)
        ok(p->pipe_char[0] == order[i], "pipe char %d is %c", i, order[i]);
    if(i > 0) {
        ok(list->head->pipe_char[0] == order[0],
                "list head is %c", order[0]);
        ok(list->tail->pipe_char[0] == order[strlen(order) - 1],
                "list tail is %c", order[strlen(order) - 1]);
    }
}

int main(int argc, char **argv) {
    plan(25);

    struct pipe_cell_list list;
    pipe_cell_list_init(&list);

    pipe_cell_list_push(&list, "A", &pipes[0]);
    pipe_cell_list_push(&list, "B", &pipes[1]);
    pipe_cell_list_push(&list, "C", &pipes[2]);
    pipe_cell_list_push(&list, "D", &pipes[0]);

    diag("Init list as DCBA");
    test_order("DCBA", &list);

    diag("Remove last pipe with index 0 (A)");
    pipe_cell_list_remove(&list, &pipes[0]);
    test_order("DCB", &list);

    diag("Remove next pipe with index 0 (D)");
    pipe_cell_list_remove(&list, &pipes[0]);
    test_order("CB", &list);

    diag("Remove nonexistent pipe with index 0");
    pipe_cell_list_remove(&list, &pipes[0]);
    test_order("CB", &list);

    diag("Remove pipe with index 1 (B)");
    pipe_cell_list_remove(&list, &pipes[1]);
    test_order("C", &list);

    diag("Remove pipe with index 2 (C)");
    pipe_cell_list_remove(&list, &pipes[2]);
    test_order("", &list);

    diag("Remove nonexistent pipe from zero-length list");
    pipe_cell_list_remove(&list, &pipes[2]);
    test_order("", &list);

    diag("Add pipe with index 0 (E)");
    pipe_cell_list_push(&list, "E", &pipes[0]);
    test_order("E", &list);

    done_testing();
    return 0;
}
