[BITS 32]
[SECTION .text]

[GLOBAL ant_kernel_main]
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

antos	dd	'AntOS\n', 0
sleepstr dd	'This string was printed after 2000 ms\n', 0

ant_kernel_main:
	mov ebx, esp	;save the base of the stack
	push eax			;always have this first as values from grub are pushed to the stack
	call clear_screen
	mov eax, antos
	call put_string

	call init_pic
	call init_idt		;Interrupts

	call init_paging		;start this early
	call init_gdt			;then this
	mov ebx, 150	;Frequency of PIT
	call init_pit

	mov eax, 2000
	push eax
	call sleep

	mov eax, sleepstr
	call put_string

	.kloop:
	nop
	jmp .kloop
	hlt
