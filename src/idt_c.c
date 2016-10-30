
struct idt_entry {
	unsigned short base_lo;
	unsigned short sel;        /* Our kernel segment goes here! */
	unsigned char always0;     /* This will ALWAYS be set to 0! */
	unsigned char flags;       /* Set using the above table! */
	unsigned short base_hi;
} __attribute__((packed))  __attribute__ ((aligned (8)));

struct idt_pointer {
	unsigned short limit;
	unsigned int base;
} __attribute__((packed));

extern struct idt_entry idt[256];
//struct idt_pointer idtp;
