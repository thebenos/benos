#include <display/include/console.h>
#include <display/include/colors.h>
#include <memory/include/mm.h>
#include <memory/include/pmm.h>
#include <include/lib.h>
#include <stdint.h>

static uint8_t *bitmap = 0;
static uint64_t frames = 0;

static inline void bit_set(uint64_t bit)
{
    bitmap[bit / BITS_PER_BYTE] |= (1 << (bit % BITS_PER_BYTE));
}

static inline void bit_clear(uint64_t bit)
{
    bitmap[bit / BITS_PER_BYTE] &= ~(1 << (bit % BITS_PER_BYTE));
}

static inline int bit_test(uint64_t bit)
{
    return bitmap[bit / BITS_PER_BYTE] & (1 << (bit % BITS_PER_BYTE));
}

void pmm_init(uint64_t mm_size, uintptr_t bitmap_base)
{
    frames = mm_size / FRAME_SIZE;
    bitmap = (uint8_t *) bitmap_base;

    memset(bitmap, 0, frames / BITS_PER_BYTE);
}

uintptr_t pmm_alloc_frame()
{
    for (uint64_t i = 0; i < frames; i++)
    {
        if (!bit_test(i))
        {
            bit_set(i);
            return i * FRAME_SIZE;
        }
    }
    return 0;
}

void pmm_free_frame(uintptr_t frame)
{
    uint64_t frame_n = frame / FRAME_SIZE;
    if (frame_n >= frames)
    {
        console_writestr("[ ERR ] Frame out of range\n", RED, BLACK);
        return;
    }

    if (!bit_test(frame_n))
    {
        console_writestr("[ ERR ] Cannot free a frame more than once\n", RED, BLACK);
        return;
    }

    bit_clear(frame_n);
}

void pmm_mark_used(uintptr_t frame)
{
    uint64_t frame_n  = frame / FRAME_SIZE;
    if (frame_n >= frames)
    {
        console_writestr("[ ERR ] Frame out of range\n", RED, BLACK);
        return;
    }

    bit_set(frame_n);
}

void pmm_mark_free(uintptr_t frame)
{
    uint64_t frame_n = frame / FRAME_SIZE;
    if (frame_n >= frames)
    {
        console_writestr("[ ERR ] Frame out of range\n", RED, BLACK);
        return;
    }

    bit_clear(frame_n);
}