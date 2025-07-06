#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>
#include <limine.h>
#include <include/lib.h>
#include <display/include/console.h>

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

static void hcf(void)
{
    for (;;) asm ("hlt");
}

void kmain(void)
{
    if (LIMINE_BASE_REVISION_SUPPORTED == false)
        hcf();

    if (framebuffer_request.response == NULL || framebuffer_request.response->framebuffer_count < 1)
        hcf();

    struct limine_framebuffer *fb = framebuffer_request.response->framebuffers[0];
    framebuffer = fb->address;
    scanline = fb->pitch;

    for (int i = 0; i <= 28; i++)
        console_writestr("Text lol\n", COLOR_RED, COLOR_BLACK);
    console_writestr("Hello!\n", COLOR_YELLOW, COLOR_BLACK);

    hcf();
}