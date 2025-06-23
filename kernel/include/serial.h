#pragma once

#include <stdint.h>

#define COM1                0x3f8

#define SERIAL_DR           0
#define SERIAL_IER          1
#define SERIAL_FCR          2
#define SERIAL_LCR          3
#define SERIAL_MCR          4
#define SERIAL_LSR          5

#define SERIAL_DLAB_BIT     0x80
#define SERIAL_8N1          0x03
#define SERIAL_FIFO_ENABLE  0xc7
#define SERIAL_MODERN_IRQS  0x0b

void serial_init(void);
int serial_ready(void);
void serial_putchar(const char c);
void serial_writestr(const char *str);
void serial_writehex(uint64_t value);

static inline void outb(uint16_t port, uint8_t value)
{
    __asm__ volatile ("outb %0, %1" :: "a"(value), "Nd"(port));
}

static inline uint8_t inb(uint16_t port)
{
    uint8_t ret;
    __asm__ volatile ("inb %1, %0" : "=a"(ret) : "Nd"(port));
    return ret;
}