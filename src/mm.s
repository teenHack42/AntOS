[BITS 32]

[GLOBAL init_mm]
[GLOBAL memset]

[EXTERN put_string]
[EXTERN to_hex]
[EXTERN newline]

[EXTERN end]
[EXTERN code]

init_msg dd '[MM]     Initalising: ',0
k_size_str dd '[MM] Kernel Size: ',0


init_mm:
	push ebp							; set up stack frame
	mov	ebp, esp
	sub esp, 0						;no local variables... yet. this is not nescessary but im learning

	mov eax, init_msg
	call put_string

	mov eax, newline
	call put_string

	mov eax, k_size_str
	call put_string
	mov eax, end		;find the size of the kernel in bytes. end of Kernel
	sub eax, code		;minus the start of kernel
	call to_hex
	call put_string

	mov esp, ebp				; takedown stack frame
  pop ebp							; same as "leave" op

	mov eax,0       ;  normal, no error, return value
	ret 0

;void *memset(void *str[8], int c[12], size_t n[16])
memset:
	push ebp							; set up stack frame
	mov	ebp, esp
	sub esp, 0						;no local variables... yet. this is not nescessary but im learning

	mov edi, [ebp+8]			;pointer to the start of the memory we want to set
	mov al, [ebp+12]			;character
	mov ecx, [ebp+16]			;length or size
	cld										;so none of the direcgion flags effect rep(zf)
	rep stosb							;repeat(mov edi, al; inc edi)

	mov eax, [ebp+12]			;return value(pointer to the memory)

	mov esp, ebp				; takedown stack frame
  pop ebp							; same as "leave" op

	;mov eax,0       ;  normal, no error, return value
	ret 0									;tell ret how many local variables we had
