#include <drivers/include/timer.h>
#include <display/include/colors.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>
#include <limine.h>
#include <include/lib.h>
#include <cpu/include/gdt.h>
#include <cpu/include/idt.h>
#include <display/include/console.h>
#include <asm/asm.h>
#include <drivers/include/pic.h>
#include <drivers/include/ps2.h>
#include <memory/include/pmm.h>
#include <memory/include/mm.h>
#include <asm/asm.h>
#include <include/boot.h>

extern uint8_t _kernel_start, _kernel_end;

void init_interrupts(void)
{
    console_writestr("[ OK ] Initialized IDT\n", WHITE, BLACK);
    pic_remap(0x20, 0x28);
    console_writestr("[ OK ] Remapped PIC to 0x20-0x2f\n", WHITE, BLACK);
    pit_init(100);
    console_writestr("[ OK ] PIT frequency set to 100 Hz\n", WHITE, BLACK);
    irq_clear_mask(0);
    irq_clear_mask(1);
}

void init_memory(void)
{
    uint64_t memory = 0;

    for (uint64_t i = 0; i < memmap_request.response->entry_count; i++)
    {
        struct limine_memmap_entry *entry = memmap_request.response->entries[i];
        if (entry->type == LIMINE_MEMMAP_USABLE)
            memory += entry->length;
    }

    uint64_t frames = memory / FRAME_SIZE;

    uint64_t bitmap_frames_size = (frames + 7) / 8;
    bitmap_frames_size = (bitmap_frames_size + FRAME_SIZE - 1) & ~(FRAME_SIZE - 1);

    pmm_init(frames, (uintptr_t)&_kernel_end);
    console_writestr("[ OK ] Initialized PMM\n", WHITE, BLACK);
    
    uint64_t cr0 = cr0_read();
    if (cr0 & (1 << 31))
        console_writestr("[ OK ] Paging already enabled\n", WHITE, BLACK);
    else
        console_writestr("[ ERR ] Paging not enabled\n", RED, BLACK);
}

void kmain(void)
{
    if (LIMINE_BASE_REVISION_SUPPORTED == false)
        HLT;

    if (framebuffer_request.response == NULL || framebuffer_request.response->framebuffer_count < 1)
        for (;;) HLT;
    if (memmap_request.response == NULL || memmap_request.response->entry_count < 1)
        for (;;) HLT;
    if (hhdm_request.response == NULL || hhdm_request.response->offset == 0)
        for (;;) HLT;

    struct limine_framebuffer *fb = framebuffer_request.response->framebuffers[0];
    framebuffer = fb->address;
    scanline = fb->pitch;
    
    gdt_init();
    console_writestr("[ OK ] Initialized GDT\n", WHITE, BLACK);
    idt_init();
    init_interrupts();
    ps2_controller_init();
    console_writestr("[ OK ] Initialized 8042 PS/2 controller\n", WHITE, BLACK);
    init_memory();

    STI;

    while (true) HLT;
}