#include <display/include/colors.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>
#include <limine.h>
#include <include/lib.h>
#include <include/gdt.h>
#include <include/idt.h>
#include <display/include/console.h>
#include <asm/asm.h>
#include <drivers/include/pic.h>

__attribute__((used, section(".limine_requests")))
static volatile LIMINE_BASE_REVISION(3);

__attribute__((used, section(".limine_requests")))
static volatile struct limine_framebuffer_request framebuffer_request = {
    .id = LIMINE_FRAMEBUFFER_REQUEST,
    .revision = 0
};
__attribute__((used, section(".limine_requests_start")))
static volatile LIMINE_REQUESTS_START_MARKER;

__attribute__((used, section(".limine_requests_end")))
static volatile LIMINE_REQUESTS_END_MARKER;

void kmain(void)
{
    if (LIMINE_BASE_REVISION_SUPPORTED == false)
        HLT;

    if (framebuffer_request.response == NULL || framebuffer_request.response->framebuffer_count < 1)
        HLT;

    struct limine_framebuffer *fb = framebuffer_request.response->framebuffers[0];
    framebuffer = fb->address;
    scanline = fb->pitch;
    
    gdt_init();
    console_writestr("[ OK ] Initialized GDT\n", WHITE, BLACK);
    idt_init();
    console_writestr("[ OK ] Initialized IDT\n", WHITE, BLACK);
    pic_remap(0x20, 0x28);
    console_writestr("[ OK ] Remapped PIC to 0x20-0x2f\n", WHITE, BLACK);
    irq_clear_mask(0);
    irq_clear_mask(1);
    STI;

    while (true) HLT;
}