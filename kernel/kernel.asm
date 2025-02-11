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

    mov si, title
    call STDIO_print

wait_for_key:
    mov si, keyPress
    call STDIO_print

    call STDIO_waitkeypress

    cmp al, 0
    jnz .start_shell

    jmp wait_for_key
.start_shell:
    mov si, STDIO_newline
    times 2 call STDIO_print

    jmp shell_begin

; Shell
shell_begin:
; Display the prompt
    mov si, prompt
    call STDIO_print

; Start the input
    mov di, prpBuffer
    call STDIO_input

    inc byte [lnsOnScreen]

    cmp byte [lnsOnScreen], 24
    je .scrollup

    jmp shell_begin
.scrollup:
    mov al, 1
    dec byte [lnsOnScreen]
    call VIDEO_scrollup
    
    jmp shell_begin

; ----- INCLUDES -----
%include "lib/stdio.asm"
%include "lib/video.asm"

; ----- DATA -----
segInit:            db      "[OK] Segments initialized", 13, 10, 0
krnLoaded:          db      "[OK] Kernel loaded successfully", 13, 10, 0
prompt:             db      "BenOS> ", 0
title:              db      "BenOS version 0.0.2", 13, 10, 0
keyPress:           db      "Press a key to continue...", 0

prpBuffer:          times 256 db 0

lnsOnScreen:        db      0