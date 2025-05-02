# BenOS - The Ben Operating System

*BenOS is a small, hand-written, free and open-source 32bit operating system.*

## What is BenOS?
BenOS is a small, hand-written, free and open-source 32bit operating system still in active development. The goal of BenOS is not to become the new most used operating system in the world but to work. If it works, it is good.

## Repository structure
This repository is very simple. It contains 2 branches:
- Main (the last stable version)
- Indev (the last unstable version)

Every stable versions (and unstable versions since the 0.0.9-Indev1) can be downloaded as raw images (excepted after the 0.0.9-Indev2, which provides an ISO file) directly from the (releases)[https://github.com/thebenos/benos/releases].

## Project structure
If the repository structure looks simple, the project structure is more complex.
- `boot/`: this directory contains all the files required for the system to boot (excepted the GRUB configuration file, which is in `iso/`)
- `drivers/`: this directory contains all the kernel drivers (used in the klibc or directly in the kernel)
- `iso/`: this directory is used to make `benos.iso`. It contains `grub.cfg`
- `kernel/`: this directory contains all the files directly related to the kernel
- `klibc/`: this directory contains **the headers** of the klibc
- `klibdef/`: this directory contains **the source files** of the klibc
- `build.sh`: this file is used to compile BenOS and make `benos.iso`

## Programming languages
BenOS uses the following programming language:
- x86 NASM
- C
- BASH

## How to build it?
Building BenOS is a very simple process.

### Before building
**Make sure you have the following tools installed on your system:**
- gcc
- nasm
- ld
- grub-mkrescue

### Now we can build!
1. Clone this repository:
```bash
git clone https://github.com/thebenos/benos
```
2. Go into the BenOS directory:
```bash
cd benos
```
3. Allow `build.sh` to be executed:
```bash
chmod +x build.sh
```
4. Run `build.sh`:
```bash
./build.sh
```
Congratulations! `benos.iso` should appear!

## How to run it?
**BenOS has not been tried on *real hardware*!**

You can run BenOS in an emulator. In this example, we will use `qemu`.
```bash
qemu-system-i386 -cdrom benos.iso
```

## How to contribute?
If you want to contribute to the project, please read CONTRIBUTING.md first!
