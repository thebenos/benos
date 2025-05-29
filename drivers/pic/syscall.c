#include <drivers/pic/include/syscall.h>

void do_syscalls(int syscall_number)
{
    byte_t *u_str;

    if (syscall_number == 1)
    {
        asm("mov %%ebx, %0" : "=m"(u_str) :);
        print(u_str);
    }
    else
        println("Invalid syscall");

    return;
}