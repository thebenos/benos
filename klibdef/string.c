#include <klibc/string.h>

void *memory_set(void *ptr, dword_t value, size_t num)
{
    ubyte_t *p = (ubyte_t *) ptr;
    while (num--)
        *p++ = (ubyte_t) value;
    return ptr;
}