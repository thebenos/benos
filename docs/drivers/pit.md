# PIT - Programmable Interval Timer

## Overview
The PIT (Programmable Interval Timer) is a hardware timer used in x86 systems to generate interrupts at regular intervals. It plays a key role in OS timekeeping and task scheduling.

In BenOS, the PIT is initialized with a specified frequency to trigger periodic interrupts, which are then handled by the system timer.

---

## Related files
- [`kernel/drivers/include/timer.h`](https://github.com/thebenos/benos/blob/main/kernel/drivers/include/timer.h)
- [`kernel/drivers/timer.c`](https://github.com/thebenos/benos/blob/main/kernel/drivers/timer.c)

---

## Constants
These values are typically used to configure the PIT:
- **Command port:** `0x43`  
- **Channel 0 data port:** `0x40`  
- **Default frequency:** `1193180` Hz (hardware constant of the PIT)

---

## Functions

```c
void pit_init(uint64_t frequency);
```

Initializes the PIT to the specified frequency (in Hz).  
It computes the divisor from the base frequency (1193180 Hz), then sends the configuration and divisor to the PIT.

---

## Example
```c
pit_init(100); // Initializes the PIT to 100 Hz (every 10ms)
```
