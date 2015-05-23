#include <stdlib.h>
#include "util.h"

///Get a random integer in the range [lo, hi).
int random_i(int lo, int hi){
    return (rand() / (RAND_MAX / (hi - lo) + 1)) + lo;
}

int min(int a, int b){
    return (a < b) ? a : b;
}

int max(int a, int b){
    return (a > b) ? a : b;
}
