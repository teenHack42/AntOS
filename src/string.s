[BITS 32]

[GLOBAL memset]

memset:
	pop edi;			;return adress
	pop esi			;pointer
	pop ebx			;character
	pop eax			;length or size
	push edi			;return adress
	mov edi, esi		;save the pointer
	and ebx, 0x000000FF		;only want the char
	.memset:
	mov byte [esi], bl
	inc esi
	dec eax
	cmp eax, 0
	jnz .memset

	pop esi		;return adress
	push edi		;pointer to the string
	push esi		;return adress
	ret
