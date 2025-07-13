# BenOS - The Ben Operating System

*BenOS is a small, hand-written, free and open-source 64-bit operating system.*

## What is BenOS?
BenOS is a small, hand-written, free and open-source 64-bit operating system currently under active development. The goal of BenOS is not to become the new most used operating system in the world but to work. If it works, then it's good.

## Features
- 64-bit x86_64 kernel
- PS/2 keyboard support
- Basic text console
- UEFI boot via OVMF
- ISO generation support

## Repository structure
This repository is very simple. It contains 3 branches:

- Main (the last stable version)
- gh-pages (the GitHub Pages branch)

Every stable versions (and unstable versions since the 0.0.9-Indev1) can be downloaded as raw images (excepted after the 0.0.9-Indev2, which provides an ISO file) directly from the (releases)[https://github.com/thebenos/benos/releases].

## Project structure
- `docs/`: the website code
- `kernel/`: the kernel source code
- `GNUmakefile`: main build system
- `iso.sh`: ISO creation script

## Programming languages
BenOS uses the following programming languages:
- C
- BASH
- GNU make
- x86_64 NASM

## How to build
Building BenOS is a very simple process.

### Before building
**Make sure you have the following tools installed on your system:**
- a C compiler (gcc/clang)
- ld
- nasm
- xorriso (for ISO creation)

### Build instructions
1. Clone the repository:
```bash
git clone https://github.com/thebenos/benos
```
2. Build the OS:
```bash
make all
chmod +x iso.sh
./iso.sh
```

Congratulations! `benos.iso` should appear in the root folder.

## How to run
**BenOS works on real hardware too!**

You can run BenOS in an emulator. In this example, we will use `qemu`.
```bash
qemu-system-x86_64 -m 512 -cdrom benos.iso -bios /usr/share/OVMF/OVMF_CODE.fd
```
Make sure OVMF is installed if you are using UEFI.

## How to contribute
If you want to contribute to the project, please read CONTRIBUTING.md first!

## License
BenOS is licensed under the [MIT license](LICENSE).

## Full documentation
The full documentation is available on [our official website](https://thebenos.github.io/benos)!