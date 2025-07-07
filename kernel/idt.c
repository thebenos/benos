#include <include/idt.h>
#include <stdint.h>

idt_entry_t idt[IDT_SIZE];
idt_ptr_t idt_ptr;

extern void idt_flush(uint64_t);

void _asm_default();
void _asm_except_pf();
void _asm_except_gp();
void _asm_except_df();
void _asm_except_de();
void _asm_except_ts();
void _asm_irq_pit();
void _asm_irq_keyboard();

void idt_set_entry(int n, uint64_t base, uint16_t selector, uint8_t flags)
{
    idt[n].offset_low = base & 0xffff;
    idt[n].selector = selector;
    idt[n].ist = 0;
    idt[n].type_attribute = flags;
    idt[n].offset_middle = (base >> 16) & 0xffff;
    idt[n].offset_high = (base >> 32) & 0xffffffff;
    idt[n].zero = 0;
}

void idt_init()
{
    idt_ptr.limit = sizeof(idt) - 1;
    idt_ptr.base = (uint64_t) &idt;

    for (int i = 0; i < IDT_SIZE; i++)
        idt_set_entry(i, (uint64_t) _asm_default, 0x28, 0x8e);

    idt_set_entry(0, (uint64_t) _asm_except_de, 0x28, 0x8e);
    idt_set_entry(8, (uint64_t) _asm_except_df, 0x28, 0x8e);
    idt_set_entry(10, (uint64_t) _asm_except_ts, 0x28, 0x8e);
    idt_set_entry(13, (uint64_t) _asm_except_gp, 0x28, 0x8e);
    idt_set_entry(14, (uint64_t) _asm_except_pf, 0x28, 0x8e);
    idt_set_entry(32, (uint64_t) _asm_irq_pit, 0x28, 0x8e);
    idt_set_entry(33, (uint64_t) _asm_irq_keyboard, 0x28, 0x8e);

    idt_flush((uint64_t) &idt_ptr);
}