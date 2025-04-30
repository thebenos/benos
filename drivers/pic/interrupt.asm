extern ISR_default, ISR_clock, ISR_keyboard
global _ASM_default, _ASM_irq0, _ASM_irq1

_ASM_default:
    call ISR_default

    mov al, 0x20
    out 0x20, al

    iret

_ASM_irq0:
    call ISR_clock

    mov al, 0x20
    out 0x20, al

    iret

_ASM_irq1:
    call ISR_keyboard

    mov al, 0x20
    out 0x20, al

    iret