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
#include <memory/include/vmm.h>

__attribute__((used, section(".limine_requests")))
static volatile LIMINE_BASE_REVISION(3);

__attribute__((used, section(".limine_requests")))
static volatile struct limine_framebuffer_request framebuffer_request = {
    .id = LIMINE_FRAMEBUFFER_REQUEST,
    .revision = 0
};
__attribute__((used, section(".limine_requests")))
static volatile struct limine_memmap_request memmap_request = {
    .id = LIMINE_MEMMAP_REQUEST,
    .revision = 0
};

__attribute__((used, section(".limine_requests_start")))
static volatile LIMINE_REQUESTS_START_MARKER;

__attribute__((used, section(".limine_requests_end")))
static volatile LIMINE_REQUESTS_END_MARKER;

extern uint8_t _kernel_end;

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
    pmm_init(frames, (uint64_t)&_kernel_end);

    console_writestr("[ OK ] Initialized PMM\n", WHITE, BLACK);

    vmm_init();
    console_writestr("[ OK ] Initialized VMM\n", WHITE, BLACK);
}

void kmain(void)
{
    if (LIMINE_BASE_REVISION_SUPPORTED == false)
        HLT;

    if (framebuffer_request.response == NULL || framebuffer_request.response->framebuffer_count < 1)
        HLT;
    if (memmap_request.response == NULL || memmap_request.response->entry_count < 1)
        HLT;

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