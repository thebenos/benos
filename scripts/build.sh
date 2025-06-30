#!/bin/bash

set -e

D_ISO="../iso"
D_ISO_BOOT="$D_ISO/boot"
D_ISO_BOOT_GRUB="$D_ISO_BOOT/grub"
D_BOOT="../boot"
D_BUILD="../build"
D_KERNEL="../kernel"
D_CONFIG="../config"

F_ISO="../benos.iso"

mkdir -p "$D_BUILD"

ASM="nasm"
CC="gcc"
LINKER="ld"

CFLAGS="-I.. -Wall -Wextra -g -ffreestanding -nostdlib -mno-red-zone -fno-pie -fno-stack-protector -m64"
LFLAGS="-T link.ld -z noexecstack"

$ASM -f elf64 -o "$D_BUILD/bootstrap.o" "$D_BOOT/bootstrap.asm"

$CC -c "$D_KERNEL/bootinfo.c" -o "$D_BUILD/bootinfo.o" $CFLAGS
$CC -c "$D_KERNEL/serial.c" -o "$D_BUILD/serial.o" $CFLAGS
$CC -c "$D_KERNEL/kernel.c" -o "$D_BUILD/kernel.o" $CFLAGS

$LINKER $LFLAGS -o "$D_BUILD/kernel.elf" \
"$D_BUILD/bootstrap.o" \
"$D_BUILD/bootinfo.o" \
"$D_BUILD/serial.o" \
"$D_BUILD/kernel.o"

mkdir -p "$D_ISO_BOOT_GRUB"
cp "$D_CONFIG/grub.cfg" "$D_ISO_BOOT_GRUB/grub.cfg"
cp "$D_BUILD/kernel.elf" "$D_ISO_BOOT/kernel.elf"

grub-mkrescue -o "$F_ISO" "$D_ISO"