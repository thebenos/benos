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

    mov si, di
    call STRING_length
    cmp ax, 12
    jne .filename_too_short

    mov si, di
    call DISK_create_file

    jmp shell_begin

.filename_too_short:
    mov si, .message_short
    call STDIO_print

    jmp shell_begin

.error:
    mov si, .message_error
    call STDIO_print

    jmp shell_begin

.message_error:         db          "No filename given", 13, 10, 0
.message_short:         db          "Filename is too short", 13, 10, 0

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