; ===================================================================
; string.asm
;
; Released under MIT license (see LICENSE for more informations)
;
; This file is part of the Benlib. It provides several subroutines
; that are used to work with strings.
; ===================================================================

[bits 16]

; Input:
; DI -> first string
; SI -> second string
; Output:
; CF -> result of the comparison
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

; Input:
; DI -> first string
; SI -> second string
; Output:
; CF -> result of the comparison
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

; Input:
; SI -> the string
; Output:
; AX -> the length of the string
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

; Input:
; SI -> the string to split
; Output:
; DI -> the second part of the string (if there is one)
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