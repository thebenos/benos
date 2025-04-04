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
    jg .error_name

    mov cx, 12
    sub cx, ax
    mov di, si
    add di, ax

   
.fill_spaces:
    mov byte [di], 0
    inc di
    loop .fill_spaces

    mov si, prpBuffer
    call DISK_create_file

    jmp shell_begin

.error_name:
    mov si, .message_name
    call STDIO_print

    jmp shell_begin

.error:
    mov si, .message_error
    call STDIO_print

    jmp shell_begin

.message_error:         db "No filename given", 13, 10, 0
.message_name:          db "Filename must be 12 characters or less", 13, 10, 0

command_rm:
    mov si, prpBuffer
    mov di, cmdRm
    call STRING_compare
    jc .error

    mov si, prpBuffer
    call STRING_split

    mov si, di
    call STRING_length
    cmp ax, 12
    jg .error_name

    mov cx, ax
    sub cx, 12
    mov di, si
    add di, ax

.fill_spaces_rm:
    mov byte [di], 0
    inc di
    loop .fill_spaces_rm

    mov si, prpBuffer
    call DISK_remove_file

    cmp ax, 0
    jne .file_not_found

    jmp shell_begin

.error_name:
    mov si, .message_name
    call STDIO_print
    jmp shell_begin

.error:
    mov si, .message_error
    call STDIO_print
    jmp shell_begin

.file_not_found:
    mov si, .no_file
    call STDIO_print
    jmp shell_begin

.message_error:         db "No filename given", 13, 10, 0
.message_name:          db "Filename must have 12 characters or less", 13, 10, 0
.no_file:               db "File not found", 13, 10, 0
