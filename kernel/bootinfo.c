#include <kernel/include/bootinfo.h>

/*
    This function will be used later
*/
void parse_mb2(uint64_t mb2_info_addr)
{
    mb2_tag_t *tag = (mb2_tag_t *)(mb2_info_addr + 8);

    while (tag->type != 0)
    {
        switch (tag->type)
        {
            case 6: // memmap
            {
                struct
                {
                    uint32_t type;
                    uint32_t size;
                    uint32_t entry_size;
                    uint32_t entry_version;
                } *mmap_tag = (void *) tag;

                typedef struct
                {
                    uint64_t addr;
                    uint64_t len;
                    uint32_t type;
                    uint32_t zero;
                } mb2_mmap_entry_t;

                mb2_mmap_entry_t *entry = (mb2_mmap_entry_t *)(mmap_tag + 1);
                while ((uint8_t *)entry < (uint8_t *)tag + tag->size)
                {
                    entry = (mb2_mmap_entry_t *)((uint8_t *) entry + mmap_tag->entry_size);
                }
                break;
            }

            case 8: // framebuffer
            {
                struct
                {
                    uint32_t type;
                    uint32_t size;
                    uint64_t addr;
                    uint32_t pitch;
                    uint32_t width;
                    uint32_t height;
                    uint8_t bpp;
                    uint8_t type_fb;
                    uint8_t reserved;
                } *fb_tag = (void *) tag;

                break;
            }
        }

        tag = (mb2_tag_t *)((uint64_t) tag + ((tag->size + 7) & ~7));
    }
}