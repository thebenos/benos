#!/bin/bash

# This ffile is used to automatically build BenOS. Please notice that you
# need NASM and BASH to run it. If you are not using a Linux system, do not
# use this file, it won't work.

# Exit if there is an error
set -e

# Define the variables
OS_VERSION="0.0.7 Indev 1"

BUILD_DIR="build"

BOOTLOADER_FILE="boot/boot.asm"
KERNEL_FILE="kernel/kernel.asm"

BOOTLOADER_BIN="$BUILD_DIR/boot.bin"
KERNEL_BIN="$BUILD_DIR/kernel.bin"

ASSEMBLER="nasm"
FILES_FORMAT="bin"

IMAGE_FILE="benos"

# Tell the user that the build is starting
echo "---------- Building BenOS version $OS_VERSION ----------"

# Check if the build directory exists. If yes, then remove it.
# (Re)create it next.
if [ -d $BUILD_DIR ]; then
    rm -r $BUILD_DIR
fi

mkdir $BUILD_DIR

# Assemble the OS files
echo "Assembling $BOOTLOADER_FILE -> $BOOTLOADER_BIN..."
$ASSEMBLER -f $FILES_FORMAT -o $BOOTLOADER_BIN $BOOTLOADER_FILE

echo "Assembling $KERNEL_FILE -> $KERNEL_BIN..."
$ASSEMBLER -f $FILES_FORMAT -o $KERNEL_BIN $KERNEL_FILE

# Make the BenOS image
echo "Creating OS image..."
cat $BOOTLOADER_BIN $KERNEL_BIN | dd of=$IMAGE_FILE bs=512 count=2880 status=none
echo "Image created as $IMAGE_FILE"

# Tell the user that the build is finished
echo "---------- Build finished ----------"