# GDT – Global Descriptor Table
This page documents the internal implementation of the GDT setup in BenOS.

## Overview
The GDT is initialized during early kernel boot to setup required segment descriptors in long mode. The segmentation is not really used in long mode, but the GDT is still required for compatibility and TSS loading.

---

## Related files:
- [`kernel/cpu/include.gdt.h`](https://github.com/thebenos/benos/blob/main/kernel/cpu/include/gdt.h)
- [`kernel/cpu/gdt.c`](https://github.com/thebenos/benos/blob/main/kernel/cpu/gdt.c)
- [`kernel/asm/gdt_flush.asm`](https://github.com/thebenos/benos/blob/main/kernel/asm/gdt_flush.asm)

---

## Responsibilities
The GDT setup code handles:

- Declaring and initializing the GDT entries
- Installing the GDT
- Defining 16, 32 and 64-bit segments for kernel code/data

## Initialization flow

---

### 1. GDT structures
The GDT is defined as a static array of descriptors in `kernel/cpu/include/gdt.h`. A pointer structure named `gdt_ptr_t` is passed to `lgdt` to load it in `kernel/asm/gdt_flush.asm`.

```c
// Source: kernel/cpu/include/gdt.h

// The GDT descriptor structure
typedef struct
{
    uint16_t limit_low;
    uint16_t base_low;
    uint8_t base_middle;
    uint8_t access;
    uint8_t granularity;
    uint8_t base_high;
} __attribute__ ((packed)) gdt_entry_t;

// The GDT pointer structure
typedef struct
{
    uint16_t limit;
    uint64_t base;
} __attribute__ ((packed)) gdt_ptr_t;
```

---

### 2. Initialization function
*NOTE: the functions described below depend of the `gdt` array.*

The GDT is initialized using the `gdt_init()` function declared in `kernel/cpu/include/gdt.h`. This function is defined in `kernel/cpu/gdt.c`. First, it sets up the GDT pointer (defined as `gdt_ptr`) and then, it sets up the GDT entries with the `gdt_set_entry()` static function defined in `kernel/cpu/gdt.c` like the following:

```c
// Source: kernel/cpu/gdt.c

static void gdt_set_entry(int n, uint32_t base, uint32_t limit, uint8_t access, uint8_t flags)
{
    // function body here
}
```

`gdt_init()` sets up the following segments:

- Null
- 16-bit code / 16-bit data
- 32-bit code / 32-bit data
- 64-bit code / 64-bit data

Finally, it flushes the GDT using `gdt_flush()` defined in `kernel/asm/gdt_flush.asm`.

```nasm
; Source: kernel/asm/gdt_flush.asm

gdt_flush:
    lgdt [rdi]                      ; gdt_ptr is passed to RDI
    
    mov ax, 0x30
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    pop rdi

    mov ax, 0x28
    push rax
    push rdi
    retfq
    
    ret
```