#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <display/include/console.h>
#include <include/lib.h>
#include <display/include/colors.h>
#include <display/include/chars.h>

extern char _binary_kernel_res_zap_light32_psf_start;
extern char _binary_kernel_res_zap_light32_psf_end;
extern char _binary_font_start[];

uint8_t *framebuffer = NULL;
uint32_t scanline = 0;

static int cursor_x = 0;
static int cursor_y = 0;

static void display_newline()
{
    cursor_x = 0;
    cursor_y++;
    if (cursor_y >= CONSOLE_HEIGHT)
    {
        console_scroll(SCROLLUP, 1, BLACK);
        cursor_y = CONSOLE_HEIGHT - 1;
    }
}

void console_advance_cursor()
{
    cursor_x++;
    if (cursor_x >= CONSOLE_WIDTH)
        display_newline();
}

void console_putchar(unsigned short int c, int *cx, int *cy, uint32_t fg, uint32_t bg)
{
    PSF_font *font = (PSF_font*)&_binary_kernel_res_zap_light32_psf_start;
    int bytesperline = (font->width + 7) / 8;

    switch (c)
    {
        case CHAR_NL:
            display_newline();
            return;

        case CHAR_CR:
            (*cx) = 0;
            return;

        case CHAR_BS:
            if (*cx > 0)
                (*cx)--;
            else if (*cy > 0)
            {
                (*cy)--;
                (*cx) = CONSOLE_WIDTH - 1;
            }
            return;

        case CHAR_TAB:
            (*cx) += 4;
            if (*cx >= CONSOLE_WIDTH)
            {
                (*cx) = 0;
                (*cy)++;
                if (*cy >= CONSOLE_HEIGHT)
                {
                    console_scroll(SCROLLUP, 1, bg);
                    (*cy) = CONSOLE_HEIGHT - 1;
                }
            }
            return;

        default:
            if (c >= font->numglyph)
                c = 0;

            unsigned char *glyph = (unsigned char*)&_binary_kernel_res_zap_light32_psf_start
                                   + font->header_size
                                   + c * font->bytes_per_glyph;

            for (int y = 0; y < FONT_SIZE; y++) {
                for (int x = 0; x < font->width; x++) {
                    unsigned char byte = glyph[y * bytesperline + (x / 8)];
                    int bit = 7 - (x % 8);
                    int pixel = (byte >> bit) & 1;

                    int px = (*cx) * font->width + x;
                    int py = (*cy) * FONT_SIZE + y;

                    PIXEL *dst = (PIXEL*)(framebuffer + py * scanline + px * sizeof(PIXEL));
                    *dst = pixel ? fg : bg;
                }
            }

            (*cx)++;
            if (*cx >= CONSOLE_WIDTH)
            {
                (*cx) = 0;
                (*cy)++;
                if (*cy >= CONSOLE_HEIGHT)
                {
                    console_scroll(SCROLLUP, 1, bg);
                    (*cy) = CONSOLE_HEIGHT - 1;
                }
            }
            return;
    }
}

void console_writestr(const char *s, uint32_t fg, uint32_t bg)
{
    for (size_t i = 0; s[i] != '\0'; i++)
        console_putchar(s[i], &cursor_x, &cursor_y, fg, bg);
}

void console_writehex(uint64_t n, uint32_t fg, uint32_t bg)
{
    console_writestr("0x", fg, bg);

    bool leading = true;
    for (int i = 60; i >= 0; i -= 4)
    {
        uint8_t nibble = (n >> i) & 0xf;
        if (nibble == 0 && leading && i == 0)
            continue;
        leading = false;

        char c = (nibble < 10) ? ('0' + nibble) : ('a' + nibble - 10);
        console_putchar(c, &cursor_x, &cursor_y, fg, bg);
    }

    if (leading)
        console_putchar('0', &cursor_x, &cursor_y, fg, bg);
}

void console_memdump(uint8_t *address, size_t length, uint32_t fg, uint32_t bg)
{
    char c1, c2;
    char *tab = "0123456789abcdef";

    while (length--)
    {
        c1 = tab[(*address & 0xf0) >> 4];
        c2 = tab[*address & 0x0f];
        address++;

        console_putchar(c1, &cursor_x, &cursor_y, fg, bg);
        console_putchar(c2, &cursor_x, &cursor_y, fg, bg);
    }
}

void console_scroll(ScrollModes mode, int n, uint32_t bg)
{
    if (n <= 0) return;

    int scroll_pixels = n * FONT_SIZE;
    int height_pixels = CONSOLE_HEIGHT * FONT_SIZE;

    if (scroll_pixels > height_pixels) scroll_pixels = height_pixels;

    size_t bytes_per_line = scanline;
    size_t fb_size = height_pixels * bytes_per_line;

    switch (mode)
    {
        case SCROLLUP:
        {
            memmove(framebuffer, framebuffer + scroll_pixels * bytes_per_line, fb_size - scroll_pixels * bytes_per_line);

            uint32_t *start = (uint32_t*)(framebuffer + (height_pixels - scroll_pixels) * bytes_per_line);
            int pixels_to_clear = (scroll_pixels * scanline) / sizeof(uint32_t);
            for (int i = 0; i < pixels_to_clear; i++)
                start[i] = bg;

            break;
        }

        case SCROLLDOWN:
        {
            memmove(framebuffer + scroll_pixels * bytes_per_line, framebuffer, fb_size - scroll_pixels * bytes_per_line);

            uint32_t *start = (uint32_t*)framebuffer;
            int pixels_to_clear = (scroll_pixels * scanline) / sizeof(uint32_t);
            for (int i = 0; i < pixels_to_clear; i++)
                start[i] = bg;

            break;
        }

        default:
            break;
    }
}

void console_clear(uint32_t bg)
{
    int height_px = CONSOLE_HEIGHT * FONT_SIZE;
    int width_px = CONSOLE_WIDTH * FONT_SIZE;

        for (int y = 0; y < height_px; y++)
        {
            for (int x = 0; x < width_px; x++)
            {
                PIXEL *dst = (PIXEL*)(framebuffer + y * scanline + x * sizeof(PIXEL));
                *dst = bg;
            }
        }

    cursor_x = 0;
    cursor_y = 0;
}