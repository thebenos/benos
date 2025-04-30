#ifndef BENLIBC_STDIO_H
#define BENLIBC_STDIO_H

#include "../drivers/include/video.h"
#include "stdtype.h"

extern void put_char(ubyte_t character);
extern void print(ubyte_t *string);
extern void println(ubyte_t *string);

extern ubyte_t get_char();
extern byte_t read(byte_t *buffer, dword_t size);

#endif