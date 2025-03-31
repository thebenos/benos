; ===================================================================
; boot.asm
;
; Released under MIT license (see LICENSE for more informations)
;
; This program is the bootloader of BenOS. You cannot boot the system
; without it. It has a size of 512 bytes (1 sector) and is used to
; load the kernel as a raw memory block.
; ===================================================================

; --------------- CONSTANTS ---------------
%define BASE            0x1000  ; Kernel address
%define KERNEL_SIZE     50      ; Kernel size (in sectors)
; -----------------------------------------

; --------------- ASSEMBLER INFORMATIONS ---------------
[bits 16]                       ; Real mode (16-bit)
[org 0x0]                       ; Program origin
; ------------------------------------------------------

; --------------- CODE ---------------
start:
; Cancel interrupts
    cli

; Initialize segments and stack
    mov ax, 0x07c0
    mov ds, ax
    mov es, ax
    mov ax, 0x8000
    mov ss, ax
    mov sp, 0xf000

; Clear the screen
    call BOOT_UTILS_clear

; Tell the user that the segments have been initialized
    mov si, segInit
    call BOOT_UTILS_print

; Recover the boot drive number
    mov dl, [boot_driver]

; Tell the user that the boot drive number has been recovered
    mov si, recBootUnit
    call BOOT_UTILS_print

; Load the kernel as a raw memory block
    xor ax, ax
    int 0x13

    push es
    mov ax, BASE
    mov es, ax
    mov bx, 0

    mov ah, 2
    mov al, KERNEL_SIZE
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, [boot_driver]
    int 0x13
    pop es

    mov si, krnReady
    call BOOT_UTILS_print

; Jump to the kernel
    jmp BASE:0
; ------------------------------------

; --------------- INCLUDES ---------------
%include "boot/utils.asm"
; ----------------------------------------

; --------------- DATA ---------------
; Messages
segInit:            db      "[ OK ] Segments initialized", 13, 10, 0
recBootUnit:        db      "[ OK ] Recovered boot unit", 13, 10, 0
krnReady:           db      "[ OK ] Kernel is ready", 13, 10, 0

; Boot drive number
boot_driver:        db      0x80        ; Hard disk

times 510 - ($ -$$) db 0                ; Fill the bootsector
dw 0xaa55                               ; Magic word
; ------------------------------------