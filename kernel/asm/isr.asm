extern isr_default, isr_except_pf, isr_except_gp, isr_except_df, isr_except_de, isr_except_ts
extern isr_irq_pit, isr_irq_keyboard
global _asm_default, _asm_except_gp, _asm_except_pf, _asm_except_df, _asm_except_de, _asm_except_ts
global _asm_irq_pit, _asm_irq_keyboard

%macro REGSV 0
    push r15
    push r14
    push r13
    push r12
    push r11
    push r10
    push r9
    push r8
    push rsi
    push rdi
    push rbp
    push rdx
    push rcx
    push rbx
    push rax
%endmacro

%macro REGLD 0
    pop rax
    pop rbx
    pop rcx
    pop rdx
    pop rbp
    pop rdi
    pop rsi
    pop r8
    pop r9
    pop r10
    pop r11
    pop r12
    pop r13
    pop r14
    pop r15
%endmacro

_asm_default:
    push 0
    push 0
    REGSV
    mov rdi, rsp
    call isr_default
    REGLD
    add rsp, 16
    iretq

_asm_except_gp:
    push 13
    REGSV
    mov rdi, rsp
    call isr_except_gp
    REGLD
    add rsp, 16
    iretq

_asm_except_pf:
    push 14
    REGSV
    mov rdi, rsp
    call isr_except_pf
    REGLD
    add rsp, 16
    iretq

_asm_except_df:
    REGSV
    call isr_except_df
    REGLD
    add rsp, 0
    iretq

_asm_except_de:
    REGSV
    call isr_except_de
    REGLD
    add rsp, 0
    iretq

_asm_except_ts:
    REGSV
    call isr_except_ts
    REGLD
    add rsp, 0
    iretq

_asm_irq_pit:
    REGSV
    call isr_irq_pit
    REGLD
    mov al, 0x20
    out 0x20, al
    iretq

_asm_irq_keyboard:
    REGSV
    call isr_irq_keyboard
    REGLD
    mov al, 0x20
    out 0x20, al
    iretq