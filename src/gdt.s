[BITS 32]

[GLOBAL init_gdt]

[EXTERN put_string]

%define SIZEOFGDT 8*8

align 32
gdt 	times SIZEOFGDT	db 0x00
gdtr dw 0
		dd 0		;limit, base

kernel_tss times 0x68 db 0x00 	;tss structure is 0x68 long

gdt_init_msg db '[GDT]    Initalising: ',0
gdt_init_msg_done db 'Done!\n',0

load_tss:

	mov ax, 0x28	;tss
	ltr ax			;load the tss
	ret

init_gdt:
	push eax
	push ebx
	push ecx
	push edx
	mov eax, gdt_init_msg
	call put_string
	cli			;disable interupts

	mov eax, gdt
	mov [gdtr+2], eax		;mov the gdt address to 2bytes in
	mov ax, SIZEOFGDT
	mov [gdtr], ax

	call fill_gdt

	lgdt [gdtr]
	jmp 0x08:.rlcs
	.rlcs:
	mov ax, 0x10
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax

	call load_tss

	mov eax, gdt_init_msg_done
	call put_string

	pop edx
	pop ecx
	pop ebx
	pop eax
	ret

fill_gdt:
	mov eax, 0
	mov ebx, 0
	mov ecx, 0
	mov edx, 0
	call fill_gdt_sector

	mov eax, 0x0		;linear address from 0 - above the kernel
	mov ebx, 0x400			;400 * 4k Pages = 0 - 0x400000 or 4MB(1 page table linear) TODO use the 'end' located in link.ld to calculate the size of the kernel
	mov ecx, 0x0
	or ecx, 0x9C			;data dpl0
	mov edx, 1				;second
	call fill_gdt_sector

	mov eax, 0x0		;linear address up to 0xc8000
	mov ebx, 0x400			;400 * 4k Pages = 0 - 0x400000 or 4MB(1 page table linear)
	mov ecx, 0x0
	or ecx, 0x92				;data dpl0
	mov edx, 2
	call fill_gdt_sector

	mov eax, 0x04000000			;user code from 4MB - 1024MB
	mov ebx, 0xf00000					;
	mov ecx, 0x0
	or ecx, 0xFE				;code dpl3
	mov edx, 3
	call fill_gdt_sector

	mov eax, 0x04000000			;user data from 4MB - 1024MB
	mov ebx, 0xf00000					;
	mov ecx, 0x0
	or ecx, 0xF2				;data dpl3
	mov edx, 4
	call fill_gdt_sector

	mov eax, kernel_tss			;user data from 4MB - 1024MB
	mov ebx, 0x1					;less than 4k in size
	mov ecx, 0x0
	or ecx, 0x89				;TSS
	mov edx, 5
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
