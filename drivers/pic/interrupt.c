#include "include/interrupt.h"
#include "../../klibc/stdtype.h"
#include "../../klibc/stdio.h"
#include "../include/io.h"
#include "../include/kboard.h"

void ISR_default(void)
{
    println("Interrupt");
}

void ISR_clock(void)
{
    static dword_t tic = 0;
    static dword_t second = 0;

    tic++;
    if (tic % 100 == 0)
    {
        second++;
        tic = 0;
        println("Clock");
    }
}

void ISR_keyboard(void)
{
    ubyte_t i;

    static dword_t lshift_enable;
    static dword_t rshift_enable;
    static dword_t alt_enable;
    static dword_t ctrl_enable;

    do
    {
        i = inb(0x64);
    } while ((i & 0x01) == 0);

    i = inb(0x60);
    i--;

    if (i < 0x80)
    {
        switch (i)
        {
            case 0x29:
                lshift_enable = 1;
                break;
            case 0x35:
                rshift_enable = 1;
                break;
            case 0x1c:
                ctrl_enable = 1;
                break;
            case 0x37:
                alt_enable = 1;
                break;
            default:
                put_char(keyboard_map[i * 4 + (lshift_enable || rshift_enable)]);
        }
    }
    else
    {
        switch (i)
        {
            case 0x29:
                    lshift_enable = 0;
                    break;
            case 0x35:
                    rshift_enable = 0;
                    break;
            case 0x1C:
                    ctrl_enable = 0;
                    break;
            case 0x37:
                    alt_enable = 0;
                    break;
        }
    }
}