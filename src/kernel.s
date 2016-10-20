[BITS 32]
[SECTION .text]

[GLOBAL ant_kernel_main]
[EXTERN clear_screen]
[EXTERN set_character]
[EXTERN put_char]
[EXTERN put_string]

ant_kernel_main:
	push eax
	call clear_screen
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant
	call grant

	hlt

grant:
	mov  eax, 'A'
	push eax
	call put_char
	mov  eax, 'n'
	push eax
	call put_char
	mov  eax, 't'
	push eax
	call put_char
	mov  eax, 'O'
	push eax
	call put_char
	mov  eax, 'S'
	push eax
	call put_char
	ret
