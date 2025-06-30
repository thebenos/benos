ENTRY(kernel_start)

SECTIONS
{
    . = 0x100000;

    .text : {
        *(.multiboot2)
        *(.text*)
    }

    .rodata : {
        *(.rodata*)
        *(.rodata.*)
    }

    .data : {
        *(.data*)
    }

    .bss : {
        *(.bss*)
    }
}