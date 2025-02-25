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
; mov al, <separator>
; mov si, <string>
; call STRING_tokenize
;
; NOTE:
; The next token is in DI.
STRING_tokenize:
    push di
    push si
.begin:
    cmp byte [si], al           ; Matching separator?
    je .token_found

    cmp byte [si], 0            ; Null-character?
    jz .done

    inc si

    jmp .begin
.token_found:
    mov byte [si], 0
    inc si
    mov di, [si]

    pop di
    pop si

    ret
.done:
    pop di
    pop si

    ret

; Usage:
; mov si, <string>
; call STRING_length
;
; NOTE:
; The length of the string is in AX.
STRING_length:
    push ax
    push bx
    push cx
    push dx
    push si
    push di

    mov cx, 0
.begin:
    cmp byte [si], 0
    jz .done

    inc si
    inc cx

    jmp .begin
.done:
    mov word [.counter], cx

    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    
    mov ax, word [.counter]

    ret
.counter dw 0

; Usage:
; mov di, <first_string>
; mov si, <second_string>
; call STRING_compare_start
STRING_compare_start:
.begin:
    mov al, [si]
    mov bl, [di]

    cmp bl, 0
    je .equal

    cmp al, bl
    jne .not_equal

    inc si
    inc di
    jmp .begin
.equal:
    stc
    jmp .done
.not_equal:
    clc
.done:
    ret