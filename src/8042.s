[BITS 32]

[GLOBAL init_8042]
[GLOBAL i8042_getchar]
[EXTERN put_string]
[EXTERN put_serial]
[EXTERN idt_set_gate]
[GLOBAL i8042_getScancode]
[GLOBAL i8042_Handler]

%define DATA 0x60
%define STATUS 0x64
%define WRITE 0x64

DualPS2 db 0x0

init_8042_msg db '[8042] ',0

i8042_getScancode:
	pushad
	.nothing:
		in al, DATA
		cmp al, 0xFA
	jne .nothing
	in al, DATA
	mov ah, al
	in al, DATA

	cmp al, 0
	je .nothing			;cause we got a null byte
	popad
	ret

i8042_getchar:

	ret

i8042_Handler:
	cli
	pushad

	mov eax, init_8042_msg
	call put_serial
	mov eax, 0x12345678
	mov ebx, 0xABCDEF1
	mov ecx, 0xA1B2C3D4

	call i8042_getScancode

	mov al, 0x20
	out 0x20, al								  ; Send the EOI to the PIC

	pushad
	cli
	hlt
	iretd

i8042_set_irq:
	;8042 Keyboard
	mov eax, 0x21	;8042
	mov ebx, i8042_Handler	;ps2 1
	mov ecx, 0x0008
	mov edx, 0x8E
	call idt_set_gate

	mov eax, 0
	;;;; Clear the mask from the pic so that interupts are passed through
	in al, 0x21	;read from pic 1 data
	mov ah, 0b11111101	;clear bit 2
	and al, ah			;clear bit
	out 0x21, al			;output new mask

	ret

init_8042:
	pushad
	mov eax, init_8042_msg
	call put_string

	mov al, 0xAD	;Disable 1
	out WRITE, al

	mov al, 0xA7	;Disable 2
	out WRITE, al

	in al, DATA		;flush output buffer
	in al, DATA		;flush output buffer
	in al, DATA		;flush output buffer
	in al, DATA		;flush output buffer
	in al, DATA		;flush output buffer
	in al, DATA		;flush output buffer
	in al, DATA		;flush output buffer
	in al, DATA		;flush output buffer
	in al, DATA		;flush output buffer
	in al, DATA		;flush output buffer
	in al, DATA		;flush output buffer
	in al, DATA		;flush output buffer
	in al, DATA		;flush output buffer
	in al, DATA		;flush output buffer
	in al, DATA		;flush output buffer
	in al, DATA		;flush output buffer

	mov al, 0x20		;controller config byte
	out WRITE, al
	in al, DATA			;response byte
	mov ah, 0b10111100		;clear bits 6, 1, 0
	and al, ah					;and contents into al

	mov ah, al
	push ax		;save so we dont botch it

	mov al, 0x60		;write controller config byte
	out WRITE, al
	pop ax				;and get al back with the stuff so we can write it there
	out DATA, al

	mov al, ah
	mov ah, 0b00100000		;test bit 5
	and ah, al					;and contents into ah
	shr ah, 5
	cmp ah, 1
	jne .notDual
		mov byte [DualPS2], 0x1		;set dual ps2 to true
	.notDual:

	mov al, 0xAA
	out WRITE, al

	.statloop:	;loop untill we know if output buffer is full
		in al, STATUS
		mov ah, 0x01		;bit one
		and al, ah				;check if bit one set
		cmp al, 1
	jne .statloop		;loop if the bit is not set

	in al, DATA
	cmp al, 0x55
	je .CST
		popad
		mov eax, 1		;error code
		ret				;nope
	.CST:

	mov al, [DualPS2]
	cmp al, 1
	je .Checked
	;Do something here to check if dual PS2 controller
	.Checked:
	;Do i need to disable dual again??

	mov al, 0xAB		;test controller 1
	out WRITE, al

	.statloop1:	;loop untill we know if output buffer is full
		in al, STATUS
		mov ah, 0x01		;bit one
		and al, ah				;check if bit one set
		cmp al, 1
	jne .statloop1		;loop if the bit is not set

	in al, DATA
	cmp al, 0
	je .PS1T
		popad
		mov eax, 1		;error code
		ret
	.PS1T:

	mov al, 0xAE			;Enable PS2 1
	out WRITE, al

	mov al, 0x20			;read controler config
	out WRITE, al
	in al, STATUS
	mov ah, 0x1				;enable first bit for irq's...
	or al, ah
	mov ah, al
	push ax
	mov al, 0x60			;write to status register
	out WRITE, al
	pop ax
	out DATA, al			;write the new bit...

	mov al, 0xFF	;reset device
	out DATA, al

	.statloop2:	;loop untill we know if output buffer is full
		in al, STATUS
		mov ah, 0x01		;bit one
		and al, ah				;check if bit one set
		cmp al, 1
	jne .statloop2		;loop if the bit is not set

	mov eax, 0
	in al, DATA		;dummy vaule???
	in al, DATA
	cmp al, 0xFA		;check for good code
	je .gReset
		popad
		mov eax, 1		;error code
		ret
	.gReset:

;	call i8042_set_irq

	in al, DATA
	mov al, 0xF3
	out DATA, al
	.loop:
		in al, DATA
		cmp al, 0xFA	;get confirmation
	jne .loop
	mov al,  0b00010011
	out DATA, al
	in al, DATA
	in al, DATA
	in al, DATA
	in al, DATA
	in al, DATA
	in al, DATA
	in al, DATA
	in al, DATA
	in al, DATA
	in al, DATA


	popad
	mov eax, 0			;success!
	ret
