#include <drivers/include/kbd.h>
#include <drivers/include/ps2.h>
#include <cpu/include/io.h>
#include <stdbool.h>
#include <stdint.h>

const char keyboard_map_normal[128] = {
    0, 27, '1', '2', '3', '4', '5', '6',
    '7', '8', '9', '0', '-', '=', '\b', /* Backspace */
    '\t',               /* Tab */
    'q', 'w', 'e', 'r',
    't', 'y', 'u', 'i', 'o', 'p', '[', ']', '\n', /* Enter key */
    0,                  /* Control */
    'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';', '\'', '`',
    0,                  /* Left shift */
    '\\', 'z', 'x', 'c', 'v', 'b', 'n', 'm', ',', '.', '/',
    0,                  /* Right shift */
    '*',
    0,                  /* Alt */
    ' ',                /* Space bar */
};

const char keyboard_map_shift[128] = {
    0, 27, '!', '@', '#', '$', '%', '^',
    '&', '*', '(', ')', '_', '+', '\b',
    '\t',
    'Q', 'W', 'E', 'R',
    'T', 'Y', 'U', 'I', 'O', 'P', '{', '}', '\n',
    0,
    'A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', ':', '"', '~',
    0,
    '|', 'Z', 'X', 'C', 'V', 'B', 'N', 'M', '<', '>', '?',
    0,
    '*',
    0,
    ' ',
};

uint8_t kbd_read_scancode()
{
    return inb(KBD_DATA);
}

char kbd_scancode_to_char(uint8_t scancode)
{
    bool released = scancode & 0x80;
    uint8_t make_code = scancode & 0x7F;

    if (released) {
        switch (make_code)
        {
            case K_LEFT_SHIFT: case K_RIGHT_SHIFT: shift_pressed = false; break;
            case K_CTRL: ctrl_pressed = false; break;
            case K_ALTGR: altgr_pressed = false; break;
        }
        return 0;
    }

    switch (make_code)
    {
        case K_LEFT_SHIFT: case K_RIGHT_SHIFT: shift_pressed = true; return 0;
        case K_CTRL: ctrl_pressed = true; return 0;
        case K_ALTGR: altgr_pressed = true; return 0;
    }

    if (make_code >= 128)
        return 0;

    if (shift_pressed)
        return keyboard_map_shift[make_code];
    else
        return keyboard_map_normal[make_code];
}