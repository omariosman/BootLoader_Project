 ;************************************** read_disk_sectors.asm **************************************
read_disk_sectors: 
	pusha
	add di,[lba_sector]
	mov ax,[disk_read_segment]
	mov es,ax
	add bx,[disk_read_offset]
	mov dl,[boot_drive]
	.read_sector_loop:
	call lba_2_chs
	mov ah, 0x2
	mov al,0x1
	mov cx,[Cylinder]
	shl cx,0x8
	or cx,[Sector]
	mov dh,[Head]
	int 0x13
	jc .read_disk_error
	mov si,dot
	call bios_print
	inc word [lba_sector]    
	add bx,0x200
	cmp word[lba_sector],di
	jl .read_sector_loop
	jmp .finish
	.read_disk_error:
	mov si,disk_error_msg
	call bios_print
	jmp hang
	.finish:
	popa
	ret
