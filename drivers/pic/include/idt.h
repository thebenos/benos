#ifndef PIC_IDT_H
#define PIC_IDT_H

#include "../../../klibc/stdtype.h"
#include "../../../klibc/stdlib.h"

#define IDT_BASE            0x800
#define IDT_SIZE            0xff
#define INTERRUPT_GATE      0x8e00

typedef struct
{
    uword_t offset0_15;
    uword_t select;
    uword_t type;
    uword_t offset16_31;
} __attribute__ ((packed)) IDT_Descriptor;

typedef struct
{
    uword_t limit;
    udword_t base;
} __attribute__ ((packed)) IDTR;

extern void init_IDT_descriptor(uword_t select, udword_t offset, uword_t type, IDT_Descriptor *descriptor);
extern void init_IDT(void);
extern IDTR idtr;
extern IDT_Descriptor idt[IDT_SIZE];

#endif