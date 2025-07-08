#include <cpu/include/io.h>
#include <stdint.h>

void outb(uint16_t port, uint8_t value)
{
    asm volatile("outb %0, %1"::"a"(value), "Nd"(port));
}

uint8_t inb(uint16_t port)
{
    uint8_t ret;
    asm volatile("inb %1, %0":"=a"(ret):"Nd"(port));
    return ret;
}

void io_wait()
{
    asm volatile("outb %%al, $0x80"::"a"(0));
}