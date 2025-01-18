#!/bin/bash

nasm -f bin -o bin/boot.bin src/boot.asm
nasm -f bin -o bin/kernel.bin src/kernel.asm

cat bin/boot.bin bin/kernel.bin /dev/zero | dd of=floppyA bs=512 count=2880 iflag=fullblock

qemu-system-x86_64 -k fr -drive format=raw,file=floppyA