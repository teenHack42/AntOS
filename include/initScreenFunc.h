#ifndef INITSCREENFUNC_H
#define INITSCREENFUNC_H
#include "stdint-gcc.h"
/*
	Writes a String to screen and accomodates for new lines
*/
void write_string( int colour, const char *string );


void clear_screen();

void scroll_screen();

void put_char(unsigned char colour, const char character);
#endif//INITSCREENFUNC_H
