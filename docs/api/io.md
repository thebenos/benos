# I/O - Inputs/Outputs

## Overview
I/O ports (Input/Output ports) are special hardware addresses used to communicate directly with devices via the x86 port-mapped I/O mechanism. Unlike memory-mapped registers, I/O ports are accessed using dedicated CPU instructions like in and out.

In BenOS, I/O ports are used to control and read data from low-level hardware components such as:

- the PIT (Programmable Interval Timer),
- the PIC (Programmable Interrupt Controller),
- the PS/2 controller,
- and other similar hardware interfaces.

Functions like `inb()`, `outb()`, etc., provide simple wrappers to perform byte access to these ports.

---

## Related files
- [`kernel/cpu/include/io.h`](https://github.com/thebenos/benos/blob/main/kernel/cpu/include/io.h)
- [`kernel/cpu/io.c`](https://github.com/thebenos/benos/blob/main/kernel/cpu/io.c)

---

## Functions
There are actually three functions used to access I/O ports.

```c
// Source: kernel/cpu/include/io.h

void outb(uint16_t port, uint8_t value);
uint8_t inb(uint16_t port);
void io_wait();
```

- `outb()` sends a given byte to a given port.
- `inb()`: receives a byte from a given port.
- `io_wait()`: creates a delay by sending an information to a port.