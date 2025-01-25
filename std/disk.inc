; This file is part of the standard library.
; It contains subroutines to read/write with the disk.

%include "std/macros.inc"

disk_error:
    write error
    jmp $

error db "Failed to read sectors.", 13, 10, 0