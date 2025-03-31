; ===================================================================
; video.asm
;
; Released under MIT license (see LICENSE for more informations)
;
; This file is part of the Benlib. It contains several subroutines
; that are used to interact with the screen.
; ===================================================================

[bits 16]

VIDEO_clear:
    mov ah, 0x00
    mov al, 0x03
    int 0x10

    ret

; Input:
; AL -> lines
; BH -> attributes
VIDEO_scrollup:
    mov ah, 0x06
    mov ch, 0
    mov cl, 0
    mov dh, 24
    mov dl, 79
    int 0x10

    ret