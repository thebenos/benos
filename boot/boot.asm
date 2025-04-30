[BITS 32]
global _start

section .multiboot
align 8
mb2_header:
    dd 0xe85250d6
    dd 0
    dd mb2_end - mb2_header
    dd -(0xe85250d6 + 0 + (mb2_end - mb2_header))

    dw 0
    dw 0
    dd 8
mb2_end:

section .text
_start:
    cli

    mov esp, 0x90000

    mov eax, 0x00000080
    mov cr0, eax

    jmp kernel_start

    hlt

section .data
    kernel_start:       equ      0x1000