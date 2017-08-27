[BITS 32]

[GLOBAL init_mm]

[EXTERN put_string]
[EXTERN to_hex]
[EXTERN newline]

[EXTERN end]
[EXTERN code]
[EXTERN printf]

init_msg dd '[MM]     Initalising: \n',0
k_size_str dd '[MM] Kernel Size: %X\n',0


init_mm:
	push ebp							; set up stack frame
	mov	ebp, esp
	sub esp, 0						;no local variables... yet. this is not nescessary but im learning

	push init_msg
	call printf

	mov eax, end		;find the size of the kernel in bytes. end of Kernel
	sub eax, code		;minus the start of kernel
	push eax
	push k_size_str
	call printf

	mov esp, ebp				; takedown stack frame
  pop ebp							; same as "leave" op

	mov eax,0       ;  normal, no error, return value
	ret 0
