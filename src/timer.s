[BITS 32]

[GLOBAL system_timer_fractions]
[GLOBAL system_timer_ms]
[EXTERN IRQ0_fractions]
[EXTERN IRQ0_ms]
[GLOBAL sleep]
[GLOBAL system_sleep]
[EXTERN put_serial]
[EXTERN to_hex]

system_timer_fractions dd 0x0
system_timer_ms	dd 0x0

system_sleep dd 0x0		;ms since reset

sleep:
	pop edi
	pop eax
	push edi

	mov dword [system_sleep], 0
	.sleeploop:
	nop
	mov ebx, [system_sleep]
	cmp eax, ebx
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	jge .sleeploop
	ret

init_timer:
	push eax
	push ebx
	push ecx
	push edx

	pop edx
	pop ecx
	pop ebx
	pop eax
	ret
