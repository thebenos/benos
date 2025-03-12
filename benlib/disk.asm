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

.next_file:
    cmp byte [fileTable + bx], MARK_FREE_ENTRY
    je .list_done

    cmp byte [fileTable + bx], MARK_REMOVED_ENTRY
    je .removed_file

    cmp byte [fileTable + bx], MARK_OCCUPIED_ENTRY
    je .found_file

    inc bx

    jmp .next_file

.found_file:
    mov si, .msg_found_file
    call STDIO_print

    inc bx

    jmp .next_file

.removed_file:
    inc bx

    jmp .next_file

.list_done:
    pop bx

    ret

.msg_found_file:        db      "File found.", 13, 10, 0

DISK_create_file:
    push bx

.next_file:
    cmp byte [fileTable + bx], MARK_FREE_ENTRY
    je .free_entry_found

    cmp byte [fileTable + bx], MARK_REMOVED_ENTRY
    je .free_entry_found

    cmp byte [fileTable + bx], FILE_TABLE_ENTRIES
    je .no_free_entry_found

    inc bx

    jmp .next_file

.free_entry_found:
    mov byte [fileTable + bx], MARK_OCCUPIED_ENTRY

    pop bx

    ret

.no_free_entry_found:
    mov si, .msg
    call STDIO_print

    pop bx

    ret

.msg:       db      "No free entry found.", 13, 10, 0

DISK_remove_file:
    push bx

.next_file:
    cmp byte [fileTable + bx], MARK_OCCUPIED_ENTRY
    je .file_found

    inc bx

    jmp .next_file

.file_found:
    mov byte [fileTable + bx], MARK_REMOVED_ENTRY

    pop bx

    ret

.msg:           db          "No file has been created.", 13, 10, 0