#include <stdlib.h>
#include <stdbool.h>
#include "pipe.h"
#include "util.h"

//The states describe the current "velocity" of a pipe.  Notice that the allowed
//transitions are given by a change of +/- 1. So, for example, a pipe heading
//left may go up or down but not right.
//              Right    Down   Left    Up
const char states[][2] = {{1,0}, {0,1}, {-1,0}, {0,-1}};

//The transition matrices here describe the character that should be output upon
//a transition from] one state (direction) to another. If you wanted, you could
//modify these to include the probability of a transition.
//┓ : U+2513
//┛ : U+251B
//┗ : U+2517
//┏ : U+250F
const char* trans_unicode[]  = {
//      R D L U
    "",         "\u2513",     "",          "\u251B", //R
    "\u2517",    "",          "\u251B",     0      , //D
    "",         "\u250F",     "",          "\u2517", //L
    "\u250F",    "",          "\u2513",     0        //D
};
const char* trans_ascii[] = {
//       R D L U
    "",     "+",    "",      "+", //R
    "+",   "",      "+",    0   , //D
    "",     "+",    "",      "+", //L
    "+",   "",      "+",    0     //U
};

const char * transition_char(const char **list, int row, int col){
    return list[row * 4 + col];
}

//The characters to represent a travelling (or extending, I suppose) pipe.
const char* unicode_pipe_chars[] = {"\u2501", "\u2503"};
const char* ascii_pipe_chars[]   = {"-", "|"};

void init_pipe(struct pipe *pipe, int ncolours, int initial_state,
        int width, int height){

    if(initial_state < 0)
        pipe->state = random_i(0, 4);
    else
        pipe->state = initial_state;
    pipe->colour = random_i(0, ncolours);
    pipe->length = 0;
    pipe->x = random_i(0, width);
    pipe->y = random_i(0, height);
}

void move_pipe(struct pipe *pipe){
    pipe->x += states[pipe->state][0];
    pipe->y += states[pipe->state][1];
    pipe->length++;
}

bool wrap_pipe(struct pipe *pipe, int width, int height){
    if(pipe->x < 0 || pipe->x == width
            || pipe->y < 0 || pipe->y == height){
        if(pipe->x < 0){ pipe->x += width; }
        if(pipe->y < 0){ pipe->y += height; }
        if(pipe->x >= width) {pipe->x -= width; }
        if(pipe->y >= height) {pipe->y -= height; }
        return true;
    }
    return false;
}

void random_pipe_colour(struct pipe *pipe, int ncolours){
    pipe->colour = random_i(0, ncolours);
}

char flip_pipe_state(struct pipe *pipe){
    char old_state = pipe->state;
    char new_state = pipe->state;
    char flip = ((rand() < RAND_MAX/2) ? -1 : 1 );
    new_state += flip;
    if(new_state < 0) { new_state = 3; }
    else if(new_state > 3){ new_state = 0; }
    pipe->state = new_state;
    pipe->length = 0;
    return old_state;
}

bool should_flip_state(struct pipe *p, int min_len, float prob){
    return rand() < prob*RAND_MAX && p->length > min_len;
}

