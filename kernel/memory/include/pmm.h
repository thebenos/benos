#pragma once

#include <stdint.h>
#include <stddef.h>

#define FRAME_SIZE                  0x1000

void pmm_init(uint64_t mm_size, uintptr_t bitmap_base);
uintptr_t pmm_alloc_frame();
void pmm_free_frame(uintptr_t frame);
void pmm_mark_used(uintptr_t frame);
void pmm_mark_free(uintptr_t frame);