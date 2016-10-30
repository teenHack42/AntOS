[BITS 32]

[GLOBAL init_idt]
[GLOBAL idt_memset]
[GLOBAL idt]
[GLOBAL idt_set_gate]
[EXTERN InitIDT_C]
[EXTERN init_isr]
[EXTERN put_string]

init_idt_msg db	'[IDT]    Initalising: ',0
init_idt_done db 'Done!\n',0

idtp:	dw	0x0	;Limit
	dd	0x0		;Base

align 4096
idt:	times	8*256 db	0x0	;clear a struct for the idt

[EXTERN fill_isr]

fill_idt:
	call fill_isr

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
	mov ebp, esp		;try this out(WHAT DOES THIS DOO?)

	mov eax, init_idt_msg
	call put_string

	mov eax, idtp
	mov word [eax], 0x7FF		;length is (8*256) -1
	mov dword [eax + 2], idt	;pointer to idt

	call fill_idt

	cli
	lidt [idtp]

	mov eax, init_idt_done
	call put_string

	ret
