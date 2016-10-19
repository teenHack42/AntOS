#ifndef IO_H
#define IO_H

#include <stdint.h>
#include <stdbool.h>

static inline bool irq_enabled()
{
    unsigned long flags;
    asm volatile ( "pushf\n\t"
                   "pop %0"
                   : "=g"(flags) );
    return flags & (1 << 9);
}

static void outb(uint16_t port, uint8_t val);

static void outw(uint16_t port, uint16_t val);

static void outl(uint16_t port, uint32_t val);

static uint8_t inb(uint16_t port);

static uint16_t inw(uint16_t port);

static uint32_t inl(uint16_t port);

static inline bool irq_enabled();

#endif//IO_H
