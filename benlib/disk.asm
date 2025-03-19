; This file contains several subroutines used to interact with the disk
; and the filesystem.
;
; IMPORTANT:
; This file depends of "lib/stdio.asm", so you must include it in your
; program too.

[bits 16]

; Usage:
; int 0x13
; jc DISK_error
DISK_error:
    mov ah, 0x0e
    
    mov al, '!'
    int 0x10

    jmp $

; Usage:
; call DISK_list_files
DISK_list_files:
    push bx
    push cx
    push si

    mov bx, 0

.next_file:
    cmp bx, FILE_TABLE_ENTRIES
    je .list_done

    cmp byte [fileTable + bx], MARK_FREE_ENTRY
    je .next_entry

    cmp byte [fileTable + bx], MARK_REMOVED_ENTRY
    je .next_entry

    cmp byte [fileTable + bx], MARK_OCCUPIED_ENTRY
    je .found_file

    add bx, FILE_NAME_SIZE
    jmp .next_file

.found_file:
    push bx

    mov cx, FILE_NAME_SIZE

    lea si, [fileTable + bx + 1]
    lea di, [.file_list_tmp]

    .copy_name:
        lodsb
        stosb
        loop .copy_name

    lea si, [.file_list_tmp]
    mov cx, FILE_NAME_SIZE

    .print_name:
        lodsb
        int 0x10
        loop .print_name

    mov si, NEWLINE
    call STDIO_print

    pop bx

    jmp .next_entry

.next_entry:
    add bx, FILE_NAME_SIZE
    jmp .next_file

.list_done:
    pop si
    pop cx
    pop bx

    ret

.file_list_tmp:         times FILE_NAME_SIZE db 0

; Usage:
; mov si, <filename>
; call DISK_create_file
DISK_create_file:
    push bx
    push cx
    push si

    mov bx, 0

.next_file:
    cmp bx, FILE_TABLE_ENTRIES
    je .no_free_entry_found

    cmp byte [fileTable + bx], MARK_FREE_ENTRY
    je .free_entry_found

    cmp byte [fileTable + bx], MARK_REMOVED_ENTRY
    je .free_entry_found

    add bx, FILE_NAME_SIZE
    jmp .next_file

.free_entry_found:
    mov byte [fileTable + bx], MARK_OCCUPIED_ENTRY

    inc bx
    mov cx, FILE_NAME_SIZE

    .copy_name:
        lodsb
        mov byte [fileTable + bx], al
        inc bx
        loop .copy_name

    pop si
    pop cx
    pop bx

    ret

.no_free_entry_found:
    mov si, .msg
    call STDIO_print

    pop si
    pop cx
    pop bx

    ret

.msg:   db "No free entry found.", 13, 10, 0

; Usage:
; mov si, <filename>
; call DISK_remove_file
DISK_remove_file:
    push bx
    push cx
    push si
    push di

    mov cx, FILE_NAME_SIZE
    lea di, [.file_name_tmp]
.copy_filename:
    mov al, [si]
    mov [di], al
    inc si
    inc di
    loop .copy_filename

    mov bx, 0

.search_entry:
    cmp bx, FILE_TABLE_ENTRIES * FILE_ENTRY_SIZE
    jae .file_not_found

    cmp byte [fileTable + bx], MARK_OCCUPIED_ENTRY
    jne .skip_entry

    lea si, [.file_name_tmp]
    lea di, [fileTable + bx + 1]
    mov cx, FILE_NAME_SIZE

.compare_loop:
    mov al, [si]
    mov dl, [di]
    cmp al, dl
    jne .not_match
    inc si
    inc di
    loop .compare_loop

    mov byte [fileTable + bx], MARK_REMOVED_ENTRY
    jmp .end

.not_match:
.skip_entry:
    add bx, FILE_NAME_SIZE
    jmp .search_entry

.file_not_found:
    mov si, .no_file
    call STDIO_print

.end:
    pop di
    pop si
    pop cx
    pop bx
    ret

.file_name_tmp: times FILE_NAME_SIZE db 0
.no_file:       db "File not found", 13, 10, 0