#include <tap.h>

#include <location_buffer.h>

#define BUF_SZ 3

int main(int argc, char **argv) {
    plan(13);

    struct location_buffer buf;
    location_buffer_init(&buf, BUF_SZ);
    cmp_ok(buf.max, "==", BUF_SZ, "Inited size to %d", BUF_SZ);
    cmp_ok(buf.size, "==", 0, "Inited size is 0");
    cmp_ok(buf.head, "==", 0, "Initial head is 0");

    ok(location_buffer_head(&buf) == NULL, "Default head is NULL");
    ok(location_buffer_tail(&buf) == NULL, "Default tail is NULL");

    diag("Pushing '1' to buf");
    location_buffer_push(&buf, 1);
    cmp_ok(*location_buffer_head(&buf), "==", 1, "Head points to '1'");
    cmp_ok(*location_buffer_tail(&buf), "==", 1, "Tail points to '1'");

    diag("Pushing '2' to buf");
    location_buffer_push(&buf, 2);
    cmp_ok(*location_buffer_head(&buf), "==", 2, "Head points to '2'");
    cmp_ok(*location_buffer_tail(&buf), "==", 1, "Tail points to '1'");

    diag("Pushing '3' to buf");
    location_buffer_push(&buf, 3);
    cmp_ok(*location_buffer_head(&buf), "==", 3, "Head points to '3'");
    cmp_ok(*location_buffer_tail(&buf), "==", 1, "Tail points to '1'");

    diag("Pushing '4' to buf: should loop");
    location_buffer_push(&buf, 4);
    cmp_ok(*location_buffer_head(&buf), "==", 4, "Head points to '4'");
    cmp_ok(*location_buffer_tail(&buf), "==", 2, "Tail points to '2'");

    done_testing();
    return 0;
}
