#pragma once

#include <stdint.h>
#include <stddef.h>

#define PAGE_SIZE                       0x1000  // 4KiB per page
#define PAGE_ENTRIES                    512

#define PAGE_PRESENT                    (1ULL << 0)
#define PAGE_WRITABLE                   (1ULL << 1)
#define PAGE_USER                       (1ULL << 2)
#define PAGE_WRITE_THROUGH              (1ULL << 3)
#define PAGE_CACHE_DISABLE              (1ULL << 4)
#define PAGE_ACCESSED                   (1ULL << 5)
#define PAGE_DIRTY                      (1ULL << 6)
#define PAGE_HUGE                       (1ULL << 7)
#define PAGE_GLOBAL                     (1ULL << 8)
#define PAGE_NO_EXEC                    (1ULL << 63)

typedef uint64_t pt_entry_t;

typedef struct
{
    pt_entry_t entries[PAGE_ENTRIES];
} __attribute__((aligned(PAGE_SIZE))) page_table_t;

void vmm_idmap_range(page_table_t *pml4);
void vmm_init();
void vmm_map(uintptr_t vaddr, uintptr_t paddr, uint64_t flags);
void vmm_unmap(uintptr_t vaddr);
uintptr_t vmm_get_paddr(uintptr_t vaddr);