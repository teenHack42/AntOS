#include <multiboot2.h>

void *mbootptr;

extern void put_stringf(const char *);

void init_multiboot(void *ptr) {
	mbootptr = &ptr;
	put_stringf("[MULTIBOOT] Init");
	unsigned int flags = (unsigned int) mbootptr;
	unsigned int mods = flags & (1<<3);
	unsigned int mods1= flags & (1<<1);
	unsigned int mods2= flags & (1<<2);
	unsigned int mods3= flags & (1<<4);
	unsigned int mods4= flags & (1<<5);
	if (mods) {
		put_stringf("yay");
	}
	if (mods1) {
		put_stringf("yay1");
	}
	if (mods2) {
		put_stringf("yay2");
	}
	if (mods3) {
		put_stringf("yay3");
	}
	if (mods4) {
		put_stringf("yay4");
	}
}
