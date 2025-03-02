#!/bin/bash

# ======================================================================
# build.sh
#
# This file can be used on Linux distributions to automatically build
# BenOS. You need nasm and BASH to run it.
# ======================================================================

# Exit if an error is encountered
set -e

# Define the variables
OS_VERSION="0.0.6"                          # Version of BenOS
BUILD_DIR="build"                           # Path of the build directory
BOOTLOADER_FILE="boot/bootloader.asm"       # Path of the bootloader file
BOOTLOADER_BIN="$BUILD_DIR/bootloader.bin"  # Path of the bootloader binary file
ASSEMBLER="nasm"                            # Path of the compiler
IMAGE_FILE="benos"                          # Path of the BenOS image

# Start the build
echo "---------- Building BenOS version $OS_VERSION ----------"

# Check if the build directory already exists
# If yes, then remove it
echo "Looking for build directory..."
if [ -d  $BUILD_DIR ]; then
    echo "Removing build directory..."
    rm -r $BUILD_DIR
fi

# Make the build directory
echo "Making build directory..."
mkdir $BUILD_DIR

# Compile the bootloader
echo "Compiling $BOOTLOADER_FILE..."
$ASSEMBLER -f bin -o $BOOTLOADER_BIN $BOOTLOADER_FILE

# Create the BenOS image
echo "Making OS image..."
cat $BOOTLOADER_BIN /dev/zero | dd of=benos bs=512 count=2880 status=none

# Confirm that the image has been created
echo "Disk image created as '$IMAGE_FILE'"

# Finish the build
echo "---------- Build complete ----------"