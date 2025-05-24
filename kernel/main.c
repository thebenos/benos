#include "../klibc/stdio.h"
#include "../klibc/stdlib.h"
#include "include/gdt.h"
#include "../drivers/pic/include/idt.h"
#include "../drivers/include/io.h"
#include "include/paging.h"
#include "include/tss.h"

int main(void);
void init_PIC(void);

void task1(void)
{
        byte_t *msg = (byte_t *) (USER_OFFSET + 0x100);
        msg[0] = 't';
        msg[1] = 'a';
        msg[2] = 's';
        msg[3] = 'k';
        msg[4] = '1';
        msg[5] = '\n';
        msg[6] = 0;

        asm("mov %0, %%ebx; mov $0x01, %%eax; int $0x30"::"m"(msg));

        while (1);
        return;
}

void kernel_start(void)
{
    init_GDT();
    asm(
        "movw $0x18, %ax \n"
        "movw %ax, %ss \n"
        "movl $0x20000, %esp"
    );

    main();
}

int main(void)
{
    udword_t *pd;

    println("[ OK ] New GDT loaded");

    init_cursor(&cursor, 0, 0, ' ', ' ');
    println("[ OK ] Cursor initialized");

    init_IDT();
    println("[ OK ] IDT loaded");

    init_PIC();
    println("[ OK ] PIC configured");

    init_memory();
    println("[ OK ] Paging enabled");

    STI;

    asm(
        "movw $0x38, %ax \n"
        "ltr %ax"
    );
    println("[ OK ] TR loaded");

    pd = pd_create_task1();
    mem_copy((udword_t *) 0x100000, &task1, 100);
    println("[ OK ] Created new task: task1");

    println("[ OK ] Interrupts enabled");

    println("       Switching to user task");
    asm ("   cli \n \
            movl $0x20000, %0 \n \
            movl %1, %%eax \n \
            movl %%eax, %%cr3 \n \
            push $0x33 \n \
            push $0x40000F00 \n \
            pushfl \n \
            popl %%eax \n \
            orl $0x200, %%eax \n \
            and $0xFFFFBFFF, %%eax \n \
            push %%eax \n \
            push $0x23 \n \
            push $0x40000000 \n \
            movw $0x2B, %%ax \n \
            movw %%ax, %%ds \n \
            iret" : "=m"(default_tss.esp0) : "m"(pd));


    println("[ ERR ] Critical error - halting system");
    asm("hlt");

    while (1);
}