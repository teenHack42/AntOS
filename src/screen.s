[BITS 32]
[SECTION .text]
[GLOBAL clear_screen]
[GLOBAL set_character]
[GLOBAL put_char]
[GLOBAL put_string]
[GLOBAL text_attribute]
[GLOBAL set_cursor]
[GLOBAL to_hex]
[GLOBAL short_hex]

screen_address	dd	0xB8000
cursor_x 	dd	0x0
cursor_y	dd	0x0
text_attribute	db	0x07 ; default cursor text_attribute
cursor_x_max	dd	0x50 ;80 characters
cursor_y_max	dd	0x19 ;25 characters

HexChar:	db "0123456789ABCDEF", 0
HexString: dd 0x00000000, 0x0, 0x0
HexStringOut: dd 0x00000000, 0x0, 0x0
; short hex - cull leading 0(zeros) from a hex string
;			input: eax - value to pass to hex_to_char
;			ouput: eax - pointer to null terminated string
;			destroys: nothing
short_hex:
	push ebx
	push ecx
	push edx
	push edi
	push esi ;push everything we use so we dont destroy them

	call to_hex			;convert the value to a string

	mov ebx, eax				;make a copy of the address
	mov ecx, 0					;initalise the counter
	.short_hex:
	cmp byte [ebx], 0x00		;check if null termination
	je .short_end

	cmp byte [ebx], '0'		;check if 0 character
	je .count_hex
	jmp .short_end			;if its none of those then we are finished

	.count_hex:
	inc eax					;move adress up
	inc ebx					;move the other adress up
	inc cx					;inc counter
	jmp .short_hex			;go back up and check again cause we not finished
	.short_end:

	cmp cx, 0x08			;then our value is 0x0
	je .hex_zero

	and word cx,0x01		;check if its odd or even
	cmp cx, 0x01
	jne .even_end
	dec eax 				; because we want an even number of hex characters
	.even_end:

	pop esi
	pop edi
	pop edx ; and return all of the stuff we saved
	pop ecx
	pop ebx
	ret

	.hex_zero:
	sub eax, 2			; give at least 2 zeros
	jmp .even_end	;go back to the body
	ret					;to be sure

; to_hex - convert a value into a string in hex format
;			input: eax - value
;			ouput: eax - pointer to string
;			destroys: nothing
to_hex:
	push ebx
	push ecx
	push edx
	push edi
	push esi ;push everything we use so we dont destroy them

	push eax						;save the word
	mov ebx, HexChar
	mov ecx, HexString
	mov dl, 0						;init counter
	.loop_hex:
	and eax, 0x0000000F		; we only want to have the first nibble (4 bits)
	xlat							;do the offset into the table
	mov [ecx], al				;save the character from the table into the memory
	inc ecx
	pop eax						;get our word back
	shr eax, 4						; shove it along by a nibble
	push eax						;save it again
	inc dl						;count some stuff
	cmp dl, 0x8					;there are only 8 nibbles in 32bits so...
	jne .loop_hex
	mov byte [ecx], 0 			;null terminate
	pop eax 					; off so we dont have a memory leak...

	;-------------------------Reverse String------------------------------
	mov eax, HexString				;The string we are reversing
	mov esi, eax  						; esi points to start of string
	mov eax, HexStringOut			;the place the correct string is going
	add eax, 0x7						; go to the end of the string cause we are going backwards
	mov edi, eax
	mov ecx, 0x8						;string has 8 characters. count down
	reverseLoop:
	mov al, [esi] 						; load characters
	mov [edi], al						;save it into the other string
	inc esi       							; adjust pointers
	dec edi
	dec cx       							; dec loop counter
	jnz reverseLoop						;jump if not 0
	add edi, 0x9						;go back to the start of our final string
	mov byte [edi], 0x0				;null terminate it

	pop esi
	pop edi
	pop edx ; and return all of the stuff we saved
	pop ecx
	pop ebx

	mov eax, HexStringOut			;and output the address to the caller
	ret

; set_cursor: move the cursor to a desired position
;		ax - high byte - x position
;		ax - low byte - y position
;	destroys: nothing
set_cursor:
	push eax
	push ebx
	mov word bx, ax
	and bx, 0x00FF
	shr eax, 8
	mov word [cursor_x], ax
	mov word [cursor_y], bx
	pop ebx
	pop eax
	ret

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
	mov ebx, 0x2				;multiply by two because text_attribute + byte....
	mul ebx
	add eax, [screen_address]		;add base address and offset togeather to get pointer.
	push eax						 ;so we dont loose all that work

	mov bx, [text_attribute]		;get the text_attribute byte from memory
	shl bx, 8
	and cx, 0x00FF 		; clear the first bits so we dont mangle the or operation
	or cx, bx				;add the character and atribute byte togeather
	pop eax			;get our pointer back
	mov word [eax], cx	;put the character in memory as well as text_attribute byte
	ret

; clear_screen - set whole screen to defined atribute values with null bytes
;	destroys: ebx, eax
clear_screen:
	mov ebx, [screen_address]
clear_screen_loop:
	mov word [ebx], 0x0000	;wipe the address
	add dword  ebx, 0x2	;increase the address by 2
	cmp dword ebx, (0xB8000 + 0xF9E)		;check if we reached the end
	jbe clear_screen_loop
	ret
