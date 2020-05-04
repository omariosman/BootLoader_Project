;************************************** detect_boot_disk.asm **************************************      
detect_boot_disk:			;this function checks if the disk booted from is a floppy or not, and if not
							;it calls a function to read the other disk parameters. The number of device booted ;from is expected to be stored in DL register.
	pusha				;save the current state of all registers (GPR) by pushing their current values on the stack
	mov si,fault_msg 		;move the address of the fault msg to si to be printed
	xor ax,ax				; ax takes the function number to be used by interrupt 13, and 0 for Reset Disk Drive
	int 13h					; issue interrupt 0x13 
	jc .exit_with_error	; check the carry flag, if it is set jump to .exit_with_error to print fault msg and hang
	mov si,booted_from_msg ;else move the address of the fault msg to si for printing
	call bios_print			; to print the msg
	mov [boot_drive], dl 	; move the device number stored in dl to the memory variable boot_drive 
	cmp dl,0 				
	je .floppy 				; if dl is 0, then the device is a floppy disk so jump to print that and hang
	call load_boot_drive_params	;else the device is not floppy, so its parameters must be read
	mov si,drive_boot_msg 		; store drive_boot_msg in si to be printed
	jmp .finish 				; jump to .finish to print the msg and return
	.floppy:
	mov si,floppy_boot_msg 		; store drive_boot_msg in si to be printed
	jmp .finish					; jump to .finish to print the msg and return
	.exit_with_error:
	;call bios_print				; call bios_print to the fault msg
	jmp hang					; jump to hang
	.finish:
	call bios_print 			; call bios_print to print msg stored in si
	popa			; pop back all general purpose regs to retrieve their state before calling detect_boot_disk	
	ret  			; return by poping the return address from the stack.
