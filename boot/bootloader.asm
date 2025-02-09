%define BASE            0x100
%define KERNEL_SIZE     50

[bits 16]
[org 0x0]

start:
; Initialize segments
    mov ax, 0x07c0
    mov ds, ax
    mov es, ax
    mov ax, 0x8000
    mov ss, ax
    mov sp, 0xf000

    mov si, segInit
    call STDIO_print

; Recover boot unit
    mov dl, [boot_driver]

    mov si, recBootUnit
    call STDIO_print

; Load the kernel
    xor ax, ax
    int 0x13
    jc disk_error

    xor ax, ax
    int 0x13
    jc disk_error

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
    jc disk_error
    pop es

    mov si, krnReady
    call STDIO_print

; Jump to the kernel
    mov si, krnLoading
    call STDIO_print

    jmp dword BASE:0

; ----- INCLUDES -----
%include "lib/stdio.asm"
%include "lib/disk.asm"

; ----- DATA -----
segInit:            db      "[OK] Segments initialized", 13, 10, 0
recBootUnit:        db      "[OK] Recovered boot unit", 13, 10, 0
krnReady:           db      "[OK] Kernel is ready", 13, 10, 0
krnLoading:         db      "[-] Loading kernel...", 13, 10, 0

boot_driver:        db      0x80

times 510 - ($ -$$) db 0
dw 0xaa55