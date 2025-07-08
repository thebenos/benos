# The PS/2 keyboard driver

## Overview
The PS/2 Controller (often called the “Keyboard controller”) is located on the mainboard. In the early days the controller was a single chip (Intel 8042). (Source: https://wiki.osdev.org/I8042_PS/2_Controller)

In BenOS, the PS/2 driver is used to initialize and manage the PS/2 Controller, which is necessary to make the keyboard driver work properly.

---

## Related files
- [`kernel/drivers/include/ps2.h`](https://github.com/thebenos/benos/blob/main/kernel/drivers/include/ps2.h)
- [`kernel/drivers/ps2.c`](https://github.com/thebenos/benos/blob/main/kernel/drivers/ps2.c)

---

## Constants
*All these constants are defined in `kernel/drivers/include/ps2.h`.*

| Name               | Value | Description                                              |
|--------------------|-------|----------------------------------------------------------|
| `KBD_DATA`         | 0x60  | Data port used for commands and responses               |
| `KBD_STATUS_OBF`   | Bit   | Output Buffer Full – set when data is ready to be read  |
| `KBD_STATUS_IBF`   | Bit   | Input Buffer Full – set when controller is processing   |
| `KBD_DISABLE_PORT1`| Byte  | Command to disable the first PS/2 port                  |
| `KBD_ENABLE_PORT1` | Byte  | Command to enable the first PS/2 port                   |
| `KBD_READ_CONF`    | Byte  | Command to read the controller configuration byte       |
| `KBD_WRITE_CONF`   | Byte  | Command to write to the controller configuration byte   |
| `KBD_SELF_TEST`    | Byte  | Command to run a self-test of the controller            |

## Initialization flow
The initialization sequence involves:

1. Disabling the first PS/2 port
2. Flushing the output buffer
3. Reading and editing the controller configuration byte
4. Performing the controller self-test
5. Reseting the keyboard
6. Setting the keyboard scancode set

## I/O synchronization
The two static functions used for I/O synchronization are:

```c
// Source: kernel/drivers/ps2.c

static void wait_ibf_clear();       // Wait for the input buffer to be clear
static void wait_obf_full();        // Wait for the output buffer to be full
```

## Core functions
There are two core functions, but the first one is used nowhere in the kernel. It is just here because it could be useful for the future.

```c
// Source: kernel/drivers/include/ps2.h

void ps2_set_typematic_rate(uint8_t rate);
void ps2_controller_init();
```

So `ps2_set_typematic_rate()` is not used yet. It modifies the typematic rate (in Hz).
The most important function of this driver is the second one: `ps2_controller_init()`.
Check [the initialization flow ](#initialization-flow) to see what it exactly does.

## Error handling and warnings
Here are the different handled errors and warnings you can get:

### `ps2_set_typematic_rate()`
**[WARN]** Failed to set typematic on PS/2 controller
This warning may occur if the controller doesn't support typematic rate configuration or is unresponsive.

**[WARN]** Bad configuration setting for PS/2 controller
This indicates an invalid response was received after attempting to set the typematic rate.

### `ps2_controller_init()`
**[ERR]** PS/2 controller self test failed
The controller returned an unexpected result during its self-test.

**[ERR]** Failed to reset the PS/2 keyboard
The keyboard did not acknowledge the reset command.

**[WARN]** Keyboard didn't acknowledge 0xF0
The keyboard did not acknowledge the 0xF0 command (used to set scancode mode).

**[WARN]** Keyboard didn't accept Scancode Set 1
The keyboard rejected the requested scancode set. It may still work using the default set (likely 2 or 3).