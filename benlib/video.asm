; This file contains several subroutines used to interact with the screen.

[bits 16]

VIDEOMEM                equ     0xb800

; Usage:
; call VIDEO_clear
VIDEO_clear:
    mov ah, 0x00
    mov al, 0x03
    int 0x10

    ret

; Usage:
; mov dl, <column>
; mov ch, <line>
; call VIDEO_move_cursor
VIDEO_move_cursor:
; Set the cursor position
    mov dl, cl          ; Column
    mov dh, ch          ; Line

    mov ah, 0x02
    xor bh, bh          ; Page (0)
    int 0x10

    ret

; Usage:
; mov al, <lines>
; mov bh, <attribute>
; call VIDEO_scrollup
VIDEO_scrollup:
    mov ah, 0x06
    mov ch, 0
    mov cl, 0
    mov dh, 24
    mov dl, 79
    int 0x10

    ret