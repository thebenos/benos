[bits 16]

command_info:
; Cannot use 'info' alone without arguments
    mov si, cmdInfo_error
    call STDIO_print

    jmp shell_begin

command_info_version:
; Display the version of the system
    mov si, SYS_VERSION
    call STDIO_print
    mov si, NEWLINE
    call STDIO_print

    jmp shell_begin

command_info_name:
; Display the name of the system
    mov si, SYS_NAME
    call STDIO_print
    mov si, NEWLINE
    call STDIO_print

    jmp shell_begin