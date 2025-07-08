#include <memory/include/mm.h>
#include <memory/include/pmm.h>
#include <memory/include/vmm.h>
#include <asm/asm.h>
#include <include/lib.h>
#include <stdint.h>
#include <display/include/console.h>

static page_table_t *get_page_table(uint64_t paddr)
{
    return (page_table_t *) (paddr + KERNEL_VMA);
}

void vmm_idmap_range(uintptr_t start, size_t length, page_table_t *pml4)
{
    uint64_t flags = PAGE_PRESENT | PAGE_WRITABLE;

    uintptr_t end = start + length;
    for (uintptr_t addr = start; addr < end; addr += PAGE_SIZE)
    {
        size_t pml4_index = (addr >> 39) & 0x1ff;
        size_t pdpt_index = (addr >> 30) & 0x1ff;
        size_t pd_index = (addr >> 21) & 0x1ff;
        size_t pt_index = (addr >> 12) & 0x1ff;

        if (!(pml4->entries[pml4_index] & PAGE_PRESENT))
        {
            uintptr_t pdpt_phys = pmm_alloc_frame();
            memset(get_page_table(pdpt_phys), 0, sizeof(page_table_t));
            pml4->entries[pml4_index] = pdpt_phys | flags;
        }
        page_table_t *pdpt = get_page_table(pml4->entries[pml4_index] & ~0xfffULL);

        if (!(pdpt->entries[pdpt_index] & PAGE_PRESENT)) {
            uintptr_t pd_phys = pmm_alloc_frame();
            memset(get_page_table(pd_phys), 0, sizeof(page_table_t));
            pdpt->entries[pdpt_index] = pd_phys | flags;
        }
        page_table_t *pd = get_page_table(pdpt->entries[pdpt_index] & ~0xfffULL);

        if (!(pd->entries[pd_index] & PAGE_PRESENT)) {
            uintptr_t pt_phys = pmm_alloc_frame();
            memset(get_page_table(pt_phys), 0, sizeof(page_table_t));
            pd->entries[pd_index] = pt_phys | flags;
        }
        page_table_t *pt = get_page_table(pd->entries[pd_index] & ~0xfffULL);

        pt->entries[pt_index] = (addr & ~0xfffULL) | flags;
    }
}

void vmm_init()
{
    uintptr_t pml4_phys = pmm_alloc_frame();
    page_table_t *pml4 = get_page_table(pml4_phys);
    memset(pml4, 0, sizeof(page_table_t));

    vmm_idmap_range(0, 0x200000, pml4);

    cr3_write(pml4_phys);
}