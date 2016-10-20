[BITS 32]
[SECTION .text]

[GLOBAL ant_kernel_main]
[EXTERN clear_screen]
[EXTERN set_character]
[EXTERN put_char]

ant_kernel_main:
	push eax
	call clear_screen
	mov  eax, 'RBGA'
	push eax
	call put_char
	hlt
