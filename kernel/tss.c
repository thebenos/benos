#include "include/tss.h"

TSS default_tss = {
    .esp0 = 0x20000,
    .ss0 = 0x18,
    .debug_flag = 0x00,
    .io_map = 0x00
};