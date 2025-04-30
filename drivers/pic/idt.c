#include "include/idt.h"

void _ASM_default(void);
void _ASM_irq0(void);
void _ASM_irq1(void);

IDTR idtr;
IDT_Descriptor idt[];

void init_IDT_descriptor(uword_t select, udword_t offset, uword_t type, IDT_Descriptor *descriptor)
{
    descriptor->offset0_15 = (offset & 0xffff);
    descriptor->select = select;
    descriptor->type = type;
    descriptor->offset16_31 = (offset & 0xffff0000) >> 16;
    return;
}

void init_IDT(void)
{
    for (int i = 0; i < IDT_SIZE; i++)
        init_IDT_descriptor(0x08, (udword_t) _ASM_default, INTERRUPT_GATE, &idt[i]);

    init_IDT_descriptor(0x08, (udword_t) _ASM_irq0, INTERRUPT_GATE, &idt[32]);
    init_IDT_descriptor(0x08, (udword_t) _ASM_irq1, INTERRUPT_GATE, &idt[33]);

    idtr.limit = IDT_SIZE * 8;
    idtr.base = IDT_BASE;

    mem_copy((char *) idtr.base, (char *) idt, idtr.limit);

    asm("lidtl (idtr)");
}