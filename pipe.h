#ifndef PIPE_H_
#define PIPE_H_

//States and transition characters
extern const char states[][2];

//The characters to represent a travelling (or extending, I suppose) pipe.
extern const char* unicode_pipe_chars[];
extern const char* ascii_pipe_chars[];

//Represents a pipe
struct pipe {
    unsigned char state;
    unsigned short colour;
    unsigned short length;
    int x, y;
};

void init_pipe(struct pipe *pipe, int ncolours, int initial_state,
        int width, int height);
void move_pipe(struct pipe *pipe);
bool wrap_pipe(struct pipe *pipe, int width, int height);
char flip_pipe_state(struct pipe *pipe);
void random_pipe_colour(struct pipe *pipe, int ncolours);
bool should_flip_state(struct pipe *p, int min_len, float prob);
char pipe_char(struct pipe *p, char old_state);

extern const char *trans_ascii[];
extern const char *trans_unicode[];
const char * transition_char(const char **list, int row, int col);

#endif //PIPE_H_
