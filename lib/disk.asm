; This file contains several subroutines used to interact with the disk
; and the filesystem.
;
; IMPORTANT:
; This file depends of "lib/stdio.asm", so you must include it in your
; program too.

[bits 16]

; Usage:
; int 0x13
; jc DISK_error
DISK_error:
    mov ah, 0x0e
    
    mov al, '!'
    int 0x10

    jmp $