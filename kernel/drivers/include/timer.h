#pragma once

#include <stdint.h>

#define PIT_DEFAULT_HZ              1193182

void pit_init(uint64_t frequency);