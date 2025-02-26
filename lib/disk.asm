; This file contains several subroutines used to interact with the disk
; and the filesystem.
;
; IMPORTANT:
; This file depends of "lib/stdio.asm", so you must include it in your
; program too.

[bits 16]

; Usage:
; int 0x13
; jc DISK_error
DISK_error:
    mov ah, 0x0e
    
    mov al, '!'
    int 0x10

    jmp $

; Usage:
; call DISK_reset
DISK_reset:
    push ax
    push dx

    mov ax, 0
    mov dl, [bootdev]
    stc
    int 0x13

    pop dx
    pop ax

    ret

; Usage:
; mov ax, <sector>
; call DISK_l2hts
DISK_l2hts:
    push bx
    push ax

    mov bx, ax

    mov dx, 0
    div word [SectorsPerTrack]
    add dl, 0x01
    mov cl, dl
    mov ax, bx

    mov dx, 0
    div word [SectorsPerTrack]
    mov dx, 0
    div word [Sides]
    mov dh, cl
    mov ch, al

    pop ax
    pop bx

    mov dl, [bootdev]
    
    ret

DISK_list_rootdir:
    push ax
    push bx
    push cx
    push dx
    push di
    push si

    mov word [.tmp_file_list], ax

    mov eax, 0

    call DISK_reset

    mov ax, 19
    call DISK_l2hts

    mov si, DISK_BUFFER
    mov bx, si

    mov ah, 2
    mov al, 14

    push ax
    push bx
    push cx
    push dx
    push di
    push si

.read_rootdir:
    pop si
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    push ax
    push bx
    push cx
    push dx
    push di
    push si

    stc
    int 0x13
    call DISK_reset
    jnc .display_init

    call DISK_reset
    jnc .read_rootdir
    
    jmp .done

.display_init:
    pop si
    pop di
    pop dx
    pop cx
    pop bx
    pop ax

    mov ax, 0
    mov si, DISK_BUFFER

    mov word di, [.tmp_file_list]

.entry_start:
    mov al, [si + 11]

    cmp al, 0
    jz .done

    mov cx, 1
    mov dx, si

.entry_test:
    inc si

    mov al, [si]
    
    cmp al, ' '
    jl .entry_next
    cmp al, '~'
    ja .entry_next

    inc cx

    cmp cx, 11
    je .found_filename

    jmp .entry_test

.found_filename:
    mov si, dx

    mov cx, 0

.copy_loop:
	mov byte al, [si]
	cmp al, ' '
	je .space_found
	mov byte [di], al
	inc si
	inc di
	inc cx
	cmp cx, 8
	je .put_dot
	cmp cx, 11
	je .copied
	jmp .copy_loop

.space_found:
	inc si
	inc cx
	cmp cx, 8
	je .put_dot
	jmp .copy_loop

.put_dot:
    mov byte [di], '.'
    inc di

    jmp .copy_loop

.copied:
    mov byte [di], ','
    inc di

.entry_next:
    mov si, dx

.done:
    dec di
    mov byte [di], 0

    pop si
    pop di
    pop dx
    pop cx
    pop bx
    pop ax

    ret

.tmp_file_list:     dw      0

bootdev:        db      0x80