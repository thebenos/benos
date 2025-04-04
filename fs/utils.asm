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

%define FILE_NAME_SIZE         12
%define FILE_MARK_SIZE         1
%define FILE_ENTRY_SIZE        13
%define FILE_TABLE_ENTRIES     224
%define FILE_TABLE_SIZE        (FILE_ENTRY_SIZE * FILE_TABLE_ENTRIES)
%define FILE_TABLE_SECTORS     6
%define FILE_TABLE_START_SECTOR 33

%define MARK_FREE_ENTRY        0x00
%define MARK_REMOVED_ENTRY     0x01
%define MARK_OCCUPIED_ENTRY    0x02


fileTable:                     times FILE_TABLE_SIZE db 0
fileTableModified:             db 0

load_file_table:
    mov si, fileTable
    mov cx, FILE_TABLE_SECTORS
    mov bx, FILE_TABLE_START_SECTOR
.l_next:
    push cx
    push si
    call read_sector
    pop si
    add si, 512
    pop cx
    inc bx
    loop .l_next
    xor byte [fileTableModified], 1
    ret

save_file_table:
    cmp byte [fileTableModified], 0
    je .no_save
    mov si, fileTable
    mov cx, FILE_TABLE_SECTORS
    mov bx, FILE_TABLE_START_SECTOR
.s_next:
    push cx
    push si
    call write_sector
    pop si
    add si, 512
    pop cx
    inc bx
    loop .s_next
    xor byte [fileTableModified], 1
.no_save:
    ret

read_sector:
    push ax
    push dx
    push cx
    push es
    push si
    mov ax, 0x1000
    mov es, ax
    mov bx, 0
    call lba_to_chs
    mov ah, 0x02
    mov al, 1
    mov dl, 0x00
    int 0x13
    jc .r_fail
    mov di, si
    mov si, es:bx
    mov cx, 512
    rep movsb
    xor ax, ax
    jmp .r_done
.r_fail:
    mov ax, 1
.r_done:
    pop di
    pop es
    pop cx
    pop dx
    pop ax
    ret

write_sector:
    push ax
    push dx
    push cx
    push es
    push si
    mov ax, 0x1000
    mov es, ax
    mov di, 0
    mov cx, 512
    rep movsb
    call lba_to_chs
    mov ah, 0x03
    mov al, 1
    mov dl, 0x00
    int 0x13
    jc .w_fail
    xor ax, ax
    jmp .w_done
.w_fail:
    mov ax, 1
.w_done:
    pop si
    pop es
    pop cx
    pop dx
    pop ax
    ret

lba_to_chs:
    xor dx, dx
    mov ax, bx
    xor cx, cx
    mov dh, 0
    mov dl, 18
    div dl
    mov cl, ah
    mov dh, al
    xor dx, dx
    mov ax, bx
    mov dl, 18
    mov cx, 2
    mul dl
    div cx
    mov ch, al
    inc cl
    ret
