%include "kernel/include/macro.inc"

extern ISR_default, ISR_clock, ISR_keyboard, do_syscalls, ISR_except_PF, ISR_except_GPF
global _ASM_default, _ASM_irq0, _ASM_irq1, _ASM_syscalls, _ASM_except_PF, _ASM_except_GPF

_ASM_default:
   call ISR_default

    mov al, 0x20
    out 0x20, al

    iret

_ASM_irq0:
    SAVE_REGISTERS

    call ISR_clock

    mov al, 0x20
    out 0x20, al

    LOAD_REGISTERS

    iret

_ASM_irq1:
    call ISR_keyboard

    mov al, 0x20
    out 0x20, al

    iret

_ASM_syscalls:
    SAVE_REGISTERS

    push eax

    call do_syscalls

    pop eax

    LOAD_REGISTERS

    iret

_ASM_except_PF:
    SAVE_REGISTERS

    call ISR_except_PF

    LOAD_REGISTERS

    add esp, 4

    iret

_ASM_except_GPF:
    SAVE_REGISTERS

    call ISR_except_GPF

    LOAD_REGISTERS

    add esp, 4

    iret