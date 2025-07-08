# Interrupts – IDT and ISRs

This document describes how the Interrupt Descriptor Table (IDT) and Interrupt Service Routines (ISRs) are implemented in BenOS.

## Overview
The IDT is a CPU structure used to handle exceptions, hardware interrupts, and software traps. Each entry in the IDT points to an interrupt or exception handler function (ISR). It is loaded during early kernel initialization.

---

## Related files
- [`kernel/cpu/include/idt.h`](https://github.com/thebenos/benos/blob/main/kernel/cpu/include/idt.h)
- [`kernel/cpu/idt.c`](https://github.com/thebenos/benos/blob/main/kernel/cpu/idt.c)
- [`kernel/asm/idt_flush.asm`](https://github.com/thebenos/benos/blob/main/kernel/asm/idt_flush.asm)
- [`kernel/cpu/include/interrupts.h`](https://github.com/thebenos/benos/blob/main/kernel/cpu/include/interrupts.h)
- [`kernel/cpu/interrupts.c`](https://github.com/thebenos/benos/blob/main/kernel/cpu/interrupts.c)
- [`kernel/cpu/isr.asm`](https://github.com/thebenos/benos/blob/main/kernel/cpu/isr.asm)

---

## Responsibilities
The IDT code is responsible for:

- Defining and populating the IDT entries
- Initializing exception handlers (0–31)
- Initializing hardware interrupt handlers (32–47)
- Loading the IDT

---

*NOTE: Actually, the exception handlers and hardware interrupt handlers are not complete. The IDT can handle:*

*- General Protection Fault (#GP)*

*- Page Fault (#PF)*

*- Double Fault (#DF)*

*- Division Error (#DE)*

*- Invalid TSS (#TS)*

*- IRQ 0 (PIT)*

*- IRQ 1 (Keyboard)*

---

---

## Initialization flow
### 1. IDT structures
The IDT is defined as a static array of descriptors in `kernel/cpu/include/idt.h`. A pointer structure named `idt_ptr_t` is passed to `lidt` to load it in `kernel/asm/idt_flush.asm`.

```c
// Source: kernel/cpu/include/idt.h

// The IDT descriptor structure
typedef struct
{
    uint16_t offset_low;
    uint16_t selector;
    uint8_t ist;
    uint8_t type_attribute;
    uint16_t offset_middle;
    uint32_t offset_high;
    uint32_t zero;
} __attribute__ ((packed)) idt_entry_t;

// The IDT pointer structure
typedef struct
{
    uint16_t limit;
    uint64_t base;
} __attribute__ ((packed)) idt_ptr_t;
```

---

### 2. Initialization function
*NOTE: the functions described below depend of the `idt` array.*

The IDT is initialized using the `idt_init()` function declared in `kernel/cpu/include/idt.h`. This function is defined in `kernel/cpu/idt.c`. First, it sets up the IDT pointer (defined as `idt_ptr`) and then, it sets up the IDT entries with the `idt_set_entry()` function defined in `kernel/cpu/include/idt.h` like the following:

```c
// Source: kernel/cpu/include/idt.h

void idt_set_entry(int n, uint64_t base, uint16_t selector, uint8_t flags);
```

After setting up all the IDT entries, `idt_init()` flushes the IDT using `idt_flush()` defined in `kernel/asm/idt_flush.asm`.

```nasm
; Source: kernel/asm/idt_flush.asm

idt_flush:
    mov rax, rdi
    lidt [rax]
    ret
```