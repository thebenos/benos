[bits 16]

command_ls:
    call DISK_list_files

    jmp shell_begin

command_touch:
    mov si, prpBuffer
    mov di, cmdTouch
    call STRING_compare
    jc .error

    mov si, prpBuffer
    call STRING_split

    call DISK_create_file

    jmp shell_begin

.error:
    mov si, .message_error
    call STDIO_print

    jmp shell_begin

.message_error:         db          "No filename given", 13, 10, 0

command_rm:
    mov si, prpBuffer
    mov di, cmdRm
    call STRING_compare
    jc .error

    mov si, prpBuffer
    call STRING_split

    call DISK_remove_file

    jmp shell_begin

.error:
    mov si, .message_error
    call STDIO_print

    jmp shell_begin

.message_error:         db          "Please provide a file to remove", 13, 10, 0