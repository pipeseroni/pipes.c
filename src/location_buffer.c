#include <config.h>

#include <stdlib.h>
#include "location_buffer.h"

cpipes_errno location_buffer_init(struct location_buffer *buffer, size_t max) {
    buffer->locations = malloc(sizeof(*buffer->locations) * max);
    if(!buffer->locations)
        return set_error(ERR_OUT_OF_MEMORY);

    buffer->max = max;
    buffer->size = 0;
    buffer->head = 0;
    return 0;
}
void location_buffer_free(struct location_buffer *buffer) {
    free(buffer->locations);
}

unsigned int *location_buffer_head(struct location_buffer *buffer) {
    if(buffer->size == 0)
        return NULL;
    return &buffer->locations[buffer->head];
}
unsigned int *location_buffer_tail(struct location_buffer *buffer) {
    if(buffer->size == 0)
        return NULL;
    size_t tail = (buffer->head + 1) % buffer->size;
    return &buffer->locations[tail];
}

void location_buffer_push(struct location_buffer *buffer, unsigned int loc) {
    if(buffer->size == 0) {
        buffer->locations[buffer->head] = loc;
        buffer->size++;
    } else if(buffer->size < buffer->max) {
        buffer->locations[++buffer->head] = loc;
        buffer->size++;
    } else {
        buffer->head = (buffer->head + 1) % buffer->size;
        buffer->locations[buffer->head] = loc;
    }
}
