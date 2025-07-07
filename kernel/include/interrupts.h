#pragma once

#include <stdint.h>

typedef struct registers
{
    uint64_t r15, r14, r13, r12, r11, r10, r9, r8;
    uint64_t rsi, rdi, rbp, rdx, rcx, rbx, rax;
    uint64_t int_no, err_code;
    uint64_t rip, cs, rflags, rsp, ss;
} registers_t;

void isr_default();
void isr_except_pf(registers_t *regs);
void isr_except_gp(registers_t *regs);
void isr_except_df();
void isr_except_de(registers_t *regs);
void isr_except_ts(registers_t *regs);
void isr_irq_pit(registers_t *regs);
void isr_irq_keyboard(registers_t *regs);