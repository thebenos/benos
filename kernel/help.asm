[bits 16]

command_help:
; Display a list of all the available commands
    mov si, msgHelp_main
    call STDIO_print

    jmp shell_begin
command_help_info:
; Display a list of all the Informations for the 'info' command
    mov si, msgHelp_info
    call STDIO_print

    jmp shell_begin

command_help_halt:
; Display a list of all the Informations for the 'halt' command
    mov si, msgHelp_halt
    call STDIO_print

    jmp shell_begin

command_help_clear:
    mov si, msgHelp_clear
    call STDIO_print

    jmp shell_begin

command_help_ls:
    mov si, msgHelp_ls
    call STDIO_print

    jmp shell_begin

command_help_touch:
    mov si, msgHelp_touch
    call STDIO_print

    jmp shell_begin

command_help_rm:
    mov si, msgHelp_rm
    call STDIO_print

    jmp shell_begin

; Help messages
msgHelp_main:
    db "HELP -- Available commands:", 13, 10
    db "- info <-v/-n/-l>", 13, 10
    db "- help [command]", 13, 10
    db "- halt", 13, 10
    db "- clear", 13, 10
    db "- ls", 13, 10
    db "- touch", 13, 10
    db "- rm", 13, 10
    db 0

msgHelp_info:
    db "INFO -- Informations:", 13, 10
    db "Description: display informations about the system", 13, 10
    db "1. -v : display the version of the system", 13, 10
    db "2. -n : display the name of the system", 13, 10
    db "3. -l : display the license of the system", 13, 10
    db 0

msgHelp_halt:
    db "HALT -- Informations:", 13, 10
    db "Description: shutdown the system", 13, 10
    db 0

msgHelp_clear:
    db "CLEAR -- Informations:", 13, 10
    db "Description: clear the entire screen", 13, 10
    db 0

msgHelp_ls:
    db "LS -- informations:", 13, 10
    db "Description: display a list of all the files", 13, 10
    db 0

msgHelp_touch:
    db "TOUCH -- informations:", 13, 10
    db "Description: create a new file. Display an error message if the file cannot be created", 13, 10
    db 0

msgHelp_rm:
    db "RM -- informations:", 13, 10
    db "Description: remove a file", 13, 10
    db 0