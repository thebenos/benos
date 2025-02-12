#!/bin/bash

set -e

mkdir build

echo "----- STARTING BUILD -----"

echo "Compiling "boot/bootloader.asm"..."
nasm -f bin -o build/bootloader.bin boot/bootloader.asm
echo "Compiling "kernel.kernel.asm"..."
nasm -f bin -o build/kernel.bin kernel/kernel.asm

echo "Creating disk image.."
cat build/bootloader.bin build/kernel.bin /dev/zero | dd of=benos bs=512 count=2880 iflag=fullblock

rm -r build

echo "----- BUILD COMPLETE -----"