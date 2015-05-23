#define _POSIX_C_SOURCE 199309L
#include <time.h>
#include <signal.h>
#include <curses.h>
#include "render.h"

#define NS 1000000000L //1ns

void init_colours(){
    //Initialise colour pairs if we can.
    if(has_colors()){
        start_color();
        for(short i=1; i < COLORS; i++){
            init_pair(i, i, COLOR_BLACK);
        }
    }
}

void animate(int fps, anim_function renderer,
        volatile sig_atomic_t *interrupted, void *data){
    //Store start time
    struct timespec start_time;
    long delay_ns = NS / fps;


    while(!(*interrupted)){
        clock_gettime(CLOCK_REALTIME, &start_time);

        //Render
        (*renderer)(data);

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
