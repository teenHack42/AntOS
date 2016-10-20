[BITS 32]
[SECTION .text]
[GLOBAL clear_screen]
[GLOBAL set_character]
[GLOBAL put_char]
[GLOBAL put_string]

screen_address	dd	0xB8000
cursor_x 	dd	0x0
cursor_y	dd	0x0
colour	db	0x07
cursor_x_max	dd	0x50 ;80 characters
cursor_y_max	dd	0x19 ;25 characters

put_string:
	cmp byte [eax], 0
	je _end_of_string
	mov ebx, [eax]
	push eax
	push bx
	call put_char
	pop eax
	cmp bx, '\n' ;we need to skip the n in \n so we dont print it....
	jne _not_newline
	inc eax	;increment the pointer a second time(or first whatever but 2x...)
	_not_newline:
	inc eax	;increment the pntr to the next character
	loop put_string
	_end_of_string:
	ret

put_char:
	pop eax 						;eip for ret
	pop cx 						;my character
	push eax 						;put eip back on the stack...
	cmp cx, '\n' 					;check for newline character
	jne _not_new_line 					; jump if new line

	mov word [cursor_x], 0x0
	mov eax, [cursor_y]
	inc eax
	mov [cursor_y], eax
	ret

	_not_new_line:
	call set_character
	mov eax, [cursor_x]
	cmp eax, [cursor_x_max]
	je _newline
	inc eax
	mov [cursor_x], eax
	ret
	_newline:
		mov word [cursor_x], 0x0
		mov eax, [cursor_y]
		inc eax
		mov [cursor_y], eax
	ret

set_character:
	mov eax, [cursor_y] ;y cordinate
	mov ebx, [cursor_x_max] ; multiply by max line length
	mul ebx
	mov ebx, [cursor_x]
	add eax, ebx ; add x cordinate to that
	mov ebx, 0x2
	mul ebx
	add eax, [screen_address]
	push eax ;so we dont loos all that work

	mov dx, [eax]
	and cx, 0x00FF ; clear the first bits so we dont mangle the or operation
	or cx, dx

	pop eax
	mov word [eax], cx
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
