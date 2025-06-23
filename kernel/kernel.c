#include <stdint.h>
#include <kernel/include/bootinfo.h>
#include <kernel/include/serial.h>

void kernel_main(uint64_t mb2_info_addr)
{
    serial_init();
    
    /*
        mb2_info_addr will be used later to parse the mb2 infos.
        Use serial_putchar() to display the characters you want in COM1.
    */

    while (1) { asm volatile ("hlt"); }
}