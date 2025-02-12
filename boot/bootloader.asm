; This file contains the bootloader of BenOS.
;
; It is used to start the system and load the kernel.
; First, the segments are initialized.
; Next, the filesystem (FAT12) is initialized too.
; And finally, the kernel is loaded.
;
; At the end, the bootloader jumps to the kernel.

%define BASE            0x1000      ; Kernel address
%define KERNEL_SIZE     50          ; Number of sectors required for the kernel

[bits 16]
[org 0x0]

start:
    cli                         ; Cancel interruptions
; Initialize segments
    mov ax, 0x07c0
    mov ds, ax
    mov es, ax
    mov ax, 0x8000
    mov ss, ax
    mov sp, 0xf000

    mov si, segInit
    call BOOT_UTILS_print

; Recover boot unit
    mov dl, [boot_driver]

    mov si, recBootUnit
    call BOOT_UTILS_print

; Load the kernel
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
    mov si, krnLoading
    call BOOT_UTILS_print

    jmp BASE:0

; ----- INCLUDES -----
%include "boot/utils.asm"

; ----- DATA -----
; Messages
segInit:            db      "[OK] Segments initialized", 13, 10, 0
recBootUnit:        db      "[OK] Recovered boot unit", 13, 10, 0
krnReady:           db      "[OK] Kernel is ready", 13, 10, 0
krnLoading:         db      "[-] Jumping to the kernel...", 13, 10, 0

boot_driver:        db      0x80        ; Hard disk

times 510 - ($ -$$) db 0                ; Fill the bootsector
dw 0xaa55                               ; Magic word