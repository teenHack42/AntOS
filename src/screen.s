[BITS 32]
[SECTION .text]
[GLOBAL clear_screen]
[GLOBAL set_character]
[GLOBAL put_char]
[GLOBAL put_string]

screen_address	dd	0xB8000
cursor_x 	dd	0x0
cursor_y	dd	0x0
colour	db	0x07 ; default cursor colour
cursor_x_max	dd	0x50 ;80 characters
cursor_y_max	dd	0x19 ;25 characters

; put_string: print a null terminated string to screen at current cursor
;				eax - pointer to the start of a null terminated string
;	destroys: ebx
put_string:
	cmp byte [eax], 0 		; check if it is an end of sting byte and jump to the end if it is
	je _end_of_string
	mov ebx, [eax]			; move the character from memory into ebx
	push eax				;save eax so we dont loose the pointer of the string
	push bx				;send the character to the function put_char
	call put_char
	pop eax				;get the pointer from above back because put_char destoryed eax
	cmp bx, '\n' 				;we need to skip the n in \n so we dont print it....
	jne _not_newline
	inc eax					;increment the pointer a second time(or first whatever but 2x...)
	_not_newline:
	inc eax					;increment the pntr to the next character
	loop put_string			;loop back until we hit a 0 character (end of string)
	_end_of_string:
	ret

; put_char: write a character to the current cursor position and advance the cursor by 1
;				stack: byte - character to print
;	destroys: eax, exc
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

; set_character: set a screen buffer character at current cursor position
;				ecx - character to be written
;	destroys: eax, ebx, ecx
set_character:
	mov eax, [cursor_y]			 ;y cordinate
	mov ebx, [cursor_x_max] 	; multiply by max line length
	mul ebx
	mov ebx, [cursor_x]
	add eax, ebx 					; add x cordinate to that
	mov ebx, 0x2				;multiply by two because attribute + byte....
	mul ebx
	add eax, [screen_address]		;add base address and offset togeather to get pointer.
	push eax						 ;so we dont loose all that work

	mov bx, [eax]		;get the attribute byte from memory
	and cx, 0x00FF 		; clear the first bits so we dont mangle the or operation
	or cx, bx				;add the character and atribute byte togeather

	pop eax			;get our pointer back
	mov word [eax], cx	;put the character in memory as well as attribute byte
	ret

; clear_screen - set whole screen to defined atribute values with null bytes
;				ax - attribute byte
;	destroys: ebx, eax
clear_screen:
	mov ebx, [screen_address]
	shl ax, 8			;shift the attribute accross and null the char bits
clear_screen_loop:
	mov word [ebx], ax	;wipe the address
	add dword  ebx, 0x2	;increase the address by 2
	cmp dword ebx, (0xB8000 + 0xF9E)		;check if we reached the end
	jbe clear_screen_loop
	ret
