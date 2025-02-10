[bits 16]
[org 0x0]

start:
; Initialize segments
    mov ax, 0x1000
    mov ds, ax
    mov es, ax
    mov ax, 0x8000
    mov ss, ax
    mov sp, 0xf000

    mov si, segInit
    call STDIO_print

; Kernel loaded
    mov si, krnLoaded
    call STDIO_print

; Infinity loop
    jmp $

; ----- INCLUDES -----
%include "lib/stdio.asm"

; ----- DATA -----
segInit:            db      "[OK] Segments initialized", 13, 10, 0
krnLoaded:          db      "[OK] Kernel loaded successfully", 13, 10, 0