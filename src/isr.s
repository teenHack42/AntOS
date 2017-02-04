[BITS 32]

[EXTERN idt_set_gate]
[EXTERN put_serial]
[GLOBAL init_isr]
[EXTERN put_string]
[EXTERN short_hex]
[EXTERN idt_set_gate]
[GLOBAL fill_isr]

[GLOBAL fault_handler]

[GLOBAL isr0]
[GLOBAL isr1]
[GLOBAL isr2]
[GLOBAL isr3]
[GLOBAL isr4]
[GLOBAL isr5]
[GLOBAL isr6]
[GLOBAL isr7]
[GLOBAL isr8]
[GLOBAL isr9]
[GLOBAL isr10]
[GLOBAL isr11]
[GLOBAL isr12]
[GLOBAL isr13]
[GLOBAL isr14]
[GLOBAL isr15]
[GLOBAL isr16]
[GLOBAL isr17]
[GLOBAL isr18]
[GLOBAL isr19]

IntCounter dd 0x0		;count if an interupt caused another interupt

init_isr_msg db '[ISR] ' ,0

fill_isr:
	mov eax, init_isr_msg
	call put_string

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

	mov eax, 2
	mov ebx, isr2
	mov ecx, 0x0008
	mov edx, 0x8E
	call idt_set_gate

	mov eax, 3
	mov ebx, isr3
	mov ecx, 0x0008
	mov edx, 0x8E
	call idt_set_gate

	mov eax, 5
	mov ebx, isr5
	mov ecx, 0x0008
	mov edx, 0x8E
	call idt_set_gate

	mov eax, 6
	mov ebx, isr6
	mov ecx, 0x0008
	mov edx, 0x8E
	call idt_set_gate

	mov eax, 7
	mov ebx, isr7
	mov ecx, 0x0008
	mov edx, 0x8E
	call idt_set_gate

	mov eax, 8
	mov ebx, isr8
	mov ecx, 0x0008
	mov edx, 0x8E
	call idt_set_gate

	mov eax, 10
	mov ebx, isr10
	mov ecx, 0x0008
	mov edx, 0x8E
	call idt_set_gate

	mov eax, 11
	mov ebx, isr11
	mov ecx, 0x0008
	mov edx, 0x8E
	call idt_set_gate

	mov eax, 12
	mov ebx, isr12
	mov ecx, 0x0008
	mov edx, 0x8E
	call idt_set_gate

	mov eax, 13
	mov ebx, isr13
	mov ecx, 0x0008
	mov edx, 0x8E
	call idt_set_gate

	mov eax, 14
	mov ebx, isr14
	mov ecx, 0x0008
	mov edx, 0x8E
	call idt_set_gate

	mov eax, 16
	mov ebx, isr16
	mov ecx, 0x0008
	mov edx, 0x8E
	call idt_set_gate

	mov eax, 17
	mov ebx, isr17
	mov ecx, 0x0008
	mov edx, 0x8E
	call idt_set_gate

	mov eax, 18
	mov ebx, isr18
	mov ecx, 0x0008
	mov edx, 0x8E
	call idt_set_gate

	mov eax, 19
	mov ebx, isr19
	mov ecx, 0x0008
	mov edx, 0x8E
	call idt_set_gate

	ret

;  0: Divide By Zero Exception
isr0:
	cli
	push byte 0x0	; Dummy error code for uniformity
	push byte 0x0
	jmp isr_common_stub

isr1:
    cli
    push byte 0
    push byte 1
    jmp isr_common_stub

isr2:
	cli
      push byte 0
      push byte 2
      jmp isr_common_stub

isr3:
	cli
      push byte 0
      push byte 3
      jmp isr_common_stub

isr4:
	cli
      push byte 0
      push byte 4
      jmp isr_common_stub

isr5:
	cli
	push byte 0	; Dummy error code for uniformity
	push byte 5
	jmp isr_common_stub

isr6:
    cli
    push byte 0
    push byte 6
    jmp isr_common_stub

isr7:
	cli
      push byte 0
      push byte 7
      jmp isr_common_stub

isr8:
	cli
	;;;;;pushes error code
      push byte 8
      jmp isr_common_stub

isr9:			;do not assign this as it is used by a coprocessor

isr10:
	cli
	;pushes error code
	push byte 10
	jmp isr_common_stub

isr11:
    cli
    ;pushes error code
    push byte 11
    jmp isr_common_stub

isr12:
	cli
      ;pushes error code
      push byte 12
      jmp isr_common_stub

isr13:
	cli
      ;pushes error code
      push byte 13
      jmp isr_common_stub

isr14:
	cli
      ;pushes error code
      push byte 14
      jmp isr_common_stub

isr15: ;unassigned

isr16:
    cli
    push byte 0
    push byte 16
    jmp isr_common_stub

isr17:
	cli
      ;always 0
      push byte 17
      jmp isr_common_stub

isr18:
	cli
      push byte 0
      push byte 17
      jmp isr_common_stub

isr19:
	cli
      push byte 0
      push byte 17
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

	sti
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

isr0div0 db 'Divide By 0 ERROR\n', 0
isr1SS	db 'Single Step(Debug)\n', 0
isr2NMI	db 'Non Maskable Interrupt\n', 0
isr3Break	db 'Breakpoint\n', 0
isr4Over	db 'Overflow(Debug)\n', 0
isr5Bound	db 'Bounds Check\n', 0
isr6UnvalOP	db 'Unvalid OPCode\n', 0
isr7DNA	db 'Device not available\n', 0
isr8DF	db 'Double Fault\n', 0
isr10TSS	db 'Invalid Task State Segment\n', 0
isr11SNP	db 'Segment not present\n', 0
isr12SFE	db 'Stack Fault Exception\n', 0
isr13GPF	db 'General Protection Fault\n', 0
isr14PF	db 'Page Fault\n', 0
isr16X87	db 'x87 FPU Error\n', 0
isr17Alg	db 'Alignment Check\n', 0
isr18MC	db 'Machine Check\n', 0
isr19SIMD	db 'SIMD FPU Exception\n', 0

fault_pntr_table dd	isr0div0, isr1SS, isr2NMI, isr3Break, isr4Over, isr5Bound
					dd	isr6UnvalOP, isr7DNA, isr8DF, 0, isr10TSS, isr11SNP
					dd	isr12SFE, isr13GPF, isr14PF, 0, isr16X87, isr17Alg, isr18MC
					dd	isr19SIMD, 0

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

	mov eax, [IntCounter]
	inc eax
	mov [IntCounter], eax

	mov byte [text_attribute], 0x40

	mov eax, [esp+(0x9*4)]
	mov ebx, 4
	mul ebx
	add eax, fault_pntr_table

	mov eax, [eax]
	call error_out

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

	cmp dword [IntCounter], 12
	je .count

	mov eax, [IntCounter]
	dec eax
	mov [IntCounter], eax

	ret
	.count:
	cli
	hlt
