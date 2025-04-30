#include "include/video.h"

Cursor cursor;

void init_cursor(Cursor *cursor, udword_t x, udword_t y, ubyte_t character, ubyte_t attribute)
{
    cursor->x = x;
    cursor->y = y;
    cursor->character = character;
    cursor->attribute = attribute;
}

void move_cursor_at(Cursor *cursor, udword_t x, udword_t y)
{
    cursor->x = x;
    cursor->y = y;
}

void put_character(Cursor *cursor, ubyte_t character, ubyte_t attribute)
{
    uword_t *video_memory = (uword_t *) VRAM_START;

    int position = cursor->y * MAX_COLUMNS + cursor->x;
    video_memory[position] = (attribute << 8) | character;

    cursor->character = character;
    cursor->attribute = attribute;
}

ubyte_t get_cursor_char(Cursor cursor)
{
    return cursor.character;
}

ubyte_t get_cursor_attr(Cursor cursor)
{
    return cursor.attribute;
}

udword_t get_cursor_x(Cursor cursor)
{
    return cursor.x;
}

udword_t get_cursor_y(Cursor cursor)
{
    return cursor.y;
}