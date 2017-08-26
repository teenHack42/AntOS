[BITS 32]
[SECTION .data]
stack_pointer dd 0

[SECTION .text]

[GLOBAL ant_kernel_main]

[GLOBAL p_stack]

[EXTERN clear_screen]
[EXTERN set_character]
[EXTERN put_char]
[EXTERN put_string]
[EXTERN text_attribute]
[EXTERN set_cursor]
[EXTERN to_hex]
[EXTERN short_hex]
[EXTERN write_serial]

[EXTERN init_serial]
[EXTERN is_transmit_empty]
[EXTERN read_serial]
[EXTERN put_serial]

[EXTERN init_idt]
[EXTERN idtp]

[EXTERN init_gdt]

[EXTERN init_paging]

[EXTERN init_pic]

[EXTERN init_pit]

[EXTERN sleep]

[EXTERN fault_handler]

[EXTERN init_multiboot]

antos	dd	'AntOS\n', 0
sleepstr dd	'This string was printed after 2000 ms\n', 0

multiboot_str 		dd "Multiboot Header: ", 0
multiboot 				resb 4
multiboot_stack		resb 4

ant_kernel_main:

	mov ebx, esp	;save the base of the stack
	push eax			;always have this first as values from grub are pushed to the stack
	mov eax, stack_pointer		;mov the pointer to the stack pointer variable into eax
	mov [eax], ebx						;move the stack pointer into stack_pointer

	call clear_screen
	mov eax, antos
	call put_string

	mov eax, [esp+8]				;multiboot header pointer
	mov [multiboot], eax


	mov eax, multiboot_str
	call put_serial
	mov eax, [multiboot]
	call hex_s

	call init_pic
	call init_idt		;Interrupts

	call init_paging		;start this early
	call init_gdt			;then this
	mov ebx, 150	;Frequency of PIT
	call init_pit

	mov eax, 700
	push eax
	call sleep

	mov eax, sleepstr
	call put_string


	;call fault_handler

	mov eax, [multiboot]
	pushad
	push eax	;the value to push to the C function
	call init_multiboot
	popad

	mov edx, [multiboot]
	mov eax, [edx]
	call hex_s

	;call fault_handler

	.kloop:
	nop
	nop
	nop
	jmp .kloop
	hlt

	hex_s:
		pusha
		call to_hex
		call put_serial
		mov eax, nl
		call put_serial
		popa
	ret

	s db "l", 0

	stack_depts_str db "\nStack Depth (doubles) 0x", 0
	nl db "\n", 0
	space_sc db ": ", 0

	p_stack:
	mov edx, 0x1			;count how deep the stack is
	mov ebx, esp 			;get the stack pointer
	jmp .skip_init 		;skip adding to the stack pointer so we dont skip the first one
	.count_deep:
	inc edx						;add to how deep the stack is
	mov eax, 0x04
	add ebx, eax
	.skip_init:
	mov eax, [ebx]
	cmp eax, 0x2BADB002			;Is this the start of the stack
	jne .count_deep

	push edx
	mov eax, stack_depts_str
	call put_serial
	pop edx
	push edx
	mov eax, edx			;print how deep the stack is
	call short_hex
	call put_serial
	pop edx

	.l:
	push edx
	mov eax, nl
	call put_serial
	pop eax
	push eax
	call short_hex
	call put_serial
	mov eax, space_sc
	call put_serial
	mov eax, 0x4
	pop edx
	push edx
	mul edx
	add eax, esp
	mov eax, [eax]
	call to_hex
	call put_serial

	pop edx
	dec edx
	cmp edx, 0
	jge .l

	ret
