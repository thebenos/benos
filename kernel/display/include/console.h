#pragma once

#include <stdint.h>

#define PSF1_FONT_MAGIC         0x0436
#define PSF_FONT_MAGIC          0x864ab572

#define PIXEL                   uint32_t
#define FONT_SIZE               32

#define CONSOLE_WIDTH           80
#define CONSOLE_HEIGHT          25

#define COLOR_BLACK             0x00000000
#define COLOR_WHITE             0x00ffffff
#define COLOR_RED               0x00ff0000
#define COLOR_YELLOW            0x00ffff00

#define CHAR_NL                 '\n'
#define CHAR_CR                 '\r'
#define CHAR_BS                 '\b'
#define CHAR_TAB                '\t'

typedef struct
{
    uint16_t magic;
    uint8_t font_mode;
    uint8_t char_size;
} __attribute__ ((packed)) PSF1_header;

typedef struct
{
    uint32_t magic;
    uint32_t version;
    uint32_t header_size;
    uint32_t flags;
    uint32_t numglyph;
    uint32_t bytes_per_glyph;
    uint32_t height;
    uint32_t width;
} __attribute__ ((packed)) PSF_font;

typedef enum
{
    SCROLLUP,
    SCROLLDOWN
} ScrollModes;

void console_advance_cursor();
void console_putchar(unsigned short int c, int *cx, int *cy, uint32_t fg, uint32_t bg);
void console_writestr(const char *s, uint32_t fg, uint32_t bg);
void console_scroll(ScrollModes mode, int n, uint32_t bg);

extern char _binary_kernel_res_zap_light16_psf_start;
extern char _binary_kernel_res_zap_light16_psf_end;
extern char _binary_font_start[];

extern uint8_t *framebuffer;
extern uint32_t scanline;

static int cursor_x = 0;
static int cursor_y = 0;