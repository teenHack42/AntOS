[BITS 32]

[GLOBAL init_paging]

align 4096				;on 4k boundary
page_dir times 1024*4 db 0	;reserve directory
align 4096				;and again
kernel_table times 1024*4 db 0

paging_init_msg db '[PAGING] Initalising: ',0
paging_init_msg_done db 'Done!\n',0

init_directory:
	mov eax, 5
	mov ebx, page_dir
	.init_directory:
	mov dword [ebx], 0x00000002	;not present
	add ebx, 4		;increase by 1 entry or dword
	dec ax			;decrease our counter
	cmp ax, 0
	jnz .init_directory
	ret

enable_paging:
	mov eax, page_dir
	mov cr3, eax

	mov eax, cr0
	or eax, 0x80000000
	mov cr0, eax
	ret

init_kernel_table:
	mov eax, 0
	mov ebx, kernel_table
	.init_kernel_table:
	push eax		;save it before we kill it
	mov ecx, 0x1000
	mul ecx
	or eax, 0x3
	mov dword [ebx], eax
	add ebx, 4		;increment the pointer to the next index
	pop eax		;and bring it back
	inc eax
	cmp eax, 1024
	jne .init_kernel_table
	mov eax, kernel_table
	or ax, 0x03	;present, read/write
	mov [page_dir], eax	;and put the table in the global directory
	ret

	;example
	;	mov ecx,0x1000*184	;4K boundary of video memory
	;	or ecx, 0x03
	;	mov [kernel_table + 8], ecx	;map it to 0x2000....
	;	mov dword[0x2000], '::))'		;smily face at first address....

[EXTERN put_string]

init_paging:
	mov eax, paging_init_msg
	call put_string
	call init_directory
	call init_kernel_table
	call enable_paging
	mov eax, paging_init_msg_done
	call put_string
	ret
