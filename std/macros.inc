%ifndef macros_inc
%define macros_inc

%macro write 1
    mov si, %1
    call print
%endmacro

%macro input 1
    mov di, %1
    call read
%endmacro

%macro strcmp 2
    mov si, %1
    mov di, %2
    call compare_strings
%endmacro

%endif