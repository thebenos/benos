; This file contains several subroutines used to interact with the disk.

[bits 16]

; Usage:
; int 0x13
; jc DISK_error
DISK_error:
    mov ah, 0x0e
    
    mov al, '!'
    int 0x10

    jmp $

DISK_read:
    mov ah, 0x02
    ; AL = sectors to read
    ; DL = reader
    ; DH = head
    ; CH = cylinder
    ; CL = sector
    ; ES:BX = memory address where data is copied
    int 0x13
    jc DISK_error
    ret

DISK_write:
    mov ah, 0x03
    ; AL = sectors to write
    ; DL = reader
    ; DH = head
    ; CH = cylinder
    ; CL = sector
    ; ES:BX = memory address where data is written
    int 0x13
    jc DISK_error
    ret

; Usage;
; mov ax, <cluster_number>
; call DISK_read_entry
;
; NOTE:
; At the end, the entry is stored in BX.
; 0xfff = EOF (End Of File)
DISK_read_entry:
    push ax
    push bx
    push si

    ; AX = cluster number
    imul ax, 3
    mov bx, ax
    mov si, 0x2000          ; FAT address
    add si, bx

; Read the 3 bytes of the FAT entry
    mov al, [si]                    ; 1st byte
    mov ah, [si + 1]                ; 2nd byte
    mov bl, [si + 2]                ; 3d byte

    shl ah, 4
    or ah, al
    shl bl, 8
    or bl, ah

    ret

; Usage:
; mov ax, <first_cluster>
; mov bx, <buffer>
; mov dl, <reader>
; call DISK_read_file
DISK_read_file:
    push ax
    push bx
    push cx
    push dx
    push di

    mov cx, ax
.begin:
    cmp cx, 0xfff            ; EOF?
    je .done

; Read current cluster
    mov dh, 0
    mov ch, 0
    mov ax, cx
    ; BX = buffer
    push bx
    mov es, bx
    mov al, 1
    call DISK_read
    pop bx

    add bx, 512

; Get next cluster
    mov ax, cx
    call DISK_read_entry
    mov cx, bx

    cmp cx, 0x000            ; Avoid endless loop
    je .done
    cmp cx, 0xfff            ; EOF
    jne .begin

.done:
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret