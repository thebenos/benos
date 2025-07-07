#include "drivers/include/ps2.h"
#include <drivers/include/pic.h>
#include <drivers/include/kbd.h>
#include <drivers/include/kbd.h>
#include <display/include/colors.h>
#include <display/include/console.h>
#include <include/interrupts.h>
#include <stdint.h>
#include <asm/asm.h>

void isr_default()
{
    console_writestr("Default interrupt", GRAY, BLACK);
}

void isr_except_pf(registers_t* regs)
{
    uint64_t faulting_address;
    uint64_t rip;

    asm volatile ("mov %%cr2, %0" : "=r"(faulting_address));

    rip = regs->rip;

    console_writestr("[ EXC:#PF ] Page fault at ", RED, BLACK);

    console_memdump((uint8_t*)&faulting_address, 8, RED, BLACK);
    console_memdump((uint8_t*)&rip, 8, RED, BLACK);

    HLT;
}

void isr_except_gp(registers_t* regs)
{
    uint64_t rip = regs->rip;

    console_writestr("[ EXC:#GP ] General protection fault. Debug infos below:\n", RED, BLACK);
    console_writestr("        RIP: ", RED, BLACK);

    console_memdump((uint8_t*)&rip, 8, RED, BLACK);

    HLT;
}

void isr_except_df()
{
    console_writestr("[ EXC:#DF ] Double fault. System halted.\n", RED, BLACK);
    HLT;
}

void isr_except_de(registers_t *regs)
{
    console_writestr("[ EXC:#DE ] Division by zero.\n", RED, BLACK);
    HLT;
}

void isr_except_ts(registers_t *regs)
{
    console_writestr("[ EXC:#TS ] Invalid TSS.\n", RED, BLACK);
    HLT;
}

void isr_irq_pit(registers_t *regs)
{
    static int64_t tic = 0;
    static int64_t second = 0;

    tic++;
    if (tic % 100 == 0)
    {
        second++;
        tic = 0;
        console_writestr("tick\n", GRAY, BLACK);
    }

    pic_send_eoi(0);
}

void isr_irq_keyboard(registers_t *regs)
{
    uint8_t scancode = inb(KBD_DATA);
    // debug
    console_writehex(scancode, GRAY, BLACK);
    // enddebug
    char c = kbd_scancode_to_char(scancode);
    if (c != 0)
    {
        char str[2] = { c, '\0' };
        console_writestr(str, GRAY, BLACK);
    }
    pic_send_eoi(1);
}