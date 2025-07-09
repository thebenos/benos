#include "display/include/colors.h"
#include <memory/include/mm.h>
#include <memory/include/pmm.h>
#include <memory/include/vmm.h>
#include <asm/asm.h>
#include <include/lib.h>
#include <stdint.h>
#include <display/include/console.h>

static void *paddr_to_vaddr(uint64_t paddr)
{
    return (void *) (paddr + KERNEL_VMA);
}

void vmm_idmap_range(page_table_t *pml4)
{
    uintptr_t pdpt_phys = pmm_alloc_frame();
    uintptr_t pd_phys = pmm_alloc_frame();
    uintptr_t pt_phys = pmm_alloc_frame();

    page_table_t *pdpt = paddr_to_vaddr(pdpt_phys);
    page_table_t *pd   = paddr_to_vaddr(pd_phys);
    page_table_t *pt   = paddr_to_vaddr(pt_phys);

    memset(pdpt, 0, sizeof(page_table_t));
    memset(pd,   0, sizeof(page_table_t));
    memset(pt,   0, sizeof(page_table_t));

    pml4->entries[0] = pdpt_phys | PAGE_PRESENT | PAGE_WRITABLE;
    pdpt->entries[0] = pd_phys   | PAGE_PRESENT | PAGE_WRITABLE;
    pd->entries[0]   = pt_phys   | PAGE_PRESENT | PAGE_WRITABLE;

    for (int i = 0; i < 512; i++)
        pt->entries[i] = (i * PAGE_SIZE) | PAGE_PRESENT | PAGE_WRITABLE;
}

void vmm_init() {
    uintptr_t pml4_phys = pmm_alloc_frame();
    page_table_t *pml4 = paddr_to_vaddr(pml4_phys);
    memset(pml4, 0, sizeof(page_table_t));

    vmm_idmap_range(pml4);

    cr3_write(pml4_phys);
}