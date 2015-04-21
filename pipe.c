#include <stdlib.h>
#include <stdbool.h>
#include "pipe.h"

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
const char* trans_unicode[][4]  = {
//      R D L U
    {"",         "\u2513",     "",          "\u251B"  }, //R
    {"\u2517",    "",          "\u251B",     0       }, //D
    {"",         "\u250F",     "",          "\u2517"  }, //L
    {"\u250F",    "",          "\u2513",     0       }  //D
};
const char* trans_ascii[][4] = {
//       R D L U
    {"",     "+",    "",      "+"}, //R
    {"+",   "",      "+",    0  }, //D
    {"",     "+",    "",      "+"}, //L
    {"+",   "",      "+",    0  }  //U
};

//The characters to represent a travelling (or extending, I suppose) pipe.
const char* unicode_pipe_chars[] = {"\u2501", "\u2503"};
const char* ascii_pipe_chars[]   = {"-", "|"};

void init_pipe(struct pipe *pipe, int ncolours, int initial_state,
        int width, int height){

    if(initial_state < 0)
        pipe->state = (rand() / (RAND_MAX / 4 + 1));
    else
        pipe->state = initial_state;
    pipe->colour = (rand() / (RAND_MAX / ncolours + 1));
    pipe->length = 0;
    pipe->x = (rand() / (RAND_MAX / width + 1));
    pipe->y = (rand() / (RAND_MAX / height + 1));
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
    pipe->colour = (rand() / (RAND_MAX / ncolours + 1));
}

void flip_pipe_state(struct pipe *pipe){
    char new_state = pipe->state;
    char flip = ((rand() < RAND_MAX/2) ? -1 : 1 );
    new_state += flip;
    if(new_state < 0) { new_state = 3; }
    else if(new_state > 3){ new_state = 0; }
    pipe->state = new_state;
    pipe->length = 0;
}
