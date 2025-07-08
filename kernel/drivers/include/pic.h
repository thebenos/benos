#pragma once

#include <stdint.h>
#include <cpu/include/io.h>

#define PIC1                    0x20
#define PIC2                    0xa0
#define PIC1_COM                PIC1
#define PIC1_DATA               (PIC1 + 1)
#define PIC2_COM                PIC2
#define PIC2_DATA               (PIC2 + 1)
#define PIC_EOI                 0x20

#define ICW1_ICW4               0x01
#define ICW1_SINGLE             0x02
#define ICW1_INTERVAL4          0x04
#define ICW1_LEVEL              0x08
#define ICW1_INIT               0x10

#define ICW4_8086               0x01
#define ICW4_AUTO               0x02
#define ICW4_BUF_SLAVE          0x08
#define ICW4_BUF_MASTER         0x0c
#define ICW4_SFNM               0x10

#define PIC_READ_IRR            0x0a
#define PIC_READ_ISR            0x0b

void pic_send_eoi(uint8_t irq);
void pic_remap(int offset1, int offset2);
void pic_disable();

void irq_set_mask(uint8_t irqline);
void irq_clear_mask(uint8_t irqline);

uint16_t pic_get_irr();
uint16_t pic_get_isr();

static inline uint16_t __pic_get_irq_reg(int ocw3)
{
    outb(PIC1_COM, ocw3);
    outb(PIC2_COM, ocw3);
    return (inb(PIC2_COM) << 8) | inb(PIC1_COM);
}