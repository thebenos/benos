#include <stddef.h>
#include <kernel/include/serial.h>
#include <stdint.h>

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

void serial_putchar(char c)
{
    while (!serial_ready());
    outb(COM1, c);
}

char serial_getchar()
{
    while (!(inb(COM1 + SERIAL_LSR) & 0x01));
    return inb(COM1 + SERIAL_DR);
}

void serial_writestr(const char *str)
{
    while (*str)
    {
        serial_putchar(*str);
        str++;
    }
}