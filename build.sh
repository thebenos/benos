#!/bin/bash

COMPILER="gcc"
COMPILER_FLAGS="-I. -m32 -ffreestanding -mno-red-zone -fno-pie -nostdlib -c"
ASSEMBLER="nasm"
ELF32="-f elf32"
LINKER="ld"
LINKER_FLAGS="-m elf_i386 -T kernel/link.ld -z noexecstack"

set -e

if [ -d build ]; then
    rm -r build
fi
mkdir build

if [ -f benos.iso ]; then
    rm benos.iso
fi

mkdir -p iso/boot/grub

$ASSEMBLER $ELF32 boot/boot.asm -o build/boot.o
$COMPILER $COMPILER_FLAGS kernel/tss.c -o build/tss.o
$COMPILER $COMPILER_FLAGS kernel/gdt.c -o build/gdt.o
$COMPILER $COMPILER_FLAGS kernel/memory/paging.c -o build/paging.o
$COMPILER $COMPILER_FLAGS kernel/main.c -o build/main.o
$COMPILER $COMPILER_FLAGS drivers/video.c -o build/video.o
$COMPILER $COMPILER_FLAGS drivers/pic/pic.c -o build/pic.o
$COMPILER $COMPILER_FLAGS drivers/pic/syscall.c -o build/syscall.o
$ASSEMBLER $ELF32 drivers/pic/interrupt.asm -o build/ainterrupt.o
$COMPILER $COMPILER_FLAGS drivers/pic/interrupt.c -o build/cinterrupt.o
$COMPILER $COMPILER_FLAGS drivers/pic/idt.c -o build/idt.o
$COMPILER $COMPILER_FLAGS klibdef/stdio.c -o build/kstdio.o
$COMPILER $COMPILER_FLAGS klibdef/stdlib.c -o build/kstdlib.o
$COMPILER $COMPILER_FLAGS klibdef/string.c -o build/kstring.o

$LINKER $LINKER_FLAGS -o iso/boot/kernel.elf build/boot.o build/video.o \
    build/ainterrupt.o build/cinterrupt.o build/idt.o build/pic.o build/kstdio.o build/kstdlib.o \
    build/kstring.o build/tss.o build/gdt.o build/syscall.o build/paging.o build/main.o

cp grub.cfg iso/boot/grub/grub.cfg

grub-mkrescue -o benos.iso iso/