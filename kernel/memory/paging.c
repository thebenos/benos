#define __MEMORY__

#include "../include/paging.h"

void init_memory(void)
{
        udword_t page_addr;
        int i, pg;

        for (pg = 0; pg < RAM_MAXPAGE / 8; pg++)
                memory_bitmap[pg] = 0;

        for (pg = PAGE(0x0); pg < PAGE(0x20000); pg++) 
                set_page_frame_used(pg);

        for (pg = PAGE(0xA0000); pg < PAGE(0x100000); pg++) 
                set_page_frame_used(pg);

        pd0 = (udword_t*) get_page_frame();
        pt0 = (udword_t*) get_page_frame();

        pd0[0] = (udword_t) pt0;
        pd0[0] |= 3;
        for (i = 1; i < 1024; i++)
                pd0[i] = 0;

        page_addr = 0;
        for (pg = 0; pg < 1024; pg++) {
                pt0[pg] = page_addr;
                pt0[pg] |= 3;
                page_addr += 4096;
        }

        asm("   mov %0, %%eax \n \
                mov %%eax, %%cr3 \n \
                mov %%cr0, %%eax \n \
                or %1, %%eax \n \
                mov %%eax, %%cr0"::"m"(pd0), "i"(PAGING_FLAG));
}

byte_t *get_page_frame(void)
{
    int byte, bit;
    int page = -1;

    for (byte = 0; byte < RAM_MAXPAGE / 8; byte++)
        if (memory_bitmap[byte] != 0xff)
            for (bit = 0; bit < 8; bit++)
                if (!(memory_bitmap[byte] & (1 << bit)))
                {
                    page = 8 * byte + bit;
                    set_page_frame_used(page);

                    return (byte_t *) (page * PAGE_SIZE);
                }

    return (byte_t *) -1;
}

udword_t *pd_create_task1(void)
{
    udword_t *pd, *pt;
    udword_t i;

    pd = (udword_t *) get_page_frame();
    for (i = 0; i < 1024; i++)
        pd[i] = 0;

    pt = (udword_t *) get_page_frame();
    for (i = 0; i < 1024; i++)
        pt[i] = 0;

    pd[0] = pd0[0];
    pd[0] |= 3;

    pd[USER_OFFSET >> 22] = (udword_t) pt;
    pd[USER_OFFSET >> 22] |= 7;

    pt[0] = USER_OFFSET;
    pt[0] |= 7;

    return pd;
}