#include <cpu/include/gdt.h>
#include <stdint.h>

gdt_entry_t gdt[7];
gdt_ptr_t gdt_ptr;

extern void gdt_flush(uint64_t);

static void gdt_set_entry(int n, uint32_t base, uint32_t limit, uint8_t access, uint8_t flags)
{
    gdt[n].limit_low = (limit & 0xffff);
    gdt[n].base_low = (base & 0xffff);
    gdt[n].base_middle = (base >> 16) & 0xff;
    gdt[n].access = access;
    gdt[n].granularity = ((limit >> 16) & 0x0f) | (flags & 0xf0);
    gdt[n].base_high = (base >> 24) & 0xff;
}

void gdt_init()
{
    gdt_ptr.limit = sizeof(gdt) - 1;
    gdt_ptr.base = (uint64_t) &gdt;

    gdt_set_entry(0, 0, 0, 0x00, 0x00);             // null
    gdt_set_entry(1, 0, 0xffff,     0x9A, 0x00);    // 16-bit code
    gdt_set_entry(2, 0, 0xffff,     0x92, 0x00);    // 16-bit data
    gdt_set_entry(3, 0, 0xffffffff, 0x9A, 0xC0);    // 32-bit code (D=1, G=1)
    gdt_set_entry(4, 0, 0xffffffff, 0x92, 0xC0);    // 32-bit data
    gdt_set_entry(5, 0, 0,          0x9A, 0x20);    // 64-bit code (L=1)
    gdt_set_entry(6, 0, 0,          0x92, 0x00);    // 64-bit data

    gdt_flush((uint64_t) &gdt_ptr);
}