[bits 16]

%macro check_param 2
    push di
    mov si, di
    mov di, %1
    call STRING_compare
    jc %2
    pop di
%endmacro