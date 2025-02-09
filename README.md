# BenOS
*A small free and open-source operating system.*

## What is BenOS?
BenOS is a small, free and open-source operating system still in active development.

## Why should you use BenOS?
What a stupid question... you shouldn't lol!
Explanation:
BenOS don't have a lot of features for now, but I am working hard to improve it, and you can contribute [here](CONTRIBUTING.md)!
But you can always try it and suggest improvements.

## Build
You have two ways to build BenOS:
1. Automatic method
2. Manual method

### The automatic method
Just execute the following commands:
```bash
chmod +x build.sh
./build.sh
```
The binary files will be created in the `build` directory.

### The manual method
To build the OS manually, execute in order the following commands:
```bash
mkdir build # Create the build directory
nasm -f bin -o build/bootloader.bin boot/bootloader.asm # Compile the bootloader
nasm -f bin -o build/kernel.bin kernel/kernel.asm # Compile the kernel
cat build/bootloader.bin build/kernel.bin /dev/zero | dd of=benos bs=512 count=2880 # Create the disk image
```

## Running the OS
Finally, you can run BenOS with your favorite emulator! (or directly on an USB key but this is not recommended for now).

Example with qemu:
```bash
qemu-system-x86_64 -drive format=raw,file=benos
```

## Versions history
Here is the list of all the versions and their features:

##### Version 0.0:
- First version

## Links
Join our official Discord server: https://discord.gg/AJjmXgXy
