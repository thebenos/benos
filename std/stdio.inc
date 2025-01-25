; This file is one of the libraries of the standard
; libraries. It contains basic Input/Output (I/O)
; functions.

%include "std/macros.inc"

; Variables
nl db 13, 10, 0

; Print function
print:
    push ax
    push bx
.begin:
    lodsb
    cmp al, 0           ; End of string?
    jz .finish          ; al == 0 => finish
    mov ah, 0x0e        ; Call 0x0e BIOS service
    mov bx, 0x07
    int 0x10
    jmp .begin          ; Go to next character
.finish:
    pop bx
    pop ax
    ret

; Read
read:
    push ax
    push di
.begin:
    mov ah, 0x00        ; Read keyboard service
    int 0x16            ; Call BIOS

    cmp al, 0x0d        ; Enter pressed?
    je .newline         ; al == 0x0d (enter) => finish
    cmp al, 0x08        ; Backspace pressed?
    je .backspace

    stosb

    ; Write the character
    mov ah, 0x0e
    int 0x10

    jmp .begin          ; Go to the next character
.backspace:
    cmp di, 0
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
.restore:
    pop cx
    jmp .begin
.newline:
    ; Add a newline when ENTER is pressed
    mov al, 0x0a         ; Line feed
    mov ah, 0x0e
    int 0x10
    mov al, 0x0d         ; Carriage return
    int 0x10

    mov al, 0
    stosb
    pop di
    pop ax
    ret

; Clear screen
clear_screen:
    mov ah, 0x06
    xor al, al
    xor cx, cx
    mov dx, 0x184f
    mov bh, 0x07
    int 0x10