[BITS 32]

[GLOBAL printf]

[EXTERN to_hex]
[EXTERN put_string]
[EXTERN put_serial]
[EXTERN put_char]
[EXTERN set_cursor]
[EXTERN cursor_y]



e dd 'END',0
;int printf(const char *format, ...)
;[ebp+0x04] => *format
;[ebp-0x04] => number of operands (...)
;[ebp-0x05] => index in operand check of postfixes
printf:
	push ebp
	mov ebp, esp
	sub esp, 5
	;-----------
	mov dword [ebp-0x04], 0				;set the number of known operands to 0
	mov esi, [ebp+0x8]									;set esi to the pointer to the *format string
	;mov [ebp-0x04], eax									;the count of how many operands

	.loop_char:
		mov dl, [esi]
		and edx, 0x000000FF							;extra because edx may have junk...

		cmp dl, 0x00
		je .end
		cmp dl, '%'
		je .operand
		cmp dl, '\'
		je .escape
		push edx
		call put_char
		inc esi
		jmp .loop_char

	.operand:
		inc esi
		inc dword [ebp-0x04]								;increment the operand index
		mov dl, [esi]
		cmp dl, 's'
		je .op_string
		cmp dl, 'X'
		je .op_up_hex
		cmp dl, 'x'
		je .op_up_hex

		.operand_end:
		inc esi
		jmp .loop_char

		.op_string:
			mov eax, [ebp-0x04]								;get which operand this is from the variable
			mov ebx, 0x04											;multiply it by 4 cause each operand is a dword
			mul ebx
			add eax, 0x08											;offset by the variables at the start
			add eax, ebp											;then then the location of the base
			mov eax, [eax]										;and now we have the pointer to the string
			call put_string
			jmp .operand_end

		.op_up_hex:
			mov eax, [ebp-0x04]								;get which operand this is from the variable
			mov ebx, 0x04											;multiply it by 4 cause each operand is a dword
			mul ebx
			add eax, 0x08											;offset by the variables at the start
			add eax, ebp											;then then the location of the base
			mov eax, [eax]										;and now we have the pointer to the number
			call to_hex
			call put_string
			jmp .operand_end

	.escape:
		inc esi
		mov dl, [esi]
		and edx, 0x000000FF							;extra because edx may have junk...
		cmp dl, 'n'
		je .escape_nl
		cmp dl, '\'
		je .escape_backslash
		jmp .escape_end

		.escape_nl:
			call newline
			jmp .escape_end

		.escape_backslash:
			call put_char
			jmp .escape_end

		.escape_end:
		inc esi
		jmp .loop_char

	.end:
	;-----------
	mov esp, ebp
  pop ebp
	mov eax, 0													;return value. TODO The number of bytes written
  ret 5

operand_postfixes dd 'cdieEfgGosuxXpn',0; all the valid operand postfixes

newline:
	push ebp
	mov ebp, esp
	sub esp, 4
	push eax

	mov eax, [cursor_y]
	inc al
	call set_cursor

	pop eax
	mov esp, ebp
  pop ebp
	mov eax, 0
	ret
