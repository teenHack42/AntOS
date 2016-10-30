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

;  0: Divide By Zero Exception
isr0:
	cli
	push byte 0x32	; Dummy error code for uniformity
	push byte 0x33
	jmp isr_common_stub

isr1:
    cli
    push byte 0
    push byte 1
    jmp isr_common_stub

isr_common_stub:
	;pushad
	push ebp
	push eax
	push ebx
	push ecx
	push edx
	push esi
	push edi
	push ds

	mov ax, 0x10
	mov gs, ax
	mov es, ax
	mov ss, ax
	mov ds, ax
	mov fs, ax

	cld
	call fault_handler

	pop ds
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	pop eax
	pop ebp

	add esp, 8		;get rid of the arguments from the orriginal call

	iretd		   ; pops 5 things at once: CS, EIP, EFLAGS, SS, and ESP!
	hlt			;if that fails

dumpmsg db	'ISR Error Dump. Instruction 0x',0
dumpmsge db	' : ',0
dumpmsg1 db	'\nAX: 0x',0
dumpmsg2 db	'  BX: 0x',0
dumpmsg3 db	'\nCX: 0x',0
dumpmsg4 db	'  DX: 0x',0
dumpmsg5 db	'\nESI: 0x',0
dumpmsg6 db	'  EDI: 0x',0
dumpmsg7 db	'\nDS: 0x',0

nl db '\n',0
space db ': 0x',0

error_out:
	push ebx
	push eax
	call put_serial

	pop eax
	call put_string
	pop ebx
	ret

[EXTERN text_attribute]
[EXTERN to_hex]

fault_handler:

	mov byte [text_attribute], 0x40

	mov eax, dumpmsg
	call error_out

	mov edx, esp

	mov eax, [edx+(0xB*4)]	;EIP
	call to_hex
	call error_out

	mov eax, dumpmsge
	call error_out

	mov edx, esp
	mov ecx, [edx+(0xB*4)]	;EIP
	mov eax, [ecx]			;get instruction and params
	call to_hex
	call error_out

	mov eax, dumpmsg1		;EAX
	call error_out
	mov edx, esp
	mov eax, [edx+(7*4)]	;EAX
	call to_hex
	call error_out

	mov eax, dumpmsg2		;ECX
	call error_out
	mov edx, esp
	mov eax, [edx+(6*4)]	;ECX
	call to_hex
	call error_out

	mov eax, dumpmsg3		;EDX
	call error_out
	mov edx, esp
	mov eax, [edx+(5*4)]	;EDX
	call to_hex
	call error_out

	mov eax, dumpmsg4		;EBS
	call error_out
	mov edx, esp
	mov eax, [edx+(4*4)]	;EBS
	call to_hex
	call error_out

	mov eax, dumpmsg5		;ESP
	call error_out
	mov edx, esp
	mov eax, [edx+(3*4)]	;ESP
	call to_hex
	call error_out

	mov eax, dumpmsg6		;EBP
	call error_out
	mov edx, esp
	mov eax, [edx+(2*4)]	;EBP
	call to_hex
	call error_out

	mov eax, dumpmsg7		;ESI
	call error_out
	mov edx, esp
	mov eax, [edx+(1*4)]	;ESI
	call to_hex
	call error_out

	mov eax, nl
	call error_out

	mov ecx, 0
	mov edx, esp
	.loopf:
	push ecx
	push edx
	mov eax, ecx
	call short_hex
	call error_out
	mov eax, space
	call error_out
	pop edx
	push edx
	mov eax, [edx]
	call to_hex
	call error_out
	mov eax, nl
	call error_out
	pop edx
	pop ecx

	cmp dword [edx], 0x2BADB002			;Start of the stack
	je	.end_stack_dump

	inc edx
	inc edx		;go up the stack towards the start
	inc edx
	inc edx

	inc ecx
	cmp ecx, 0x20
	jle .loopf
	.end_stack_dump:

	ret
	hlt
