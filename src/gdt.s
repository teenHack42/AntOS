[BITS 32]

[GLOBAL init_gdt]

%define SIZEOFGDT 8*8

gdt 	times SIZEOFGDT	db 0x00
gdtr dw 0
		dd 0		;limit, base

init_gdt:
	cli			;disable interupts
	call fill_gdt

	mov eax, gdt
	mov [gdtr+2], eax		;mov the gdt address to 2bytes in
	mov ax, SIZEOFGDT
	mov [gdtr], ax
	lgdt [gdtr]
	hlt
	jmp 0x08:reloadCS
	reloadCS:
	hlt
	mov ax, 0x10
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax
	ret

fill_gdt:
	mov eax, 0
	mov ebx, 0
	mov ecx, 0
	mov edx, 0
	call fill_gdt_sector
	mov eax, 0x0		;linear address from 0 - above the kernel
	mov ebx, 0x200			;200 * 4k Pages = 0 - 0xc8000 TODO use the 'end' located in link.ld to calculate the size of the kernel
	mov ecx, 0x0
	or ecx, 0x9C
	mov edx, 1				;second
	call fill_gdt_sector
	mov eax, 0x0		;linear address up to 0xc8000
	mov ebx, 0x200			;200 * 4k Pages = 0 - 0xc8000
	mov ecx, 0x0
	or ecx, 0x92
	mov edx, 2
	call fill_gdt_sector
	ret

fill_gdt_sector:
	push ecx
	push eax
	push ebx

	mov eax, 0x8
	mul edx		;multiply the offset by 8
	add eax, [gdtr+2]		;add the base address of the structure
	mov edx, eax
	pop eax
	mov [edx+0], ax		;lower word of limit 0-15
	shr eax, 16			;shift the top nibble to the bottom for easy access
	mov ecx, 0x0
	or cx, 0xC0			;4K Blocks and 32 bit mode
	and ax, 0x000F	;so we dont accadently mutilate our flags
	or al, cl			;combine the top nibble
	mov [edx+6], al	;move the flags and top nibble to the structure

	pop eax
	mov [edx+2], ax	;lower word of base 0-15
	shr eax, 16			;shift the top word down for easy access
	mov [edx+4], al	;3rd byte of base 16-23
	mov [edx+7], ah ;4th byte of base 24-31

	pop eax		;access byte
	mov [edx+5], al

	ret