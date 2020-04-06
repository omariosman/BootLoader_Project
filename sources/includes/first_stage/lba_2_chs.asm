 ;************************************** lba_2_chs.asm **************************************
 lba_2_chs:  
	xor dx,dx 
	mov ax, [lba_sector] 
	div word [spt] 
	inc dx
	mov [Sector], dx
	xor dx,dx 
	div word [hpc]
	mov [Cylinder], ax
	mov [Head], dl
	popa
	ret
