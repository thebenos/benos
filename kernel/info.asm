[bits 16]

command_info:
    mov si, prpBuffer
    mov di, cmdInfo
    call STRING_compare
    jc command_info_home

    mov si, prpBuffer
    call STRING_split

    check_param param_name, command_info_name
    check_param param_version, command_info_version
    check_param param_license, command_info_license

    jmp shell_begin.command_unknow

command_info_home:
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

command_info_license:
    mov si, SYS_LICENSE
    call STDIO_print
    mov si, NEWLINE
    call STDIO_print

    jmp shell_begin

; Parameters
param_name:         db      "-n", 0
param_version:      db      "-v", 0
param_license:      db      "-l", 0

; Errors
cmdInfo_error:      db      "'info' command requires an option.", 13, 10, 'Type help info for a list of options.', 13, 10, 0