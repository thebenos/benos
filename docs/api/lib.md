# Kernel library

## Overview
The kernel library is a small and lite collection of useful functions for kernel parts, like basic memory management.

---

## Related files
- [`kernel/include/lib.h`](https://github.com/thebenos/benos/blob/main/kernel/include/lib.h)
- [`kernel/lib.c`](https://github.com/thebenos/benos/blob/main/kernel/lib.c)

---

## Library functions
1. memcpy
```c
// Source: kernel/include/lib.h
void *memcpy(void *dest, const void *src, size_t n);
```
This functions copies `n` bytes from `src` to `dest`.

2. memset
```c
// Source: kernel/include/lib.h
void *memset(void *s, int c, size_t n);
```
This function sets `n` bytes of `s` to `c`.

3. memmove
```c
// Source: kernel/include/lib.h
void *memmove(void *dest, const void *src, size_t n);
```
This function moves `n` bytes from `src` to `dest`.

4. memcmp
```c
// Source: kernel/include/lib.h
int memcmp(void *s1, const void *s2, size_t n);
```
This function compares `n` bytes between `s1` and `s2`.