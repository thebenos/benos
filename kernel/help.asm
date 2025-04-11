[bits 16]

command_help:
    mov si, prpBuffer
    mov di, cmdHelp
    call STRING_compare
    jc command_help_home

    mov si, prpBuffer
    call STRING_split

    check_param param_info, command_help_info
    check_param param_halt, command_help_halt
    check_param param_clear, command_help_clear
    check_param param_ls, command_help_ls
    check_param param_touch, command_help_touch
    check_param param_rm, command_help_rm
    check_param param_reboot, command_help_reboot

    jmp shell_begin.command_unknow

command_help_home:
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

command_help_reboot:
    mov si, msgHelp_reboot
    call STDIO_print

    jmp shell_begin

; Parameters
param_info:             db              "info", 0
param_halt:             db              "halt", 0
param_clear:            db              "clear", 0
param_ls:               db              "ls", 0
param_touch:            db              "touch", 0
param_rm:               db              "rm", 0
param_reboot:           db              "reboot", 0

; Help messages
msgHelp_main:
    db "HELP -- Available commands:", 13, 10
    db "- info <-v/-n/-l>", 13, 10
    db "- help [command]", 13, 10
    db "- halt", 13, 10
    db "- clear", 13, 10
    db "- ls", 13, 10
    db "- touch <filename>", 13, 10
    db "- rm <file>", 13, 10
    db "- reboot", 13, 10
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
    db "Description: create a new file.", 13, 10
    db "1. <filename>: the name of the file. The filename must have 12 characters", 13, 10
    db 0

msgHelp_rm:
    db "RM -- informations:", 13, 10
    db "Description: remove a file", 13, 10
    db "1. <file>: the name of the file", 13, 10
    db 0

msgHelp_reboot:
    db "REBOOT -- informations:", 13, 10
    db "Description: reboot the system. The system will stop if the reboot fails.", 13, 10
    db 0