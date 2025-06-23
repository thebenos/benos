#include <stddef.h>
#include <kernel/include/serial.h>

void serial_init(void)
{
    outb(COM1 + SERIAL_IER, 0x00);              // Cancel interrupts
    outb(COM1 + SERIAL_LCR, SERIAL_DLAB_BIT);   // Enable DLAB
    outb(COM1 + SERIAL_DR, 0x01);               // Set low divisor to 3
    outb(COM1 + SERIAL_IER, 0x00);              // Set high divisor to 0
    outb(COM1 + SERIAL_LCR, SERIAL_8N1);        // 8N1
    outb(COM1 + SERIAL_FCR, SERIAL_FIFO_ENABLE);// Activate FIFO
    outb(COM1 + SERIAL_MCR, SERIAL_MODERN_IRQS);// Activate IRQs
}

int serial_ready(void)
{
    return (inb(COM1 + SERIAL_LSR) & 0x20);
}

void serial_putchar(const char c)
{
    while (!serial_ready());
    outb(COM1, c);
}

/*
NEED TO BE FIXED
=========================

void serial_writestr(const char *str)
{
    char c = str[0];
    serial_putchar(c);
}

void serial_writehex(uint64_t value)
{
    const char *hex = "0123456789ABCDEF";
    serial_writestr("0x");

    for (int i = (sizeof(uint64_t) * 2) - 1; i >= 0; i--)
        serial_putchar(hex[(value >> (i * 4)) & 0xf]);
}
*/