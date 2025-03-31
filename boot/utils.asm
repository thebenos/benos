; ===================================================================
; utils.asm
;
; Released under MIT license (see LICENSE for more informations)
;
; This file is a light version of the Benlib. It only provides subrou
; tines that are used in the bootloader. This file is only used in the
; bootloader. Using it in another program would be stupid.
; ===================================================================

; Input:
; SI -> string to print
BOOT_UTILS_print:
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

; Use with INT 0x13
BOOT_UTILS_disk_error:
    mov si, .msg
    call BOOT_UTILS_print
    jmp $

    .msg: db "[ ERR ] An error occured while operating on disk", 13, 10, 0

BOOT_UTILS_clear:
    mov ah, 0x00
    mov al, 0x03
    int 0x10

    ret