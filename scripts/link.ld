ENTRY(_start)

PHDRS
{
    text PT_LOAD FLAGS(5);
    data PT_LOAD FLAGS(6);
}

SECTIONS
{
    . = 1M;

    .text : ALIGN(4K) {
        *(.multiboot2)
        *(.text*)
        *(.rodata*)
    } :text

    .data : ALIGN(4K) {
        *(.data*)
    } :data

    .bss : ALIGN(4K) {
        *(.bss*)
        *(COMMON)
    } :data

    . = ALIGN(16);
    stack_bottom = .;
    . = . + 0x4000;
    stack_top = .;
}