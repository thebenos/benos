#pragma once

#include <stdint.h>

#define CLI                 asm volatile ("cli");
#define STI                 asm volatile ("sti");
#define HLT                 asm volatile ("hlt");

static inline uint64_t cr0_read(void)
{
    uint64_t val;
    __asm__ volatile("mov %%cr0, %0" : "=r"(val));
    return val;
}

static inline void cr0_write(uint64_t val)
{
    __asm__ volatile("mov %0, %%cr0" :: "r"(val));
}

static inline uint64_t cr2_read(void)
{
    uint64_t val;
    __asm__ volatile("mov %%cr2, %0" : "=r"(val));
    return val;
}

static inline uint64_t cr3_read(void)
{
    uint64_t val;
    __asm__ volatile("mov %%cr3, %0" : "=r"(val));
    return val;
}

static inline void cr3_write(uint64_t val)
{
    __asm__ volatile("mov %0, %%cr3" :: "r"(val) : "memory");
}

static inline uint64_t cr4_read(void)
{
    uint64_t val;
    __asm__ volatile("mov %%cr4, %0" : "=r"(val));
    return val;
}

static inline void cr4_write(uint64_t val)
{
    __asm__ volatile("mov %0, %%cr4" :: "r"(val));
}

static inline void invlpg(void *addr)
{
    __asm__ volatile("invlpg (%0)" :: "r"(addr) : "memory");
}