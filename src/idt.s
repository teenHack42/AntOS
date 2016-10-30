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

[EXTERN isr0]
[EXTERN isr1]
[EXTERN int_smile]

fill_idt:
	mov eax, 0
	mov ebx, isr0
	mov ecx, 0x0008
	mov edx, 0x8E
	call idt_set_gate

	mov eax, 1
	mov ebx, isr1
	mov ecx, 0x0008
	mov edx, 0x8E
	call idt_set_gate

	ret

idt_set_gate:
	push edx
	push ecx
	push ebx
	mov ebx, 0x08
	mul ebx		;set offset
	add eax, [idtp+2]		;add base address of pointer
	pop ebx
	mov word [eax+0], bx		;offset 0-15
	shr ebx, 16					;get higher bits 16-31
	mov word [eax+6], bx		;offset 16-21
	pop ebx					;selector
	mov word [eax+2], bx		;slector word
	pop ebx				;flags byte
	mov byte [eax+5], bl
	mov byte [eax+4], 0x0		;zero
	ret

init_idt:
	mov ebp, esp		;try this out

	mov eax, idtp
	mov word [eax], 0x7FF		;length is (8*256) -1
	mov dword [eax + 2], idt	;pointer to idt

	call fill_idt

	cli
	lidt [idtp]
	ret
