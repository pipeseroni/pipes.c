#ifndef LOCATION_BUFFER_H_
#define LOCATION_BUFFER_H_

#include "err.h"

// Circular buffer containing the locations of a pipe
struct location_buffer {
    unsigned int *locations;
    size_t max, size, head;
};

cpipes_errno location_buffer_init(struct location_buffer *buffer, size_t max);
void location_buffer_free(struct location_buffer *buffer);

unsigned int *location_buffer_head(struct location_buffer *buffer);
unsigned int *location_buffer_tail(struct location_buffer *buffer);

void location_buffer_push(struct location_buffer *buffer, unsigned int loc);

#endif /* LOCATION_BUFFER_H_ */

