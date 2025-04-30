#ifndef VIDEO_H
#define VIDEO_H

#include "../../klibc/stdtype.h"

#define VRAM_START              0xb8000
#define VRAM_END                0xb8fff
#define MAX_COLUMNS             80
#define MAX_ROWS                25

typedef struct
{
    udword_t x;
    udword_t y;
    ubyte_t character;
    ubyte_t attribute;
} __attribute__ ((packed)) Cursor;

extern void init_cursor(Cursor *cursor, udword_t x, udword_t y, ubyte_t character, ubyte_t attribute);
extern void move_cursor_at(Cursor *cursor, udword_t x, udword_t y);
extern void put_character(Cursor *cursor, ubyte_t character, ubyte_t attribute);
extern ubyte_t get_cursor_char(Cursor cursor);
extern ubyte_t get_cursor_attr(Cursor cursor);
extern udword_t get_cursor_x(Cursor cursor);
extern udword_t get_cursor_y(Cursor cursor);
extern Cursor cursor;

#endif