;************************************** detect_boot_disk.asm **************************************      
detect_boot_disk:
	pusha
	mov si,fault_msg 
	xor ax,ax
	int 13h 
	jc .exit_with_error
	mov si,booted_from_msg
	call bios_print
	mov [boot_drive], dl 
	cmp dl,0 
	je .floppy
	call load_boot_drive_params
	mov si,drive_boot_msg 
	jmp .finish 
	.floppy:
	mov si,floppy_boot_msg 
	jmp .finish
	.exit_with_error:
	jmp hang
	.finish:
	call bios_print 
	popa
	ret
