# BenOS
*A small free and open-source 16 bits operating system.*

## What is BenOS?
BenOS is a small, free and open-source 16-bit operating system. It's still under development, coded entirely in x86 Assembly, and is still in need of major improvements.

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
nasm -f bin -o build/boot.bin src/boot.asm # Compile the bootloader
nasm -f bin -o build/kernel.bin src/kernel.asm # Compile the kernel
cat build/boot.bin build/kernel.bin /dev/zero | dd of=benos.img bs=512 count=2880 # Create the disk image
```

## Running the OS
Finally, you can run BenOS with your favorite emulator! (or directly on an USB key but this is not recommended for now).

Example with qemu:
```bash
qemu-system-x86_64 -drive format=raw,file=benos.img
```

## Versions history
Here is the list of all the versions and their features:

Version 0.1.0:
- First release
- Bootloader
- Kernel
- 'help' command
- 'version' command
- 'info' command
- 'echo' command
- 'halt' command
- 'reboot' command
- Standard library:
--> stdio.inc (print, read, clear_screen)
--> string.inc (strcmp, compare_start_strings, tokenize_string, length_string)

  ## Links
  https://discord.gg/uYzHw6bU (Discord server)

Version 0.1.1:
- Removed useless constant in [src/kernel.asm](src/kernel.asm)
- Added 'disk.inc' to the standard library with 'disk_error'
- Improved bootloader to handle errors when reading sectors
- Added [CONTRIBUTING.md](CONTRIBUTING.md) file
- Updated [README.md](README.md) file
- Replaced 'run.sh' by [build.sh](build.sh)
- Handle backspaces in user inputs
