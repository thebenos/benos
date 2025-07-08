# Keyboard driver

## Overview

The keyboard driver handles input from the PS/2 keyboard, translates raw scancodes into ASCII characters, and keeps track of the current modifier state (Shift, Ctrl, AltGr).

It relies on the PS/2 controller for low-level communication and uses IRQ1 to receive keyboard events.

---

## Related files

- [`kernel/drivers/include/kbd.h`](https://github.com/thebenos/benos/blob/main/kernel/drivers/include/kbd.h)
- [`kernel/drivers/kbd.c`](https://github.com/thebenos/benos/blob/main/kernel/drivers/kbd.c)

---

## Scancode handling

- The driver supports **Set 1** scancodes (as configured by the PS/2 controller).
- Scancodes are read via port `0x60`.
- A key press sends a “make” code.
- A key release sends a “break” code (make code + `0x80`).

---

## Keymaps

There are two lookup tables:

- `keyboard_map_normal`: standard ASCII for non-shifted keys.
- `keyboard_map_shift`: uppercase/symbols for when Shift is active.

```c
// Example: 'a' key
keyboard_map_normal[0x1E] = 'a';
keyboard_map_shift[0x1E]   = 'A';
```

---

## Modifier keys

The driver keeps track of:

- **Shift** (`K_LEFT_SHIFT`, `K_RIGHT_SHIFT`)
- **Ctrl** (`K_CTRL`)
- **AltGr** (`K_ALTGR`)

Each of them toggles a flag (e.g., `shift_pressed`), updated depending on whether the scancode is a make or break.

---

## Functions

### `kbd_read_scancode()`

```c
uint8_t kbd_read_scancode();
```

Reads the latest scancode from port `0x60`.

---

### `kbd_scancode_to_char(uint8_t scancode)`

```c
char kbd_scancode_to_char(uint8_t scancode);
```

- Takes a scancode (from `kbd_read_scancode()`).
- Updates modifier key states.
- Returns the corresponding ASCII character, or `0` if:
  - It was a modifier key
  - It's a break code
  - It's an unrecognized key

---

## Dependencies

- **PS/2 controller**: receives raw scancodes via IRQ1
- **I/O ports**: read scancodes from `0x60`
- **PIC**: IRQ1 routing
- **Console** (if output is needed elsewhere)

---

## Notes

- The driver does not include a key buffer (FIFO) or blocking `getchar()` yet.

