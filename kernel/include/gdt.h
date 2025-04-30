#ifndef GDT_H
#define GDT_H

#include "../../klibc/stdtype.h"
#include "../../klibc/stdlib.h"
#include "tss.h"

#define GDT_BASE            0x0
#define GDT_SIZE            0xff

typedef struct
{
    uword_t limit0_15;
    uword_t base0_15;
    ubyte_t base16_23;
    ubyte_t access;
    ubyte_t limit16_19 : 4;
    ubyte_t other : 4;
    ubyte_t base24_31;
} __attribute__ ((packed)) GDT_Descriptor;

typedef struct
{
    uword_t limit;
    udword_t base;
} __attribute__ ((packed)) GDTR;

extern void init_GDT_descriptor(udword_t base, udword_t limit, ubyte_t access, ubyte_t other, GDT_Descriptor *descriptor);
extern void init_GDT(void);

#ifdef __GDT__
    GDT_Descriptor gdt_entries[GDT_SIZE];
    GDTR gdtr;
#else
    extern GDT_Descriptor gdt_entries[];
    extern GDTR gdtr;
#endif

#endif