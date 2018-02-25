#include <config.h>

#include <assert.h>
#include <stdlib.h>
#include <stdbool.h>
#include "util.h"

///Get a random integer in the range [lo, hi).
int randrange(int lo, int hi){
    return randint(lo, hi - 1);
}

///Get a random integer in the range [lo, hi].
int randint(int lo, int hi){
    // Note that the distribution will be biased when (hi - lo) is close to
    // RAND_MAX. This is unlikely to matter for our purposes.
    // See C FAQ 13.16: http://c-faq.com/lib/randrange.html

    assert(lo <= hi /* Range must contain values. */);
    unsigned int nbins = (hi - lo) + 1u;
    unsigned int nrands = RAND_MAX + 1u;
    assert(nbins <= nrands /* Cannot generate > RAND_MAX possible values. */);

    unsigned int r = rand();
    int y = r / (nrands / nbins);
    return y + lo;
}

///Get a random boolean with probability `p` of `true`.
bool randbool(float p){
    assert(0 <= p && p <= 1 /* `p` is a probability. */);
    return rand()  < (RAND_MAX + 1u) * p;
}

int min(int a, int b){
    return (a < b) ? a : b;
}

int max(int a, int b){
    return (a > b) ? a : b;
}
