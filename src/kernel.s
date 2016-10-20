[BITS 32]
[SECTION .text]

[GLOBAL ant_kernel_main]
[EXTERN clear_screen]
[EXTERN set_character]
[EXTERN put_char]
[EXTERN put_string]
[EXTERN text_attribute]


antos	dd	'AntOS\nThis is AntOS the fully x86 nasm assembly OS!\nMore new Lines!!!!\n', 0
antos1 dd	'This text is in another colour\n', 0

ant_kernel_main:
	push eax			;always have this first as values from grub are pushed to the stack
	call clear_screen
	mov eax, antos
	call put_string
	mov byte [text_attribute], 0x7A
	mov eax, antos1
	call put_string
	hlt
