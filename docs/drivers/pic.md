# PIC - Programmable Interrupt Controller

## Overview
The Programmable Interrupt Controller (PIC) is responsible for handling hardware interrupts in the system. The x86 architecture traditionally uses two cascaded PICs (Master and Slave), which need to be properly initialized and managed.

In BenOS, the PIC driver provides functions to remap, enable/disable, and query the PIC state. It also allows masking or unmasking specific IRQ lines.

---

## Related files
- [`kernel/drivers/include/pic.h`](https://github.com/thebenos/benos/blob/main/kernel/drivers/include/pic.h)
- [`kernel/drivers/pic.c`](https://github.com/thebenos/benos/blob/main/kernel/drivers/pic.c)

---

## Core functions

```c
void pic_send_eoi(uint8_t irq);
```
Sends an End of Interrupt (EOI) command to the PIC after handling an IRQ.

```c
void pic_remap(int offset1, int offset2);
```
Remaps the PIC interrupts to new vector offsets to avoid conflicts with CPU exceptions.

```c
void pic_disable();
```
Disables all IRQs by masking every line.

```c
void irq_set_mask(uint8_t irqline);
```
Masks (disables) a specific IRQ line.

```c
void irq_clear_mask(uint8_t irqline);
```
Unmasks (enables) a specific IRQ line.

```c
uint16_t pic_get_irr();
```
Returns the current value of the Interrupt Request Register (IRR).

```c
uint16_t pic_get_isr();
```
Returns the current value of the In-Service Register (ISR).
