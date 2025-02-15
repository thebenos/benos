[bits 16]

FS_list_directory:
    pusha
    mov ax, 0x2000
    mov es, ax
    xor bx, bx
    
    mov al, 14
    mov dl, 0
    mov dh, 0
    mov ch, 0
    mov cl, 2
    call DISK_read
    
    mov cx, 224
    xor bx, bx
    
.next_entry:
    mov al, [es:bx]
    cmp al, 0
    je .done
    cmp al, 0xE5
    je .skip_entry
    
    push cx
    call .print_entry
    pop cx
    
.skip_entry:
    add bx, 32
    loop .next_entry
    
.done:
    popa
    ret

.print_entry:
    pusha
    mov cx, 8
    
.print_name:
    mov al, [es:bx]
    cmp al, 0x20
    je .print_ext
    mov ah, 0x0E
    int 0x10
    inc bx
    loop .print_name
    
.print_ext:
    mov al, '.'
    mov ah, 0x0E
    int 0x10
    
    add bx, 8
    sub bx, cx
    mov cx, 3
    
.print_extension:
    mov al, [es:bx]
    cmp al, 0x20
    je .end_print
    mov ah, 0x0E
    int 0x10
    inc bx
    loop .print_extension
    
.end_print:
    mov al, 13
    mov ah, 0x0E
    int 0x10
    mov al, 10
    int 0x10
    popa
    ret

FS_read_file:
    pusha
    mov si, arg_buffer
    call .find_file
    jnc .not_found
    
    mov ax, bx
    mov bx, 0x3000
    mov dl, 0
    call DISK_read_file
    
    mov ax, 0x3000
    mov es, ax
    xor bx, bx
    call .print_buffer
    
.read_done:
    popa
    ret
    
.not_found:
    mov si, msgFileNotFound
    call STDIO_print
    jmp .read_done

.print_buffer:
    pusha
.print_loop:
    mov al, [es:bx]
    cmp al, 0
    je .print_done
    mov ah, 0x0E
    int 0x10
    inc bx
    jmp .print_loop
.print_done:
    popa
    ret

.find_file:
    mov ax, 0x2000
    mov es, ax
    xor bx, bx
    mov cx, 224
.find_loop:
    push cx
    mov cx, 11
    mov di, bx
    call STRING_compare
    pop cx
    jc .found
    add bx, 32
    loop .find_loop
    clc
    ret
.found:
    mov bx, [es:bx + 26]
    stc
    ret

FS_create_file:
    pusha
    call .find_free_entry
    jnc .error
    
    mov di, bx
    mov si, arg_buffer
    mov cx, 11
    rep movsb
    
    mov ax, 0x2000
    mov es, ax
    xor bx, bx
    mov al, 14
    mov dl, 0
    call DISK_write
    
    mov si, msgFileCreated
    call STDIO_print
    jmp .done
    
.error:
    mov si, msgDiskError
    call STDIO_print
    
.done:
    popa
    ret

.find_free_entry:
    mov ax, 0x2000
    mov es, ax
    xor bx, bx
    mov cx, 224
.scan_entries:
    cmp byte [es:bx], 0
    je .entry_found
    add bx, 32
    loop .scan_entries
    clc
    ret
.entry_found:
    stc
    ret

FS_delete_file:
    pusha
    mov si, arg_buffer
    call .find_file_entry
    jnc .not_found
    
    mov byte [es:bx], 0xE5
    
    mov al, 14
    mov dl, 0
    call DISK_write
    
    mov si, msgFileDeleted
    call STDIO_print
    jmp .done
    
.not_found:
    mov si, msgFileNotFound
    call STDIO_print
    
.done:
    popa
    ret

.find_file_entry:
    mov ax, 0x2000
    mov es, ax
    xor bx, bx
    mov cx, 224
.search:
    push cx
    mov cx, 11
    mov di, bx
    call STRING_compare
    pop cx
    jc .found_entry
    add bx, 32
    loop .search
    clc
    ret
.found_entry:
    stc
    ret

FS_rename_file:
    pusha
    mov si, arg_buffer
    call .find_file_entry
    jnc .not_found
    
    push bx
    mov si, arg_buffer2
    mov di, bx
    mov cx, 11
    rep movsb
    pop bx
    
    mov al, 14
    mov dl, 0
    call DISK_write
    
    mov si, msgFileRenamed
    call STDIO_print
    jmp .done
    
.not_found:
    mov si, msgFileNotFound
    call STDIO_print
    
.done:
    popa
    ret

.find_file_entry:
    mov ax, 0x2000
    mov es, ax
    xor bx, bx
    mov cx, 224
.search:
    push cx
    mov cx, 11
    mov di, bx
    call STRING_compare
    pop cx
    jc .found_entry
    add bx, 32
    loop .search
    clc
    ret
.found_entry:
    stc
    ret
