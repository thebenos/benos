#include "klibc/stdtype.h"
#define __MEMORY__

#include <kernel/include/paging.h>
#include <klibc/string.h>

void init_memory(void)
{
    udword_t *page_dir = get_page_frame();
    memory_set(page_dir, 0, 0x100000);
    for (int page = 0; page < 0x1000 * 512; page++)
    {
        map_page(page_dir, page*0x1000, page*0x1000, 3);
    }
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

    map_page(pd, 0x100000, 0x100000, FLAG_PAGE_PRESENT | FLAG_PAGE_RW | FLAG_PAGE_USER);

    return pd;
}

void map_page(udword_t *pagedir, udword_t physical_page, udword_t virtual_page, udword_t flags)
{
	udword_t directory_index = VADDRESS_PD_OFFSET(virtual_page);
    udword_t table_index = VADDRESS_PT_OFFSET(virtual_page);
    udword_t *page_table;

    if (pagedir[directory_index] & FLAG_PAGE_PRESENT)
        page_table = (udword_t *) (pagedir[directory_index] & 0xfffff000);
    else
    {
        page_table = (udword_t *) get_page_frame();
        for (int i = 0; i < 1024; i++) page_table[i] = 0;
        pagedir[directory_index] = ((udword_t) page_table & 0xfffff000) | (flags & 0xfff) | FLAG_PAGE_PRESENT;
    }

    page_table[table_index] = (physical_page & 0xfffff000) | (flags & 0xfff) | FLAG_PAGE_PRESENT;

    asm("invlpg (%0)" :: "r" (virtual_page) : "memory");
}