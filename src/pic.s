[BITS 32]

[GLOBAL init_pic]

%define MASTERC	0x0020
%define MASTERD	0x0021
%define SLAVEC		0x00A0
%define SLAVED		0x00A1

[EXTERN put_string]

init_pic_msg db	'[PIC]    Initalising: ',0
init_pic_done db 'Done!\n',0

pic_wait:
	push eax
	mov eax, 0xF00000
	.pic_wait:
	nop
	nop
	dec eax
	cmp eax, 0
	jnz .pic_wait
	pop eax
	ret


init_pic:
	mov eax, init_pic_msg
	call put_string

	mov eax, 0
	in al, MASTERD		;mask
	push ax				;master mask
	in al, SLAVED			;mask
	push ax				;slave mask

	mov al, 0x11			;init command
	out MASTERC, al
	call pic_wait			;TODO create an io_wait command of the timer....
	out SLAVEC, al
	call pic_wait
	mov eax, 0x20		;master offset
	out MASTERD, eax
	call pic_wait
	mov eax, 0x28		;slave offset
	out SLAVED, eax
	call pic_wait
	mov al, 4
	out MASTERD, al
	call pic_wait
	mov al, 2
	out SLAVED, al
	call pic_wait

	mov al, 0x01
	out MASTERD, al
	call pic_wait
	out SLAVED, al
	call pic_wait

	pop ax			;slave mask
	out SLAVED, al
	pop ax			;master mask
	out MASTERD, al

	mov eax, init_pic_done
	call put_string

	ret
