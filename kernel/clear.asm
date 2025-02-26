[bits 16]

command_clear:
; Clear the screen
    call VIDEO_clear

    jmp shell_begin