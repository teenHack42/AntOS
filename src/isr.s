[BITS 32]

[EXTERN idt_set_gate]
[EXTERN put_serial]
[GLOBAL init_isr]
[EXTERN put_string]
[EXTERN short_hex]

[GLOBAL isr0]
[GLOBAL isr1]
[GLOBAL int_smile]

int_smile:
    mov ax, 0x08
    mov gs, ax
    mov dword [0xB8000],') : '
    hlt

isg:
	push edx
	push ecx
	push ebx
	push eax
	call idt_set_gate
	ret

;  0: Divide By Zero Exception
isr0:
	cli
	push byte 0	; Dummy error code for uniformity
	push byte 0
	jmp isr_common_stub

isr1:
    cli
    push byte 0
    push byte 1
    jmp isr_common_stub

isr_common_stub:
	pushad
	push ds
	push es
	push fs
	push gs

	mov ax, 0x10
	mov gs, ax

	cld
	mov eax, fault_handler
	call eax
	pop gs
	pop fs
	pop es
	pop ds
	popad
	add esp, 8
	iret		   ; pops 5 things at once: CS, EIP, EFLAGS, SS, and ESP!

dumpmsg db	'\nISR Error Dump:\n',0

fault_handler:
	pop edx	;pointer to the structure
	mov eax, [edx + (13*4)] 	;TODO figure out where this really is
	cmp eax, 0x32
	;jnb .higher
	mov ebx, eax
	mov eax, dumpmsg
	call put_serial
	mov eax, ebx
	call short_hex
	call put_serial
	.higher:
	hlt
	ret
