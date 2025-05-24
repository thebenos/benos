#ifndef SYSCALL_H
#define SYSCALL_H

#include "../../../klibc/stdtype.h"
#include "../../../kernel/include/gdt.h"
#include "../../../klibc/stdio.h"

void do_syscalls(int syscall_number);

#endif