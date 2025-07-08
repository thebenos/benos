# Memory management
Managing memory is something very important in an operating system. Let's see how it works in BenOS...

## PMM - Physical Memory Manager

The physical memory represents the actual amount of RAM available on your hardware that can be allocated by the processor.

### Overview
The PMM is used to manage physical memory using **frames**. In BenOS, each frame has a size of 4KiB.

### Related files
- [`kernel/memory/include/pmm.h`](https://github.com/thebenos/benos/blob/main/kernel/memory/include/pmm.h)
- [`kernel/memory/pmm.c`](https://github.com/thebenos/benos/blob/main/kernel/memory/pmm.c)

### Functions
*All the functions described below are declared in `kernel/memory/include/pmm.h`.*

```c
pmm_init(uint64_t mm_size, uintptr_t bitmap_base);
```
This function initializes the PMM by taking as parameters the physical memory size and the address where to load the bitmap.

```c
uintptr_t pmm_alloc_frame();
void pmm_free_frame(uintptr_t frame);

```
The first function allocates a 4KiB memory frame.
The second function frees a given 4KiB memory frame.

```c
void pmm_mark_used(uintptr_t frame);
void pmm_mark_free(uintptr_t frame);
```
Both functions are used to tell the PMM if a frame is allocated (used) or not (free).