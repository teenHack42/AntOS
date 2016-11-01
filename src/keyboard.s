[BITS 32]

[GLOBAL init_keyboard]
[EXTERN init_8042]
[EXTERN i8042_getchar]

[EXTERN put_string]

init_keyboard_msg db '[KYBD]   Initalising: ',0
init_keyboard_done db 'Done!\n',0
init_keyboard_fail db 'FAIL!\n',0

keyboard_controller_init dd 0x0
keyboard_controller_getchar dd 0x0

init_keyboard:
	pushad
	mov eax, init_keyboard_msg
	call put_string
	mov dword [keyboard_controller_init], init_8042
	mov dword [keyboard_controller_getchar], i8042_getchar

	mov eax, [keyboard_controller_init]
	call eax
	cmp eax, 0
	jne .failed

	mov eax, init_keyboard_done
	call put_string
	popad
	ret

	.failed:
	mov eax, init_keyboard_fail
	call put_string
	popad
	ret
