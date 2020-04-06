;************************************** load_boot_drive_params.asm **************************************
load_boot_drive_params:

	pusha 
	xor di,di
	mov es,di
	mov ah,0x8 
	mov dl,[boot_drive] 
	int 0x13
	inc dh
	mov word [hpc],0x0 
	mov [hpc+1],dh
	and cx,0000000000111111b ;
	mov word [spt],cx
	popa 
	ret
