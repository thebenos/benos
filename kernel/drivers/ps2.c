#include <drivers/include/ps2.h>
#include <include/io.h>
#include <stdint.h>
#include <display/include/console.h>
#include <display/include/colors.h>

static void wait_ibf_clear()
{
    while (inb(KBD_STATUS) & KBD_STATUS_IBF);
}

static void wait_obf_full()
{
    while (!(inb(KBD_STATUS) & KBD_STATUS_OBF));
}

void ps2_set_typematic_rate(uint8_t rate)
{
    wait_ibf_clear();
    outb(KBD_DATA, 0xf3);
    wait_obf_full();
    uint8_t res = inb(KBD_DATA);
    if (res != 0xfa)
    {
        console_writestr("[ WARN ] Failed to set typematic on PS/2 controller, got: ", YELLOW, BLACK);
        console_writehex(res, YELLOW, BLACK);
        console_writestr("\n", YELLOW, BLACK);

        return;
    }

    wait_ibf_clear();
    outb(KBD_DATA, rate);
    wait_obf_full();
    uint8_t res2 = inb(KBD_DATA);
    if (res2 != 0xfa)
    {
        console_writestr("[ WARN ] Bad configuration setting for PS/2 controller, got: ", YELLOW, BLACK);
        console_writehex(res, YELLOW, BLACK);
        console_writestr("\n", YELLOW, BLACK);

        return;
    }
}

void ps2_controller_init()
{
    wait_ibf_clear();
    outb(KBD_STATUS, KBD_DISABLE_PORT1);

    while (inb(KBD_STATUS) & KBD_STATUS_OBF)
        (void)inb(KBD_DATA);

    wait_ibf_clear();
    outb(KBD_STATUS, KBD_READ_CONF);
    wait_obf_full();
    uint8_t config = inb(KBD_DATA);

    config |= 0x01;
    config &= ~0x40;

    wait_ibf_clear();
    outb(KBD_STATUS, KBD_WRITE_CONF);
    wait_ibf_clear();
    outb(KBD_DATA, config);

    wait_ibf_clear();
    outb(KBD_STATUS, KBD_SELF_TEST);
    wait_obf_full();
    uint8_t self_test_res = inb(KBD_DATA);
    if (self_test_res != 0x55)
    {
        console_writestr("[ ERR ] PS/2 controller self test failed, got: ", RED, BLACK);
        console_writehex(self_test_res, RED, BLACK);
        console_writestr("\n", RED, BLACK);

        return;
    }

    wait_ibf_clear();
    outb(KBD_DATA, 0xff);

    wait_obf_full();
    uint8_t acknowledge = inb(KBD_DATA);
    if (acknowledge != 0xfa)
    {
        console_writestr("[ ERR ] Failed to reset PS/2 keyboard, got: ", RED, BLACK);
        console_writehex(acknowledge, RED, BLACK);
        console_writestr("\n", RED, BLACK);

        return;
    }

    wait_obf_full();
    uint8_t kbd_reset = inb(KBD_DATA);
    if (kbd_reset != 0xaa)
    {
        console_writestr("[ ERR ] PS/2 keyboard self test failed, got: ", RED, BLACK);
        console_writehex(kbd_reset, RED, BLACK);
        console_writestr("\n", RED, BLACK);

        return;
    }
}