#pragma once

#include <stdint.h>

#define IDT_SIZE            0xff

typedef struct
{
    uint16_t offset_low;
    uint16_t selector;
    uint8_t ist;
    uint8_t type_attribute;
    uint16_t offset_middle;
    uint32_t offset_high;
    uint32_t zero;
} __attribute__ ((packed)) idt_entry_t;

typedef struct
{
    uint16_t limit;
    uint64_t base;
} __attribute__ ((packed)) idt_ptr_t;

void idt_init();
void idt_set_entry(int n, uint64_t base, uint16_t selector, uint8_t flags);