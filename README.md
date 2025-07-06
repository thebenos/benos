# BenOS - The Ben Operating System

*BenOS is a small, hand-written, free and open-source 64-bit operating system.*

## What is BenOS?
BenOS is a small, hand-written, free and open-source 64-bit operating system still in active development. The goal of BenOS is not to become the new most used operating system in the world but to work. If it works, it is good.

## Repository structure
This repository is very simple. It contains 3 branches:
- Main (the last stable version)
- Indev (the last unstable version)
- Tofix (code that contains bugs that need to be fixed)

Every stable versions (and unstable versions since the 0.0.9-Indev1) can be downloaded as raw images (excepted after the 0.0.9-Indev2, which provides an ISO file) directly from the (releases)[https://github.com/thebenos/benos/releases].

## Project structure
- `docs/`: the website code
- `kernel/`: the kernel source code

## Programming languages
BenOS uses the following programming languages:
- C
- BASH
- GNU make

## How to build it?
Building BenOS is a very simple process.

### Before building
**Make sure you have the following tools installed on your system:**
- a C compiler (gcc/clang)
- ld

### Now we can build!
1. Clone this repository:
```bash
git clone https://github.com/thebenos/benos
```
2. Go into the BenOS directory:
```bash
cd benos
```
3. Execute the build script:
```bash
make all
chmod +x iso.sh
./iso.sh
```

Congratulations! `benos.iso` should appear!

## How to run it?
**BenOS has not been tried on *real hardware*!**

You can run BenOS in an emulator. In this example, we will use `qemu` (from `scripts/`).
```bash
qemu-system-x86_64 -m 512 -cdrom benos.iso -bios /usr/share/OVMF/OVMF_CODE.fd
```

## How to contribute?
If you want to contribute to the project, please read CONTRIBUTING.md first!