; ======================================================================
; gdt.asm
;
; This file contains the definition of the BenOS GDT.
; This is a flat GDT, so it is very simple.
; ======================================================================

[bits 16]                           ; Real mode

; GDT start address
GDT32_start:

; GDT null descriptor
GDT32_null:
    dd 0x00000000
    dd 0x00000000

; GDT code descriptor
GDT32_code:
    dw 0xffff
    dw 0x0000
    db 0x00
    db 0b10011010
    db 0b11001111
    db 0x00

; GDT data descriptor
GDT32_data:
    dw 0xffff
    dw 0x0000
    db 0x00
    db 0b10010010
    db 0b11001111
    db 0x00

; GDT end address
GDT32_end:

; GDT descriptor
GDT32_descriptor:
    dw GDT32_end - GDT32_start - 1          ; GDT size
    dd GDT32_start

; Code and data segments
; Segment size = Segment address - GDT start address
code_segment:       equ     GDT32_code - GDT32_start
data_segment:       equ     GDT32_data - GDT32_start