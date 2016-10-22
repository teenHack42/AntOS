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

antos	dd	'AntOS\nThis is AntOS the fully x86 nasm assembly OS!\nMore new Lines!!!!\n', 0
antos1 dd	'This text is in another colour\n', 0
antos2 dd	'This text is in another position.\n', 0
antos3 dd	'And we can print Hex 0x', 0
antosserial dd	'AntOS\nThis is serial and it can print anything\nHere is a Hex 0x',0
antosserial1 dd '\nWrite Something Here: ',0

ant_kernel_main:
	push eax			;always have this first as values from grub are pushed to the stack
	call clear_screen
	mov eax, antos
	call put_string
	mov byte [text_attribute], 0x7A
	mov eax, antos1
	call put_string
	mov eax, 0x0805
	call set_cursor
	mov byte [text_attribute], 0x0D
	mov eax, antos2
	call put_string
	mov eax, 0x0806
	call set_cursor
	mov eax, antos3
	call put_string
	mov byte [text_attribute], 0x0C
	mov eax, 42
	call short_hex
	call put_string

	mov eax, antosserial
	call put_serial
	mov eax, 43
	call short_hex
	call put_serial
	mov eax, antosserial1
	call put_serial

	mov eax, 0x0807
	call set_cursor

	.read:
	call read_serial
	mov eax,0
	pop ax
	cmp al, 0
	je .read
	push ax
	call put_char
	jmp .read
	mov al, '!'
	push ax
	call put_char
	hlt
