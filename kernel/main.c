#include "../klibc/stdio.h"
#include "include/gdt.h"
#include "../drivers/pic/include/idt.h"
#include "../drivers/include/io.h"
#include "include/tss.h"

void init_PIC(void);

void task1()
{
    STI;
    println("[ OK ] Switched to ring 3");
    while (1);
} __attribute__ ((noreturn))

void kernel_start(void)
{
    init_cursor(&cursor, 0, 0, ' ', ' ');
    println("[ OK ] Cursor initialized");

    init_IDT();
    println("[ OK ] IDT loaded");

    init_PIC();
    println("[ OK ] PIC configured");

    init_GDT();
    println("[ OK ] New GDT loaded");

    CLI;

    asm(
        "movw $0x18, %ax \n"
        "movw %ax, %ss \n"
        "movl $0x20000, %esp"
    );

    asm(
        "cli \n"
        "push $0x33 \n"
        "push $0x30000 \n"
        "pushfl \n"
        "popl %%eax \n"
        "orl $0x200, %%eax \n"
        "push %%eax \n"
        "push $0x23 \n"
        "push $task1 \n"
        "movl $0x20000, %0 \n"
        "movw $0x2b, %%ax \n"
        "movw %%ax, %%ds \n"
        "iret"
        : "=m" (default_tss.esp0)
        :
    );

    while (1);
}