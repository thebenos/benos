; ===================================================================
; utils.asm
;
; Released under MIT license (see LICENSE for more infos)
;
; This file contains every informations about the filesystem. These
; informations are used in other parts of the system to interact with
; the filesystem.
; ===================================================================

[bits 16]

%define FILE_TABLE_ENTRIES          224
%define FILE_ENTRY_SIZE             13
%define FILE_NAME_SIZE              12
%define MARK_FREE_ENTRY             0x00
%define MARK_OCCUPIED_ENTRY         0x01
%define MARK_REMOVED_ENTRY          0x02

%define DRIVE_NUMBER                0x80
%define FILE_TABLE_SECTOR           19

fileTable:                          times FILE_TABLE_ENTRIES * FILE_ENTRY_SIZE db MARK_FREE_ENTRY

; Input:
; (lea) si: [fileTable]
; ax: FILE_TABLE_SECTOR
; bx: DRIVE_NUMBER
FS_save_file_table:
    mov cx, FILE_TABLE_ENTRIES

.saving:
    push ax
    push bx

    lea dx, [si]
    mov ah, 0x03
    int 0x13
    jc DISK_error

    pop bx
    pop ax

    add si, FILE_ENTRY_SIZE
    loop .saving

    ret

; Input:
; (lea) di: [fileTable]
; ax: FILE_TABLE_SECTOR
; bx: DRIVE_NUMBER
FS_load_file_table:
    mov cx, FILE_TABLE_ENTRIES

.loading:
    push ax
    push bx

    lea dx, [di]
    mov ah, 0x02
    int 0x13
    jc DISK_error

    pop bx
    pop ax

    add di, FILE_ENTRY_SIZE
    loop .loading

    ret