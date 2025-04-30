#include "../klibc/stdlib.h"

void *mem_copy(void *dest, const void *src, udword_t n)
{
    ubyte_t *d = (ubyte_t *) dest;
    const ubyte_t *s = (ubyte_t *) src;

    while (n--)
        *d++ = *s++;

    return dest;
}