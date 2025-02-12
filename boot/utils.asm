; This file is a light version of the standard BenOS library, containing
; only the functions required for the bootloader, so as not to overload it
; unnecessarily.

; Usage:
; mov si, <string>
; call BOOT_UTILS_print
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

; Usage:
; int 0x13
; jc BOOT_UTILS_disk_error
BOOT_UTILS_disk_error:
    mov si, .msg
    call BOOT_UTILS_print
    jmp $

    .msg: db "[!] An error occured while operating on disk", 13, 10, 0