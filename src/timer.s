[BITS 32]

[GLOBAL system_timer_fractions]
[GLOBAL system_timer_ms]
[EXTERN IRQ0_fractions]
[EXTERN IRQ0_ms]

system_timer_fractions dd 0x0
system_timer_ms	dd 0x0

system_CountDown dd 0x0

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
