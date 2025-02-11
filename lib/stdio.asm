; This file contains several subroutines used for inputs/outputs in video
; mode.

[bits 16]

STDIO_newline         db      13, 10, 0

; Usage:
; mov al, <char>
; call STDIO_putchar
STDIO_putchar:
    mov ah, 0x0e
    int 0x10
    ret

; Usage:
; mov si, <string>
; call STDIO_print
STDIO_print:
    push si
    mov ah, 0x0e
.begin:
    lodsb
    cmp al, 0
    jz .done
    int 0x10
    jmp .begin
.done:
    pop si
    ret

; Usage:
; call STDIO_waitkeypress
STDIO_waitkeypress:
    mov ah, 0x00
    int 0x16
    ret

; Usage:
; mov di, <buffer>
; call STDIO_input
STDIO_input:
    push di
    push si
.begin:
    mov ah, 0x00
    int 0x16

    ; NOTE: character is stored in AL
    cmp al, 0x0d                    ; Newline
    je .newline
    cmp al, 0x08                    ; Backspace
    je .backspace

    stosb
    mov ah, 0x0e
    int 0x10
    
    jmp .begin
.backspace:
    cmp di, 0                       ; Beginning of the buffer?
    je .begin

    dec di

    mov ah, 0x0e

    mov al, 0x08
    int 0x10
    mov al, ' '
    int 0x10
    mov al, 0x08
    int 0x10

    jmp .begin
.newline:
    mov ah, 0x0e

    mov al, 0x0a                ; Line feed
    int 0x10
    mov al, 0x0d                ; Carriage return
    int 0x10

    mov al, 0
    stosb

    pop si
    pop di

    ret