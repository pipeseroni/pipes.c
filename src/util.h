#ifndef UTIL_H_
#define UTIL_H_

#ifdef HAVE_FUNC_ATTRIBUTE_UNUSED
#   define UNUSED __attribute__((unused))
#else
#   define UNUSED
#endif

int randrange(int lo, int hi);
int randint(int lo, int hi);
bool randbool(float p);
int min(int a, int b);
int max(int a, int b);

#endif //UTIL_H_
