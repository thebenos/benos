#ifndef IO_H
#define IO_H

#include "../../klibc/stdtype.h"

#define CLI         asm("cli"::)
#define STI         asm("sti"::)

static inline ubyte_t inb(uword_t port)
{
    ubyte_t val;
    asm volatile (
        "inb %1, %0"
        : "=a"(val)
        : "Nd"(port)
    );
    return val;
}

static inline void outb(uword_t port, ubyte_t val)
{
    asm volatile (
        "outb %0, %1"
        :
        : "a"(val), "Nd"(port)
    );
}

#endif