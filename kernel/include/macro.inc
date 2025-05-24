%macro SAVE_REGISTERS 0
    pushad
    push ds
    push es
    push fs
    push gs
    push ebx
    mov bx, 0x10
    mov ds, bx
    pop ebx
%endmacro

%macro LOAD_REGISTERS 0
    pop gs
    pop fs
    pop es
    pop ds
    popad
%endmacro