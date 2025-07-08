#include <drivers/include/pic.h>
#include <cpu/include/io.h>
#include <stdint.h>

void pic_send_eoi(uint8_t irq)
{
    if (irq >= 8)
        outb(PIC2_COM, PIC_EOI);
    outb(PIC1_COM, PIC_EOI);
}

void pic_remap(int offset1, int offset2)
{
    outb(PIC1_COM, ICW1_INIT | ICW1_ICW4);
    io_wait();
    outb(PIC2_COM, ICW1_INIT | ICW1_ICW4);
    io_wait();

    outb(PIC1_DATA, offset1);
    io_wait();
    outb(PIC2_DATA, offset2);
    io_wait();

    outb(PIC1_DATA, 4);
    io_wait();
    outb(PIC2_DATA, 2);
    io_wait();

    outb(PIC1_DATA, ICW4_8086);
    io_wait();
    outb(PIC2_DATA, ICW4_8086);
    io_wait();

    outb(PIC1_DATA, 0);
    outb(PIC2_DATA, 0);
}

void pic_disable()
{
    outb(PIC1_DATA, 0xff);
    outb(PIC2_DATA, 0xff);
}

void irq_set_mask(uint8_t irqline)
{
    uint16_t port;
    uint8_t value;

    if(irqline < 8)
        port = PIC1_DATA;
    else
    {
        port = PIC2_DATA;
        irqline -= 8;
    }
    value = inb(port) | (1 << irqline);
    outb(port, value);
}

void irq_clear_mask(uint8_t irqline)
{
    uint16_t port;
    uint8_t value;

    if(irqline < 8)
        port = PIC1_DATA;
    else
    {
        port = PIC2_DATA;
        irqline -= 8;
    }
    value = inb(port) & ~(1 << irqline);
    outb(port, value);
}

uint16_t pic_get_irr()
{
    return __pic_get_irq_reg(PIC_READ_IRR);
}

uint16_t pic_get_isr()
{
    return __pic_get_irq_reg(PIC_READ_ISR);
}