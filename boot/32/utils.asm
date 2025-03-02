; ======================================================================
; utils.asm
;
; This file contains several subroutines used in the bootloader, only in
; protected mode. They are not essential but they are very useful, so you
; should keep them if you want to edit this file.
; ======================================================================

[bits 32]                           ; Protected mode

boot32_print:
    ; Save all the registers
    pusha
    
    ; Set the start of the VGA memory in the EDX register
    mov edx, vga_start

; Print a character in VGA memory
.next_character:
    ; Check if the character is a null-character (0)
    ; If yes, then deduct that it is the end of the string
    cmp byte [esi], 0
    je .end_of_string

    ; Else, print the character
    mov al, byte [esi]
    mov ah, style_wb

    mov word [edx], ax

    add esi, 1                          ; Next character
    add edx, 2                          ; Next VGA address

    ; Do the same thing for all the characters
    jmp .next_character

.end_of_string:
    ; Restore all the registers
    popa

    ret

boot32_clear:
    ; Save all the registers
    pusha

    mov ebx, vga_extent
    mov ecx, vga_start
    mov edx, 0

; Fill the screen with whitespaces ( ) to clear it
.clearing:
    ; Check if this is the end of the screen
    ; If yes, then exit the loop
    cmp edx, ebx
    jge .cleared

    ; Save the EDX register
    push edx

    ; Print a whitespace on the screen
    mov al, ' '
    mov ah, style_wb

    add edx, ecx
    mov word [edx], ax

    pop edx

    add edx, 2                          ; Next VGA address

    ; Continue to fill the screen
    jmp .clearing

.cleared:
    ; Restore all the registers
    popa

    ret