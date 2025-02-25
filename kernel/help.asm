[bits 16]

command_help:
; Display a list of all the available commands
    mov si, msgHelp_main
    call STDIO_print

    jmp shell_begin
command_help_info:
; Display a list of all the available options for the 'info' command
    mov si, msgHelp_info
    call STDIO_print

    jmp shell_begin

command_help_halt:
; Display a list of all the available options for the 'halt' command
    mov si, msgHelp_halt
    call STDIO_print

    jmp shell_begin

; Help messages
msgHelp_main:
    db "HELP -- Available commands:", 13, 10
    db "- info <-v/-n>", 13, 10
    db "- help [command]", 13, 10
    db "- halt", 13, 10
    db 0

msgHelp_info:
    db "INFO -- Available options:", 13, 10
    db "Description: shows informations about the system", 13, 10
    db "1. -v : display the version of the system", 13, 10
    db "2. -n : display the name of the system", 13, 10
    db 0

msgHelp_halt:
    db "HALT -- Available options:", 13, 10
    db "Description: shutdowns the system", 13, 10
    db "No option is available for now", 13, 10
    db 0