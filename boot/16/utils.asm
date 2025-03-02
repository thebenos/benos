; ======================================================================
; utils.asm
;
; This file contains functions that are used in the bootloader (only in
; real mode). They are not essential but they are very useful, so you
; should keep them if you want to edit this file.
; ======================================================================

[bits 16]                       ; Real mode

boot16_print:
    ; Save the AX and BX registers
    push ax
    push bx

    ; Set AH to 0x0e, because this is the BIOS service used by the 0x10
    ; interrupt to print characters on the screen in TeleType mode
    mov ah, 0x0e

; Print every characters of the string
.next_character:
    ; Check if the current character is a null-character (0)
    ; If yes, then deduct that this is the end of the string
    cmp byte [bx], 0
    je .end_of_string

    ; Else, print the character
    mov al, byte [bx]
    int 0x10

    ; Increment BX
    inc bx

    ; Do the same thing for the next character
    jmp .next_character

.end_of_string:
    ; Restore the AX and BX registers
    pop bx
    pop ax

    ret

boot16_print_hex:
    ; Save the AX, BX and CX registers
    push ax
    push bx
    push cx

    ; Set AH to 0x0e, because this is the BIOS service used by the 0x10
    ; interrupt to print characters on the screen in TeleType mode
    mov ah, 0x0e

    ; Print the hexadecimal prefix (0x) before the number
    mov al, '0'
    int 0x10
    mov al, 'x'
    int 0x10

    ;  Set CX to the number of characters that will be printed
    mov cx, 4

.next_character:
    ; Check if all the characters have been printed
    ; If yes, then exit the loop
    cmp cx, 0
    je .end_of_number

    ; Save the BX register
    push bx

    shr bx, 12

    ; If BX is greater or equal than 10, then print a letter
    cmp bx, 10
    jge .print_alpha

    mov al, '0'
    add al, bl

    jmp .next_character_end

.print_alpha:
    ; Print a letter
    sub bl, 10

    mov al, 'A'
    add al, bl

.next_character_end:
    ; Print the character
    int 0x10

    ; Restore the BX register
    pop bx
    
    shl bx, 4

    ; 1 character has been printed, so decrement CX
    dec cx

    ; Do the same thing for the next character
    jmp .next_character

.end_of_number:
    ; Restore the AX, BX and CX registers
    pop cx
    pop bx
    pop ax

    ret

boot16_load_sector:
    ; Save the AX, BX, CX and DX registers
    push ax
    push bx
    push cx
    push dx

    ; Save the CX register
    push cx

    ; Set AH to 0x02 because this is the BIOS service used by the 0x13
    ; interrupt to read sectors from the disk
    mov ah, 0x02

    ; Interrupt parameters
    mov al, cl
    mov cl, bl
    mov bx, dx

    mov ch, 0x00
    mov dh, 0x00

    mov dl, [boot_drive]

    int 0x13
    jc boot16_disk_error

    ; Restore the BX register
    pop bx

    cmp al, bl
    jne boot16_disk_error

    mov bx, .msg_success
    call boot16_print

    ; Restore the AX, BX, CX and DX registers
    pop dx
    pop cx
    pop bx
    pop ax

    ret

.msg_success:       db      "Sector loaded successfully", 13, 10, 0

boot16_disk_error:
    ; Print a message to tell the user that an error has been encountered
    ; while reading sectors from the disk
    mov bx, .msg_error
    call boot16_print

    ; Print the error code
    shr ax, 8
    mov bx, ax
    call boot16_print_hex

    ; Infinity loop
    jmp $

.msg_error:         db      "Failed to read sectors. Error code: ", 0