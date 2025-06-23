#pragma once

#include <stdint.h>

typedef struct mb2_tag
{
    uint32_t type;
    uint32_t size;
} mb2_tag_t;

void parse_mb2(uint64_t mb2_info_addr);