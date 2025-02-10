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