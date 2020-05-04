;************************************** load_boot_drive_params.asm **************************************
load_boot_drive_params:			;a routine to read the device (boot_drive has its number) parameters, cylinder (								;not needed here), head/cylinder (update [hpc]), and sectors/track (update [spt])

	pusha 			;save the current state of all registers (GPR) by pushing their current values on the stack
	xor di,di 		; set di to 0 as function 0x8 in interrupt 0x13 requires es:di to be 0x0000:0x0000 not to have 				  ;a bug
	mov es,di 		; move value of di into es
	mov ah,0x8 		; store fn number 0x8 in ah to be used (0x8 for loading disk parameters)
	mov dl,[boot_drive] ; move value already stored in [boot_drive] to dl 
	int 0x13			; issue INT 0x13
	;jc .params_not_loaded	; check the carry flag, if it is set jump to .params_not_loaded to hang
	inc dh					; the total number of heads is stored in dh so it is incremented as heads are base 0
	mov word [hpc],0x0 		; move 0 to [hpc]
	mov [hpc+1],dh			; the lower bit of [hpc] to have number of heads
	and cx,0000000000111111b ; and cx with that number to have the lower 6 bits (sectors/track) in cx
	mov word [spt],cx		; update [spt] with the number of sectors/track
	popa 
	ret
