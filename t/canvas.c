#include <tap.h>

#include <pipe.h>
#include <canvas.h>

#define BUF_SZ 3

struct pipe dummy_pipe = {1, 1, 1, 1, 1};

int main(int argc, char **argv) {
    struct canvas c;
    cpipes_errno err;

    diag("This test should be checked with valgrind for memory errors.");
    diag("All memory should be freed by the time the test terminates.");

    diag("Initialising a 2x2 canvas.");
    err = canvas_init(&c, 2, 2);
    cmp_ok(c.width, "==", 2, "Canvas width set to 2.");
    cmp_ok(c.height, "==", 2, "Canvas height set to 2.");
    cmp_ok(err, "==", 0, "No error initialising canvas (err = %d)", err);

    pipe_cell_list_push(&c.cells[3], "A", &dummy_pipe);
    ok(c.cells[3].head->pipe == &dummy_pipe, "Retrieved pipe.");

    diag("Resizing to a 3x1 canvas.");
    canvas_resize(&c, 3, 1);
    cmp_ok(c.width, "==", 3, "Canvas width set to 3.");
    cmp_ok(c.height, "==", 1, "Canvas height set to 1.");

    canvas_free(&c);
    done_testing();
    return 0;
}
