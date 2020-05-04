 ;************************************** read_disk_sectors.asm **************************************
read_disk_sectors: 		; Number of sectors to read should be stored in DI 
; The sectors should be loaded at the address starting at [disk_read_segment:disk_read_offset]
	pusha	;save the current state of all registers (GPR) by pushing their current values on the stack
	add di,[lba_sector]		; add [lba_sector], which is initially 1, to value already in di so that di has the 						; last sector to be read
							; sector 0 has the MBR
	mov ax,[disk_read_segment]	; move [disk_read_segment] to ax, function 0x2 expects address to read to in es:bx
	mov es,ax 					; move ax value to es as it cannot be set directly
	add bx,[disk_read_offset]	; store offset in bx
	mov dl,[boot_drive]			; fn 0x2 expects dl to have boot device number
	.read_sector_loop:

	call lba_2_chs				; convert to CHS to update [Cylinder],[Sector], and [Head]
	mov ah, 0x2  				; move function number in ah
	mov al,0x1 					; al has the number of sectors to be read per iteration
	mov cx,[Cylinder] 			; store [Cylinder] in cx
	shl cx,0x8 					; shift cx value 8 bits to left to store sector in the lower 6 bits later
	or cx,[Sector]				; store [Sector] into lower 6 bits
	mov dh,[Head] 				; store number of heads into dh
	int 0x13 					; issue interrupt 0x13
	jc .read_disk_error 		; check if the carry flag is set, jump to print error and hang
	mov si,dot 					; else print a dot declaring successful sector read
	call bios_print 			; call bios_print to print the msg in si
	inc word [lba_sector]    	; increment word [lba_sector] to read the next sector
	add bx,0x200			; increment bx by sector size (0x200 = 512) to go to the next adjacent memory location
	cmp word[lba_sector],di ; check if the last sector is reached 
	jl .read_sector_loop	; if still less than, hump to loop again
	jmp .finish				; else jmp to finish
	.read_disk_error: 	
	mov si, dot 			; move dot in si to be read
	call bios_print 		; call bios_print to print what is in si
	mov si,disk_error_msg 	; move msg in si to be printed
	call bios_print
	jmp hang 				; jump to hang
	.finish:
	popa
	ret
