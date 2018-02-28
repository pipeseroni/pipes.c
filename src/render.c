#include <config.h>

#include <time.h>
#include <signal.h>
#include <curses.h>
#include <stdlib.h>
#include "render.h"
#include "pipe.h"

#define NS 1000000000L //1ns

void init_colours(void){
    //Initialise colour pairs if we can.
    if(has_colors()){
        start_color();
        for(short i=1; i < COLORS; i++){
            init_pair(i, i, COLOR_BLACK);
        }
    }
}

void animate(int fps, anim_function renderer,
        unsigned int *width, unsigned int *height,
        volatile sig_atomic_t *interrupted, void *data){
    //Store start time
    struct timespec start_time;
    long delay_ns = NS / fps;

    // Continue while we haven't received a SIGINT
    while(!(*interrupted)){
        int key = getch();

        // If we received a SIGWINCH, update width and height
        if(key == KEY_RESIZE) {
            getmaxyx(stdscr, *height, *width);
        }else if(key != ERR) {
            // Any actual keypresses should quit the program.
            break;
        }

        clock_gettime(CLOCK_REALTIME, &start_time);

        //Render
        (*renderer)(*width, *height, data);

        //Get end time
        struct timespec end_time;
        clock_gettime(CLOCK_REALTIME, &end_time);
        //Work out how long that took
        long took_ns =
              NS * (end_time.tv_sec - start_time.tv_sec)
                 + (end_time.tv_nsec - start_time.tv_nsec);
        //Sleep for delay_ns - render time
        struct timespec sleep_time = {
            .tv_sec  = (delay_ns - took_ns) / NS,
            .tv_nsec = (delay_ns - took_ns) % NS
        };
        nanosleep(&sleep_time, NULL);
    }
}

void render_pipe(struct pipe *p, char **trans, char **pipe_chars,
        int old_state, int new_state){

    move(p->y, p->x);
    attron(COLOR_PAIR(p->colour));
    if(old_state != new_state) {
        addstr(transition_char(trans, old_state, new_state));
    }else{
        addstr(pipe_chars[old_state % 2]);
    }
    attroff(COLOR_PAIR(p->colour));
}
