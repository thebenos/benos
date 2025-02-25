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

command_help_clear:
; Display a list of all the available options for the 'clear' command
    mov si, msgHelp_clear
    call STDIO_print

    jmp shell_begin

command_help_ls:
; Display a list of all the available options for the 'ls' command
    mov si, msgHelp_ls
    call STDIO_print

    jmp shell_begin

; Help messages
msgHelp_main:
    db "HELP -- Available commands:", 13, 10
    db "- info <-v/-n>", 13, 10
    db "- help [command]", 13, 10
    db "- halt", 13, 10
    db "- clear", 13, 10
    db "- ls", 13, 10
    db 0

msgHelp_info:
    db "INFO -- Command informations:", 13, 10
    db "Description: shows informations about the system", 13, 10
    db "1. -v : display the version of the system", 13, 10
    db "2. -n : display the name of the system", 13, 10
    db 0

msgHelp_halt:
    db "HALT -- Command informations:", 13, 10
    db "Description: shutdowns the system", 13, 10
    db "No option available.", 13, 10
    db 0

msgHelp_clear:
    db "CLEAR -- Command informations:", 13, 10
    db "Description: clears the entire screen", 13, 10
    db "No option available.", 13, 10
    db 0

msgHelp_ls:
    db "LS -- Command informations:", 13, 10
    db "Displays a list of the files that are in the root directory", 13, 10
    db "No option available.", 13, 10
    db 0