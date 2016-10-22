[BITS 32]

[GLOBAL stack_dump]

[EXTERN to_hex]
[EXTERN put_string]
[EXTERN put_char]


; -------Dont Call any of this cause it dont work-----


stack_dump:
	push ebp
	mov ebp, esp
	mov ebx, ebp
	call dump_hex
	pop ebp
	ret ; note that this is not going to work, but it should be here for completion.

dump_hex:
	mov ebx, ebp
	.loop:
	mov eax, [ebx]
	call to_hex
	call put_string
	mov ax, ' '
	call put_char
	sub ebx, 4
	jmp .loop
	ret
