[BITS 32]
[SECTION .text]

[GLOBAL ant_kernel_main]
[EXTERN end]

[EXTERN clear_screen]
[EXTERN set_character]
[EXTERN put_char]
[EXTERN put_string]
[EXTERN text_attribute]
[EXTERN set_cursor]
[EXTERN to_hex]
[EXTERN short_hex]
[EXTERN write_serial]

[EXTERN init_serial]
[EXTERN is_transmit_empty]
[EXTERN read_serial]
[EXTERN put_serial]

[EXTERN init_idt]
[EXTERN idtp]

[EXTERN init_gdt]

[EXTERN init_paging]

[EXTERN init_pic]

[EXTERN init_pit]

[EXTERN sleep]

[EXTERN fault_handler]

[EXTERN init_multiboot]

[EXTERN printf]

[EXTERN init_mm]
[EXTERN memset]

antos										dd	'AntOS\n', 0
hex											dd	'%X\n',0
sleepstr 								dd	"This string was printed after 2000 ms\n", 0


ant_kernel_main:
	mov ebx, esp	;save the base of the stack
	mov esp, 0x10F000
	push eax			;always have this first as values from grub are pushed to the stack
	call clear_screen
	push antos
	call printf

	call init_pic
	call init_idt		;Interrupts

	call init_paging		;start this early
	call init_gdt			;then this
	mov ebx, 150	;Frequency of PIT
	call init_pit

	;----------MM-----------

	call init_mm

	push 0x1000				;end to end + 4K
	push 0x42					;put this character in
	push end					;start at end
	call memset

	push dword [esp+0x04]
	push hex
	call printf

	push dword [end]
	push hex
	call printf

	;----------MM-----------


	;mov eax, 700
	;push eax
	;call sleep

	;mov eax, sleepstr
	;call put_string


	;call fault_handler

	;pop eax
	;push eax	;return the value back for consistancy
	;pushad
	;push eax	;the value to push to the C function
	;call init_multiboot
	;popad

	;call fault_handler

	.kloop:
	nop
	jmp .kloop
	hlt
