; ======================================================================
; switch.asm
;
; This file contains the subroutine used to enable the protected mode, by
; setting the P bit of the CR0 register to 1.
; ======================================================================

[bits 16]

boot_enable_protected_mode:
    ; Cancel interrupts
    cli

    ; Load the GDT (see gdt.asm)
    lgdt [GDT32_descriptor]

    ; Enable protected mode
    mov eax, cr0
    or eax, 0x00000001
    mov cr0, eax

    jmp code_segment:.init_protected_mode

[bits 32]
.init_protected_mode:
    ; Initialize the segments
    mov ax, data_segment
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    ; Initialize the stack
    mov ebp, 0x90000
    mov esp, ebp

    jmp protected_mode_start