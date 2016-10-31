[BITS 32]
[GLOBAL fill_irq]
[EXTERN idt_set_gate]
[EXTERN PIT_Handler]
[EXTERN put_string]

init_pit_msg db '[IRQ] ',0

fill_irq:
	push eax
	push ebx
	push ecx
	push edx

	mov eax, init_pit_msg
	call put_string

	;PIT
	mov eax, 0x20	;PIT
	mov ebx, PIT_Handler
	mov ecx, 0x0008
	mov edx, 0x8E
	call idt_set_gate

	pop edx
	pop ecx
	pop ebx
	pop eax
	ret
