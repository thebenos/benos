#ifndef TSS_H
#define TSS_H

#include "../../klibc/stdtype.h"

typedef struct
{
    uword_t previous_task, __previous_task_unused;
    udword_t esp0;
    uword_t ss0, __ss0_unused;
    udword_t esp1;
    uword_t ss1, __ss1_unused;
    udword_t esp2;
    uword_t ss2, __ss2_unsed;
    udword_t cr3;
    udword_t eip, eflags, eax, ecx, edx, ebx, esp, ebp, esi, edi;
    uword_t es, __es_unused;
    uword_t cs, __cs_unused;
    uword_t ss, __ss_unused;
    uword_t ds, __ds_unused;
    uword_t fs, __fs_unused;
    uword_t gs, __gs_unused;
    uword_t ldt_selector, __ldt_selector_unused;
    uword_t debug_flag, io_map;
} __attribute__ ((packed)) TSS;

extern TSS default_tss;

#endif