; This file is one of the libraries of the standard
; libraries. It contains basic strings manipulation
; functions.

%include "std/macros.inc"

; Compare strings function
compare_strings:
    push si
.compare_character:
    mov al, [si]
    mov bl, [di]
    cmp al, bl
    jne .not_equal              ; Not equal

    cmp al, 0                   ; Two zeros compared?
    je .equal                   ; If yes, end of string

    inc si
    inc di
    jmp .compare_character      ; Go to the next character
.equal:
    stc                         ; Set carry flag (equal)
    jmp .done
.not_equal:
    clc                         ; Clear carry flag (not equal)
.done:
    pop si
    ret

; Compare start string function
compare_start_strings:
    push si
.compare_next_character:
    mov al, [si]
    mov bl, [di]

    cmp bl, 0
    je .conclude_equal

    cmp al, bl
    jne .conclude_not_equal

    inc si
    inc di
    jmp .compare_next_character
.conclude_equal:
    stc
    jmp .done
.conclude_not_equal:
    clc
.done:
    pop si
    ret

; Function to tokenize a string
tokenize_string:
    push si
.next_char:
    ; do we have a matching separator ?
    cmp byte [si], al
    je .return_token
    ; is this the end of the string ?
    cmp byte [si], 0
    jz .no_more

    ; move forward
    inc si
    jmp .next_char
.return_token:
    mov byte [si], 0
    inc si
    mov di, si
    pop si
    ret
.no_more:
    mov di, 0
    pop si
    ret

; Length string function
length_string:
    pusha
    mov cx, 0
.more:
    cmp byte [si], 0
    je .done

    inc si
    inc cx
    jmp .more
.done:
    mov word [.counter], cx
    popa
    mov ax, word [.counter]
    ret

    .counter dw 0