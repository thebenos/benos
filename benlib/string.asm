; This file provides several functions used to manipulate strings.

[bits 16]

; Usage:
; mov di, <first_string>
; mov si, <second_string>
; call STRING_compare
STRING_compare:
    push di
    push si
.begin:
    mov al, [si]
    mov bl, [di]
    cmp al, bl
    jne .not_equal

    cmp al, 0
    je .equal

    inc si
    inc di

    jmp .begin
.not_equal:
    clc
    jmp .done
.equal:
    stc
    jmp .done
.done:
    pop si
    pop di

    ret

; Usage:
; mov di, <first_string>
; mov si, <second_string>
; call STRING_compare_start
STRING_compare_start:
    push di
    push si

.begin:
    mov al, [si]
    mov bl, [di]
    cmp al, ' '
    je .equal
    cmp al, 0
    je .equal

    cmp bl, ' '
    je .equal
    cmp bl, 0
    je .equal

    cmp al, bl
    jne .not_equal

    inc si
    inc di

    jmp .begin

.not_equal:
    clc

    jmp .done

.equal:
    stc

    jmp .done

.done:
    pop si
    pop di

    ret

; Usage:
; mov si, <string>
; call STRING_length
;
; NOTE:
; The length of the string is in AX.
STRING_length:
    pusha
    mov cx, 0
.begin:
    cmp byte [si], 0
    jz .done

    inc si
    inc cx

    jmp .begin
.done:
    mov word [.counter], cx
    popa
    mov ax, word [.counter]

    ret
.counter dw 0

; Usage:
; mov si, <string>
; call STRING_split
STRING_split:
    push si

    mov di, 0

.find_space:
    mov al, [si]

    cmp al, 0
    je .done

    cmp al, ' '
    je .split

    inc si

    jmp .find_space

.split:
    mov byte [si], 0
    inc si
    mov di, si

    jmp .done

.done:
    pop si

    ret