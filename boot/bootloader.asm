; ======================================================================
; bootloader.asm
;
; This file is the BenOS bootloader. It initializes real mode and loads
; a second sector from the disk, by calling the subroutine boot16_load_
; disk provided in 16/utils.asm.
; In this second sector, the GDT defined in 16/gdt.asm is loaded and the
; protected mode is enabled by calling the subroutine boot_enable_
; protected_mode defined in 16/switch.asm.
; For more informations about the included files, please read their doc
; umentation.
;
; MIT License
; ======================================================================

[bits 16]                       ; Real mode
[org 0x7c00]                    ; Bootloader address

; Initialize the stack
mov bp, 0x0500
mov sp, bp

; Recover the boot drive
mov byte [boot_drive], dl

; Print a message to tell the user that BenOS is booting
mov bx, msg_boot
call boot16_print

; Load the second sector
mov bx, 0x0002
mov cx, 0x0001
mov dx, 0x7e00
call boot16_load_sector

; Enable the protected mode
call boot_enable_protected_mode

; Infinity loop
jmp $

; ---------- INCLUDES ----------
%include "boot/16/utils.asm"
%include "boot/16/gdt.asm"
%include "boot/16/switch.asm"

; ---------- DATA ----------
; NOTE: Every label starting with "msg" contains a string with informations
; to tell the user what is happening.
msg_boot:      db      "[ OK ] Start booting", 13, 10, 0

boot_drive:     db      0x80

; Fill the boot sector
times 510 - ($ - $$) db 0
; Magic word
dw 0xaa55

; Second sector previously loaded
bs_extended:
    ; Initialize the protected mode
    protected_mode_start:
        call boot32_clear                   ; Clear the screen

        ; Print a message to tell the user that BenOS is now in protected
        ; mode
        mov esi, msg_protected_mode_enabled
        call boot32_print

        ; Infinity loop
        jmp $

        ; ---------- INCLUDES ----------
        %include "boot/32/utils.asm"

        ; ---------- DATA ----------
        msg_protected_mode_enabled:     db      "[ OK ] Protected mode enabled", 0

        vga_start:      equ     0x000b8000
        vga_extent:     equ     80 * 25 * 2
        style_wb:       equ     0x0f
        kernel_start:   equ     0x00100000

    ; Fill the sector
    times 512 - ($ - bs_extended) db 0