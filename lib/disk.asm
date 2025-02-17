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

DISK_read:
    pusha
    mov ah, 0x02
    mov ch, 0
    mov dh, 0
    int 0x13
    jc DISK_error
    popa
    ret

DISK_write:
    pusha
    mov ah, 0x03
    mov ch, 0
    mov dh, 0
    int 0x13
    jc DISK_error
    popa
    ret

DISK_read_file:
    pusha
    mov cx, 1
    .read_loop:
        push cx
        call DISK_read
        pop cx
        inc cx
        cmp cx, 10
        jl .read_loop
    popa
    ret

