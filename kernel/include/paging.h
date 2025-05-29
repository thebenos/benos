#ifndef PAGING_H
#define PAGING_H

#include <klibc/stdtype.h>

#define PAGING_FLAG             0x80000000
#define PD0_ADDRESS             0x20000
#define PT0_ADDRESS             0x21000
#define USER_OFFSET             0x40000000
#define USER_STACK              0xe0000000

#define FLAG_PAGE_PRESENT       0x1
#define FLAG_PAGE_RW            0x2
#define FLAG_PAGE_USER          0x4
#define FLAG_PAGE_DEFAULT       (FLAG_PAGE_PRESENT | FLAG_PAGE_RW)

#define PAGE_SIZE               4096
#define RAM_MAXPAGE             0x10000

#define VADDRESS_PD_OFFSET(address)      ((address) & 0xFFC00000) >> 22
#define VADDRESS_PT_OFFSET(address)      ((address) & 0x003FF000) >> 12
#define VADDRESS_PG_OFFSET(address)      (address) & 0x00000FFF
#define PAGE(address)                    (address) >> 12

#define set_page_frame_used(page)           memory_bitmap[((udword_t) page) / 8] |= (1 << (((udword_t) page) % 8))
#define release_page_frame(page_address)    memory_bitmap[((udword_t) page_address / PAGE_SIZE) / 8] &= ~(1 << (((udword_t) page_address / PAGE_SIZE) % 8))   

#ifdef __MEMORY__
    udword_t *pd0;
    udword_t *pt0;
    ubyte_t memory_bitmap[RAM_MAXPAGE / 8];
#endif

typedef struct
{
    udword_t present: 1;
    udword_t writeable: 1;
    udword_t user: 1;
    udword_t pwt: 1;
    udword_t pcd: 1;
    udword_t accessed: 1;
    udword_t _unused: 1;
    udword_t page_size: 1;
    udword_t global: 1;
    udword_t available: 3;
    udword_t page_table_base: 20;
} __attribute__ ((packed)) PD_Entry;

typedef struct
{
    udword_t present: 1;
    udword_t writeable: 1;
    udword_t user: 1;
    udword_t pwt: 1;
    udword_t pcd: 1;
    udword_t accessed: 1;
    udword_t dirty: 1;
    udword_t pat: 1;
    udword_t global: 1;
    udword_t available: 3;
    udword_t page_base: 20;
} __attribute__ ((packed)) PT_Entry;

void init_memory(void);
void map_page(udword_t *pagedir, udword_t physical_page, udword_t virtual_page, udword_t flags);

byte_t *get_page_frame(void);

udword_t *pd_create_task1(void);

#endif