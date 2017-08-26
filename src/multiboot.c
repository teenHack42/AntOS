#include <multiboot2.h>

void *mbootptr;
unsigned int *charptr;

extern void put_stringf(const char *);
extern void put_hexf(const unsigned int);

void init_multiboot(void *ptr) {
	mbootptr = &ptr;
	charptr = &ptr;
	put_stringf("[MULTIBOOT] Init\n");
	unsigned int flags = (unsigned int) mbootptr;
	unsigned int mods = flags & (1<<0);
	unsigned int mods1 = flags & (1<<1);
	unsigned int mods2 = flags & (1<<2);
	unsigned int mods3 = flags & (1<<3);
	unsigned int mods4 = flags & (1<<4);
	unsigned int mods5 = flags & (1<<5);
	if (mods) {
		put_stringf("Mem Feilds Valid\n");
	}
	if (mods1) {
		put_stringf("Boot Device\n");
	}
	if (mods2) {
		put_stringf("Command Line\n");
	}
	if (mods3) {
		put_stringf("Mods\n");
		unsigned int* mods_count = *charptr+(5*4); //20
		unsigned int* mods_addr = *charptr+(6*4); //24
		put_stringf("Mods Count: ");
		put_hexf((unsigned int)(*mods_count));
		put_stringf("\n");
		put_stringf("Mods List Address: ");
		put_hexf((unsigned int)(*mods_addr));
		put_stringf("\n");
		for (int i = 0; i < *mods_count; i++) {
			unsigned int* mod_ptr = *mods_addr+(i*16);
			put_stringf("MOD No.");
			put_hexf(i);
			put_stringf("\n");
			put_stringf("ModStart: ");
			put_hexf((unsigned int)(*mod_ptr+(4*0)));
			unsigned int * p = *mod_ptr+(4*1);
			//put_stringf(*(p+(4)));
			put_stringf("\nunsigned int * p = *mod_ptr+(4*1);\n");
			put_stringf("p: ");
			put_hexf(p);
			put_stringf("\n&p: ");
			put_hexf(&p);
			put_stringf("\n*p: ");
			put_hexf(*p);
			put_stringf("\n");
			put_stringf("ModEnd: ");
			put_hexf((unsigned int)(*mod_ptr+(4*1)));
			put_stringf("\n");
			put_stringf(*(mod_ptr));
			return;
			put_stringf("\n");
			put_stringf("ModStringPtr: ");
			put_hexf((unsigned int)(*mod_ptr+(4*2)));
			put_stringf("\n\n");
			//put_stringf(*(mod_ptr+(4*2)));
			//put_stringf("\n");
		}


	}
	if (mods4) {
		put_stringf("Kernel Symble Table header\n");
	}
	if (mods5) {
		put_stringf("ELF Kernel header\n");
	}

	for (int i = 0; i < 20; i++) {
		unsigned int* mods_count = *charptr+(i*4);
		put_hexf((unsigned int)(*mods_count));
		put_stringf("\n");
	}
}
