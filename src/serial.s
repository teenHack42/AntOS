[BITS 32]
[GLOBAL init_serial]
[GLOBAL is_transmit_empty]
[GLOBAL write_serial]
[GLOBAL read_serial]
[GLOBAL put_serial]

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

; put_serial: print a null terminated string to screen at current cursor
;				eax - pointer to the start of a null terminated string
;	destroys: ebx
put_serial:
	cmp byte [eax], 0 		; check if it is an end of sting byte and jump to the end if it is
	je _end_of_string
	mov ebx, [eax]			; move the character from memory into ebx
	push eax				;save eax so we dont loose the pointer of the string
	push bx				;send the character to the function put_char
	call write_serial
	pop eax				;get the pointer from above back because put_char destoryed eax
	cmp bx, '\n' 				;we need to skip the n in \n so we dont print it....
	jne _not_newline
	inc eax					;increment the pointer a second time(or first whatever but 2x...)
	_not_newline:
	inc eax					;increment the pntr to the next character
	loop put_serial			;loop back until we hit a 0 character (end of string)
	_end_of_string:
	ret

read_serial:
	push ebx
	push ecx

	.loop_tempty:
	call serial_received
	pop bx ;value from query
	cmp bx, 0
	je .loop_tempty ;loop untill buffer is empty

	mov dx, COM1
	in al, dx

	pop ecx
	pop ebx
	pop edx ;eip
	push ax; return value
	push edx	;eip
	ret

write_serial:
	mov edx, 0
	mov eax, 0
	pop edx ; eip
	pop ax	;char
	push edx ;eip
	push ebx
	push ecx

	cmp ax, '\n'
	jne .not_new_line_serial
	;It is a new line
	mov al, 0x0A		;New line charicter from ascii
	.not_new_line_serial:

	push ax 			;cause itll get mangled

	.loop_tempty:
	call is_transmit_empty
	pop bx ;value from query
	cmp bx, 0
	je .loop_tempty ;loop untill buffer is empty

	pop ax ;to un mangle it
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

	mov dx, COM1 + 1
	mov al, 0x00
	out dx, al
	mov dx, COM1 + 3
	mov al, 0x80
	out dx, al
	mov dx, COM1 + 0
	mov al, 0x03
	out dx, al
	mov dx, COM1 + 1
	mov al, 0x00
	out dx, al
	mov dx, COM1 + 3
	mov al, 0x9
	out dx, al
	mov dx, COM1 + 2
	mov al, 0xC7
	out dx, al
	mov dx, COM1 + 4
	mov al, 0x0B
	out dx, al
	pop eax
	pop edx
	ret
