[BITS 32]
[GLOBAL init_serial]
[GLOBAL is_transmit_empty]
[GLOBAL write_serial]
[GLOBAL read_serial]

%define COM1 0x3F8
%define COM2 0x2F8
%define COM3 0x3E8
%define COM4 0x2E8

%define DATAREG 				0
%define INTERUPTENABLE		1
%define INTFIFO				2
%define LINECTL				3
%define MODEMCTL			4
%define LINESTATUS		5
%define MODEMSTATUS	6
%define SCRATCHREG		7

read_serial:
	push ebx
	push ecx

	.loop_tempty:
	call serial_received
	pop bx ;value from query
	cmp bx, 0
	je .loop_tempty ;loop untill buffer is empty

	hlt

	mov dx, COM1
	in al, dx

	pop ecx
	pop ebx
	pop edx ;eip
	push ax; return value
	push edx	;eip
	ret

write_serial:
	pop edx ; eip
	pop ax	;char
	push edx ;eip
	push ebx
	push ecx

	.loop_tempty:
	call is_transmit_empty
	pop bx ;value from query
	cmp bx, 0
	je .loop_tempty ;loop untill buffer is empty

	mov dx, COM1
	out dx, al

	pop ecx
	pop ebx
	ret

is_transmit_empty:
	push eax
	push edx
	mov dx, COM1 + LINESTATUS
	in al, dx
	and dx, 0x20
	pop edx
	pop eax
	pop eax ;eip
	push dx ;return value
	push eax ;eip for ret
	ret

serial_received:
	push eax
	push edx
	mov dx, COM1 + LINESTATUS
	in al, dx
	and dx, 0x01
	pop edx
	pop eax
	pop eax ;eip
	push dx ;return value
	push eax ;eip for ret
	ret

init_serial:
	push edx
	push eax

	mov dx, COM1 + INTERUPTENABLE
	mov al, 0x00
	out dx, al
	mov dx, COM1 + LINECTL
	mov al, 0x80
	out dx, al
	mov dx, COM1 + DATAREG
	mov al, 0x03
	out dx, al
	mov dx, COM1 + INTERUPTENABLE
	mov al, 0x00
	out dx, al
	mov dx, COM1 + LINECTL
	mov al, 0x03
	out dx, al
	mov dx, COM1 + INTFIFO
	mov al, 0xC7
	out dx, al
	mov dx, COM1 + MODEMCTL
	mov al, 0x0B
	out dx, al
	pop eax
	pop edx
	ret
