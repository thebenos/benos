#!/bin/bash

# Remove build directory
rm -r build

# Make build directory
mkdir build

# Make binaries
echo "01 src/boot.asm -> build/boot.bin"
nasm -f bin -o build/boot.bin src/boot.asm

echo "02 src/kernel.asm -> build/kernel.bin"
nasm -f bin -o build/kernel.bin src/kernel.asm

cat build/boot.bin build/kernel.bin /dev/zero | dd of=benos.img bs=512 count=2880 iflag=fullblock