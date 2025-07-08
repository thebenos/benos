# Console

## Overview
The BenOS text console uses the [Limine](https://github.com/limine-bootloader/limine) framebuffer and [a .psf font](https://github.com/thebenos/benos/blob/main/kernel/res/zap-light32.psf) to display text.

---

## Related files
- [`kernel/display/include/console.h`](https://github.com/thebenos/benos/blob/main/kernel/display/include/console.h)
- [`kernel/display/include/colors.h`](https://github.com/thebenos/benos/blob/main/kernel/display/include/colors.h)
- [`kernel/display/include/chars.h`](https://github.com/thebenos/benos/blob/main/kernel/display/include/chars.h)
- [`kernel/display/console.c`](https://github.com/thebenos/benos/blob/main/kernel/display/console.c)

---

## Constants
There are **32 constants for colors** in `kernel/display/include/colors.h` and **5 constants for special characters** in `kernel/display/include/chars.h`.

The constants defined in `kernel/display/include/console.h` are:

PSF1_FONT_MAGIC and PSF_FONT_MAGIC: magic values used for PSF parser
PIXEL: also used in the PSF parser
FONT_SIZE: the size of the used font
CONSOLE_WIDTH and CONSOLE_HEIGHT: the size of the console (80x25)

## Structures
```c
// Source: kernel/display/include/console.h

// Structure of a PSF1 header
typedef struct
{
    uint16_t magic;
    uint8_t font_mode;
    uint8_t char_size;
} __attribute__ ((packed)) PSF1_header;

// Structure of a PSF font
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
```

## Enums
```c
typedef enum
{
    SCROLLUP,
    SCROLLDOWN
} ScrollModes;
```
This enum is used by the `console_scroll()` function explained below.

## Functions
```c
// Source: kernel/display/include/console.h
void console_advance_cursor();
```
This function advances of 1 character the cursor in the console.

```c
// Source: kernel/display/include/console.h
void console_putchar(unsigned short int c, int *cx, int *cy, uint32_t fg, uint32_t bg);
```
This function displays a character `c` at the given position `cx,cy` with the colors `fg` and `bg`.

```c
// Source: kernel/display/include/console.h
void console_writestr(const char *s, uint32_t fg, uint32_t bg);
```
This function displays a string `s` in the console with the colors `fg` and `bg`.

```c
// Source: kernel/display/include/console.h
void console_writehex(uint64_t n, uint32_t fg, uint32_t bg);
```
This function displays an hexadecimal value `n` in the console with the colors `fg` and `bg`.

```c
// Source: kernel/display/include/console.h
void console_memdump(uint8_t *address, size_t length, uint32_t fg, uint32_t bg);
```
This function displays `length` bytes from a memory address `address` in the console with the colors `fg` and `bg`.

```c
// Source: kernel/display/include/console.h
void console_scroll(ScrollModes mode, int n, uint32_t bg);
```
This function scrolls up or down (depending of the given ScrollMode) in the console. The new lines will get the colors `fg` and `bg`.