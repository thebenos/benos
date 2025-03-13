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

    add bx, FILE_ENTRY_SIZE

    jmp .next_file

.found_file:
    mov si, .file_found
    call STDIO_print

    inc bx
    jmp .next_file

.next_entry:
    inc bx
    jmp .next_file

.list_done:
    pop si
    pop bx

    ret

.file_found:        db      "File found.", 13, 10, 0

; Usage:
; mov si, <filename>
; call DISK_create_file
DISK_create_file:
    push bx
    push si

    mov bx, 0

.next_file:
    cmp bx, FILE_TABLE_ENTRIES
    je .no_free_entry_found

    cmp byte [fileTable + bx], MARK_FREE_ENTRY
    je .free_entry_found

    cmp byte [fileTable + bx], MARK_REMOVED_ENTRY
    je .free_entry_found

    add bx, FILE_ENTRY_SIZE

    jmp .next_file

.free_entry_found:
    mov byte [fileTable + bx], MARK_OCCUPIED_ENTRY
    
    pop si
    pop bx

    ret

.no_free_entry_found:
    mov si, .msg
    call STDIO_print

    pop si
    pop bx

    ret

.msg:   db "No free entry found.", 13, 10, 0

DISK_remove_file:
    push bx

.next_file:
    cmp byte [fileTable + bx], MARK_OCCUPIED_ENTRY
    je .file_found

    add bx, FILE_ENTRY_SIZE

    jmp .next_file

.file_found:
    mov byte [fileTable + bx], MARK_REMOVED_ENTRY

    pop bx

    ret

.msg:           db          "No file has been created.", 13, 10, 0