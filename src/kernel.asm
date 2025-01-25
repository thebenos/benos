[BITS 16]               ; Real mode
[ORG 0x0]

jmp start

%macro check_command 3
    mov di, %1
    call %2
    jc %3
    mov si, cmdBuffer
%endmacro

%include "std/stdio.inc"
%include "std/string.inc"

start:
    ; Initialize segments
    mov ax, 0x100
    mov es, ax
    mov ds, ax
    ; Initialize stack
    mov ax, 0x8000
    mov ss, ax
    mov sp, 0xf000

    ; Display kernel info messages
    write kernelStarted
    write nl

shell_loop:
    ; Just in case
    clc

    ; Start the prompt
    write prompt

    input cmdBuffer
    mov si, cmdBuffer

    ; Check the commands
    check_command command_info, compare_strings, .cmd_info
    check_command command_help, compare_strings, .cmd_help
    check_command command_echo, compare_start_strings, .cmd_echo
    check_command command_version, compare_strings, .cmd_version
    check_command command_halt, compare_strings, .cmd_halt
    check_command command_reboot, compare_strings, .cmd_reboot

    write message_error

    jmp shell_loop

; echo <text>
.cmd_echo:
    strcmp cmdBuffer, command_echo
    ; then
    ; print only a newline
    jc .cmd_echo.nl_echo
    ; else:
    ; wipe "echo "
    call tokenize_string
    mov si, di
    ; check arguments length
    call length_string
    cmp ax, 0
    ; if no argument, print a newline
    je .cmd_echo.nl_echo
    ; else, print arguments
    write si
    write nl
    jmp .cmd_echo.done_echo

    .cmd_echo.nl_echo:
        write nl

    .cmd_echo.done_echo:
        jmp shell_loop

; info
.cmd_info:
    write message_info
    jmp shell_loop

; help
.cmd_help:
    write message_help
    jmp shell_loop

; version
.cmd_version:
    write message_version
    jmp shell_loop

; halt
.cmd_halt:
    cli
    hlt

; reboot
.cmd_reboot:
    cli
    jmp 0x07c0
    sti

; SECTION -- Variables
kernelStarted       db      "Kernel started!", 13, 10, 0

message_info        db      "BenOS is a 16-bits operating system developped by Wither__", 13, 10, 0
message_help        db      "Commands:", 13, 10, 'help echo info version halt reboot', 13, 10, 0
message_version     db      "0.1.1", 13, 10, 0
message_error       db      "Invalid command.", 13, 10, 0

cmdBuffer times 255 db      0
prompt              db      "BenOS> ", 0

command_echo        db      'echo', 0
command_info        db      'info', 0
command_help        db      'help', 0
command_version     db      'version', 0
command_halt        db      'halt', 0
command_reboot      db      'reboot', 0