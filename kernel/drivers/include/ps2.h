#pragma once

#include <stdint.h>

#define KBD_STATUS                  0x64
#define KBD_DATA                    0x60

#define KBD_STATUS_OBF              0x01
#define KBD_STATUS_IBF              0x02

#define KBD_DISABLE_PORT1           0xad
#define KBD_ENABLE_PORT1            0xae
#define KBD_READ_CONF               0x20
#define KBD_WRITE_CONF              0x60
#define KBD_SELF_TEST               0xaa

void ps2_set_typematic_rate(uint8_t rate);
void ps2_controller_init();