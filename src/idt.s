[BITS 32]

[GLOBAL init_idt]
[GLOBAL idt_memset]
[GLOBAL idt]
[EXTERN InitIDT_C]
[EXTERN init_isr]

idtp:	dw	0x0	;Limit
	dd	0x0		;Base

align 4096
idt:	times	8*256 db	0x0	;clear a struct for the idt

init_idt:
	mov ebp, esp		;try this out
	call InitIDT_C				;In idt_c.c
								;pop ebp
	mov eax, idtp
	mov word [eax], 0x7FF		;length is (8*256) -1
	mov dword [eax + 2], idt	;pointer to idt
	cli
	lidt [idtp]	
	ret
