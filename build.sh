#!/bin/bash

COMPILER_FLAGS="-m32 -ffreestanding -mno-red-zone -fno-pie -nostdlib -c"

set -e

if [ -d build ]; then
    rm -r build
fi
mkdir build

if [ -f benos.iso ]; then
    rm benos.iso
fi

mkdir -p iso/boot/grub

nasm -f elf32 boot/boot.asm -o build/boot.o
gcc $COMPILER_FLAGS kernel/tss.c -o build/tss.o
gcc $COMPILER_FLAGS kernel/gdt.c -o build/gdt.o
gcc $COMPILER_FLAGS kernel/main.c -o build/main.o
gcc $COMPILER_FLAGS drivers/video.c -o build/video.o
gcc $COMPILER_FLAGS drivers/pic/pic.c -o build/pic.o
nasm -f elf32 drivers/pic/interrupt.asm -o build/ainterrupt.o
gcc $COMPILER_FLAGS drivers/pic/interrupt.c -o build/cinterrupt.o
gcc $COMPILER_FLAGS drivers/pic/idt.c -o build/idt.o
gcc $COMPILER_FLAGS klibdef/stdio.c -o build/kstdio.o
gcc $COMPILER_FLAGS klibdef/stdlib.c -o build/kstdlib.o

ld -m elf_i386 -T kernel/link.ld -Ttext 0x1000 -o iso/boot/kernel.elf build/boot.o build/video.o \
    build/ainterrupt.o build/cinterrupt.o build/idt.o build/pic.o build/kstdio.o build/kstdlib.o \
    build/tss.o build/gdt.o build/main.o \
    -z noexecstack

cp grub.cfg iso/boot/grub/grub.cfg

grub-mkrescue -o benos.iso iso/