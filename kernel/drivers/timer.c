#include <drivers/include/timer.h>
#include <cpu/include/io.h>

void pit_init(uint64_t frequency)
{
    int divisor = PIT_DEFAULT_HZ / frequency;
    outb(0x43, 0x36);
    outb(0x40, divisor & 0xff);
    outb(0x40, divisor >> 8);
}