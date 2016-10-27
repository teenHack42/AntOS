[BITS 32]

[GLOBAL init_idt]
[GLOBAL idt_memset]
[EXTERN idtp]
[EXTERN idt]
[EXTERN InitIDT_C]
[EXTERN init_isr]

init_idt:
	mov ebp, esp		;try this out
	call InitIDT_C				;In idt_c.c
								;pop ebp
	cli
	lidt [idtp+2]				;ofset 2 bytes into the structure
	ret
