[bits 16]

command_ls:
    mov cx, 0

    mov ax, root_dir_list
    call DISK_list_rootdir

    mov si, root_dir_list
    mov ah, 0x0e

.ls_loop:
    lodsb

    cmp al, 0
    jz .done

    cmp al, ','
    jne .print_char

    push ax
    push bx
    push cx
    push dx
    push di
    push si

    mov si, NEWLINE
    call STDIO_print

    pop si
    pop di
    pop dx
    pop cx
    pop bx
    pop ax

    jmp .ls_loop

.print_char:
    int 0x10
    jmp .ls_loop

.done:
    mov si, NEWLINE
    call STDIO_print

    jmp shell_begin