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

	call init_pic

;	mov eax, 0x41
;	push eax
;	mov eax, 0x42
;	push eax
;	mov eax, 0x43
;	push eax
;	mov eax, 0x44
;	push eax
;	mov eax, 0x45
;	push eax

;	pushad


	call init_idt
	mov eax, 0x12345678
	mov ebx, 0xABCDEF01
	mov ecx, 0xA1B2C3D4
	mov edx, 0x0
	div edx
	;int 49

	hlt

	mov ax, 0x0404
	;call set_cursor
	mov byte [text_attribute], 0x77

	hlt
