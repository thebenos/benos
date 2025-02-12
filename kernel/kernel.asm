[bits 16]
[org 0x0]

%macro check_command 3
    mov di, %1
    call %2
    jc %3
    mov si, prpBuffer
%endmacro

start:
; Initialize segments
    mov ax, 0x1000
    mov ds, ax
    mov es, ax
    mov ax, 0x8000
    mov ss, ax
    mov sp, 0xf000

    mov si, segInit
    call STDIO_print

; Kernel loaded
    mov si, krnLoaded
    call STDIO_print

    mov si, SYS_NAME
    call STDIO_print
    mov si, prtTitle
    call STDIO_print
    mov si, SYS_VERSION
    call STDIO_print
    mov si, NEWLINE
    call STDIO_print

wait_for_key:
; Wait if a key is pressed to start the shell
    mov si, keyPress
    call STDIO_print

    call STDIO_waitkeypress

    cmp al, 0                   ; Check if al is not 0
    jnz .start_shell

    jmp wait_for_key
.start_shell:
    mov si, NEWLINE
    times 2 call STDIO_print

    jmp shell_begin

; Shell
shell_begin:
; Display the prompt
    mov si, prompt
    call STDIO_print

; Start the input
    mov di, prpBuffer
    call STDIO_input

    mov si, prpBuffer

; Manage scrollup
    inc byte [lnsOnScreen]
    cmp byte [lnsOnScreen], 24
    je .scrollup

; Check commands
    check_command cmdInfo, STRING_compare, .command_info
    check_command cmdInfo_version, STRING_compare, .command_info_version
    check_command cmdInfo_name, STRING_compare, .command_info_name

    check_command cmdHelp, STRING_compare, .command_help
    check_command cmdHelp_info, STRING_compare, .command_help_info
    check_command cmdHelp_halt, STRING_compare, .command_help_halt

    check_command cmdHalt, STRING_compare, .command_halt

    jmp .command_unknow

    .command_unknow:
    ; Handle unknow commands
    ; Check if the command is empty
        call STRING_length
        cmp ax, 0
        jz shell_begin

    ; Check if the command contains something
        mov si, cmdUnknow
        call STDIO_print

        jmp shell_begin

; Continue the prompt
    jmp shell_begin
.scrollup:
; Scroll up the screen
    mov al, 1
    dec byte [lnsOnScreen]
    call VIDEO_scrollup
    
    jmp shell_begin
.command_info:
; Cannot use 'info' alone without arguments
    mov si, cmdInfo_error
    call STDIO_print

    jmp shell_begin

    .command_info_version:
    ; Display the version of the system
        mov si, SYS_VERSION
        call STDIO_print
        mov si, NEWLINE
        call STDIO_print

        jmp shell_begin
    .command_info_name:
    ; Display the name of the system
        mov si, SYS_NAME
        call STDIO_print
        mov si, NEWLINE
        call STDIO_print

        jmp shell_begin
.command_help:
; Display a list of all the available commands
    mov si, msgHelp_main
    call STDIO_print

    jmp shell_begin
    .command_help_info:
    ; Display a list of all the available options for the 'info' command
        mov si, msgHelp_info
        call STDIO_print

        jmp shell_begin
    .command_help_halt:
    ; Display a list of all the available options for the 'halt' command
        mov si, msgHelp_halt
        call STDIO_print

        jmp shell_begin
.command_halt:
; Stop the system
    hlt

; ----- INCLUDES -----
%include "lib/stdio.asm"
%include "lib/video.asm"
%include "lib/string.asm"
%include "lib/disk.asm"
%include "lib/general.asm"

; ----- DATA -----
segInit:            db      "[OK] Segments initialized", 13, 10, 0
krnLoaded:          db      "[OK] Kernel loaded successfully", 13, 10, 0
prompt:             db      "BenOS> ", 0
prtTitle:           db      " version ", 0
keyPress:           db      "Press a key to continue...", 0

prpBuffer:          times 256 db 0
progNameBuffer:     times 11 db 0

lnsOnScreen:        db      0

cmdUnknow:          db      "Unknow command.", 13, 10, 0
cmdInfo:            db      "info", 0
cmdHelp:            db      "help", 0
cmdHalt:            db      "halt", 0

; Commands arguments
cmdInfo_version:    db      "info -v", 0
cmdInfo_name:       db      "info -n", 0

cmdHelp_info        db      "help info", 0
cmdHelp_halt        db      "help halt", 0

; Commands errors
cmdInfo_error:      db      "'info' command requires an option.", 13, 10, 'Try help info for a list of options.', 13, 10, 0

; Help messages
msgHelp_main:
    db "HELP -- Available commands:", 13, 10
    db "- info <-v/-n>", 13, 10
    db "- help [command]", 13, 10
    db "- halt", 13, 10
    db 0

msgHelp_info:
    db "INFO -- Available options:", 13, 10
    db "1. -v : display the version of the system", 13, 10
    db "2. -n : display the name of the system", 13, 10
    db 0

msgHelp_halt:
    db "HALT -- Available options:", 13, 10
    db "No option is available for now", 13, 10
    db 0