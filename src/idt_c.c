
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

struct idt_entry idt[256];
struct idt_pointer idtp;

void idt_set_gate(unsigned char num, unsigned long base, unsigned short sel, unsigned char flags);

extern void isr0();
extern void isr1();
extern void int_smile();

extern void *memset(void *str, int c, unsigned int n);

void idt_fill(){
	idt_set_gate(0, (unsigned)isr0, 0x08, 0x8E);
	idt_set_gate(1, (unsigned)isr1, 0x08, 0x8E);
	idt_set_gate(49, (unsigned)int_smile, 0x08, 0x8E);
	//idt_set_gate(3, (unsigned)isr1, 0x10, 0x8E);

	return;
}

void idt_set_gate(unsigned char num, unsigned long base, unsigned short sel, unsigned char flags)
{
	idt[num].base_lo = base&0x0000FFFF;
	idt[num].base_hi = base&0xFFFF0000;
	idt[num].sel = sel;
	idt[num].flags = flags;
	idt[num].always0 = 0x00;
	return;
}

void InitIDT_C() {
	idtp.limit= (8 * 256) -1; // 8 because thats the size of the struct theoretically TODO use sizeof function
	idtp.base = (unsigned int) &idt;
	unsigned int *r;
	r = (unsigned int*)memset(&idt, 0, 8 * 256);
	return;
}
