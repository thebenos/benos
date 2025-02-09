[bits 16]

; Usage:
; mov al, <char>
; call STDIO_putchar
STDIO_putchar:
    mov ah, 0x0e
    int 0x10

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