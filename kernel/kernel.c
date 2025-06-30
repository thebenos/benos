#include <stdint.h>
#include <kernel/include/bootinfo.h>
#include <kernel/include/serial.h>

void kernel_main(uint64_t mb2_info_addr)
{
    serial_init();

    parse_mb2(mb2_info_addr);

    /*
        Print whatever you want in COM1 using the following functions:
        - serial_putchar() to print a single character
        - serial_writestr() to print a string

    */
    serial_writestr("Hello world!\n\r");

    while (1) { asm volatile ("hlt"); }
}