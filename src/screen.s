[BITS 32]
[SECTION .text]
[GLOBAL clear_screen]
[GLOBAL set_character]
[GLOBAL put_char]

screen_address	dd	0xB8000
cursor_x 	dd	0x0
cursor_y	dd	0x0
colour	db	0x07
cursor_x_max	dd	0x50 ;80 characters
cursor_y_max	dd	0x19 ;25 characters

put_char:
	pop ecx
	call set_character
	ret

set_character:
	mov eax, [cursor_y] ;y cordinate
	mov ebx, [cursor_x_max] ; multiply by max line length
	sti
	mul ebx
	mov ebx, [cursor_x]
	add eax, ebx ; add x cordinate to that
	mov ebx, 0x2
	mul ebx
	sti
	add eax, [screen_address]
	sti
	mov dword [eax], ecx
	sti
	ret

; clear_screen writes zeros to the screen text buffer
clear_screen:
	mov edx, [screen_address]
clear_screen_loop:
	mov word [edx], 0x0700
	add dword  edx, 0x2
	cmp dword edx, (0xB8000 + 0xF9E)
	jbe clear_screen_loop
	ret
