#!/bin/bash

trap "rm -r build" EXIT
set -e

mkdir build

echo "----- STARTING BUILD -----"

echo "Compiling "boot/boot.asm"..."
nasm -f bin -o build/BOOT.BIN boot/boot.asm
echo "Compiling "kernel/kernel.asm"..."
nasm -f bin -o build/KERNEL.BIN kernel/kernel.asm

mformat -f1440 -B build/BOOT.BIN -C -i benos.img
mcopy -D o -i benos.img build/KERNEL.BIN ::/

echo "----- BUILD COMPLETE -----"