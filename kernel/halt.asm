[bits 16]

command_halt:
; Stop the system
    hlt
    
command_reboot:
    mov ah, 0x19
    int 0x19

    mov si, .msg
    call STDIO_print

    hlt

.msg:   db  "[ ERR ] Failed to reboot. Stopping..."