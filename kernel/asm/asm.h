#pragma once

#define CLI                 asm volatile ("cli");
#define STI                 asm volatile ("sti");
#define HLT                 asm volatile ("hlt");