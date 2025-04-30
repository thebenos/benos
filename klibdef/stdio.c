#include "../klibc/stdio.h"

extern const byte_t scancodes[];

void put_char(ubyte_t character)
{
    if (character == 13)
        cursor.y++;
    else if (character == 10)
    {
        cursor.y++;
        cursor.x = 0;
    } else if (character == 9)
        cursor.x += 4;
    else
    {
        if (cursor.x + 1 >= MAX_COLUMNS)
        {
            cursor.x = 0;
            cursor.y = (cursor.y + 1) % MAX_ROWS;
        } else
            cursor.x++;

        move_cursor_at(&cursor, cursor.x, cursor.y);
        put_character(&cursor, character, 0x0f);
    }
}

void print(ubyte_t *string)
{
    while (*string)
        put_char(*string++);
}

void println(ubyte_t *string)
{
    print(string);
    put_char('\n');
}