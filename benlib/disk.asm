; ===================================================================
; disk.asm
;
; Released under MIT license (see LICENSE for more informations)
;
; This file is part of the Benlib. It contains several subroutines
; that are used to interact with the disk and the filesystem. To use
; it in your program, type the following code:
;
; %include "benlib/disk.asm"
; ===================================================================

[bits 16]

; Use it with INT 0x13
DISK_error:
    mov si, .msg
    call STDIO_print

    hlt

.msg:       db      "[ ERR ] An error occured while operating on disk", 13, 10, 0

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

; Input:
; SI -> name of the file to create
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

; Input:
; SI -> name of the file to remove
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
    cmp bx, FILE_TABLE_ENTRIES
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
    jmp .end

.end:
    pop di
    pop si
    pop cx
    pop bx
    ret

.file_name_tmp: times FILE_NAME_SIZE db 0
.no_file:       db "File not found", 13, 10, 0