[bits 16]

; Handle disk errors
disk_error:
    mov ah, 0x0e
    
    mov al, '!'
    int 0x10

    jmp $