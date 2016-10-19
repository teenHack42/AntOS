#ifndef STDIO_H
#define STDIO_H

#include <stdint.h>
#include <stddef.h>

void fgets();

void fopen();

void fprintf();

void fputs();

void fread();

void getc();

void perror();

int printf( const char* format, ... );

void puts();

void scanf();

void sprintf();

void *memset(void *str, int c, size_t n);

#endif
