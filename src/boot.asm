%define BASE            0x100
%define KSIZE           50

[BITS 16]           ; Real mode
[ORG 0x0]

jmp start
%include "std/stdio.inc"
%include "std/disk.inc"

start:
    ; Segments initialization
    mov ax, 0x07c0
    mov ds, ax
    mov es, ax
    mov ax, 0x8000
    ; Initialize stack
    mov ss, ax
    mov sp, 0xf000

    ; Recover boot unit
    mov [bootdrv], dl

    ; Display text
    write title
    write info
    write loadKernel

    ; Load the kernel
    xor ax, ax
    int 0x13
    jc disk_error

    push es
    mov ax, BASE
    mov es, ax
    mov bx, 0

    mov ah, 2
    mov al, KSIZE
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, [bootdrv]
    int 0x13
    jc disk_error
    pop es

    ; Jump to the kernel
    jmp dword BASE:0

; SECTION -- Variables
title db "BenOS", 13, 10, '=====', 13, 10, 0
info db "Bootloader started!", 13, 10, 0
loadKernel db "Loading kernel...", 13, 10, 0
bootdrv db 0

; Boot signature
times 510-($-$$) db 144
dw 0xAA55