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

antos	dd	'AntOS\n', 0
antosserial dd	'AntOS\nThis is serial and it can print anything\nHere is a Hex 0x',0

ant_kernel_main:
	mov ebx, esp	;save the base of the stack
	push eax			;always have this first as values from grub are pushed to the stack
	call clear_screen
	mov eax, antos
	call put_string

	call init_paging		;start this early
	call init_gdt			;then this
	mov ax, 0x28	;tss
	ltr ax			;load the tss

	mov ax, 0x0404
	call set_cursor
	mov byte [text_attribute], 0x77

	hlt
