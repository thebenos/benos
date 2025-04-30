#define __GDT__
#include "include/gdt.h"

void init_GDT_descriptor(udword_t base, udword_t limit, ubyte_t access, ubyte_t other, GDT_Descriptor *descriptor)
{
    descriptor->limit0_15 = (limit & 0xffff);
    descriptor->base0_15 = (base & 0xffff);
    descriptor->base16_23 = (base & 0xff0000) >> 16;
    descriptor->access = access;
    descriptor->limit16_19 = (limit & 0xf0000) >> 16;
    descriptor->other = (other & 0xf);
    descriptor->base24_31 = (base & 0xff000000) >> 24;
    return;
}

void init_GDT(void)
{
    init_GDT_descriptor(0x0, 0x0, 0x0, 0x0, &gdt_entries[0]);
    init_GDT_descriptor(0x0, 0xfffff, 0x9b, 0x0d, &gdt_entries[1]);
    init_GDT_descriptor(0x0, 0xfffff, 0x93, 0x0d, &gdt_entries[2]);
    init_GDT_descriptor(0x0, 0x0, 0x97, 0x0d, &gdt_entries[3]);

    init_GDT_descriptor(0x30000, 0x0, 0xff, 0x0d, &gdt_entries[4]);
    init_GDT_descriptor(0x30000, 0x0, 0xf3, 0x0d, &gdt_entries[5]);
    init_GDT_descriptor(0x0, 0x20, 0xf7, 0x0d, &gdt_entries[6]);

    init_GDT_descriptor((udword_t)&default_tss, 0x67, 0xe9, 0x00, &gdt_entries[7]);

    gdtr.limit = GDT_SIZE * 8;
    gdtr.base = GDT_BASE;

    mem_copy((byte_t *) gdtr.base, (byte_t *) gdt_entries, gdtr.limit);

    asm("lgdtl (gdtr)");

    asm(
        "movw $0x38, %ax \n"
        "ltr %ax"
    );

    asm(
        "movw $0x10, %ax \n"
        "movw %ax, %ds \n"
        "movw %ax, %es \n"
        "movw %ax, %fs \n"
        "movw %ax, %gs \n"
        "ljmp $0x08, $next \n"
        "next :\n"
    );

    asm(
        "movw %%ss, %0 \n"
        "movl %%esp, %1"
        : "=m" (default_tss.ss0),
        "=m" (default_tss.esp0)
        :
    );
}