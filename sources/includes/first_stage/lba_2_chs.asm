 ;************************************** lba_2_chs.asm **************************************
 lba_2_chs:  ; Update[Cylinder],[Head], and [Sector] by converting the value in [lba_sector] to its equivalent 				; CHS values according to these rules 
 						; [Sector] = Remainder of [lba_sector]/[spt] +1
 						; [Cylinder] = Quotient of (([lba_sector]/[spt]) / [hpc])
 						; [Head] = Remainder of (([lba_sector]/[spt]) / [hpc])
	pusha			; save the current state of all registers (GPR) by pushing their current values on the stack
	xor dx,dx 			; set dx to 0
	mov ax, [lba_sector] ; move [lba_sector] to ax
	div word [spt] 		; divide value in [dx:ax] by value already stored in word [spt] (where dx is remainder)
	inc dx				; increment remainder by 1 to get the number of sector as per rule above
	mov [Sector], dx	; store the number obtained in [Sector]
	xor dx,dx 			; set remainder to 0 again while ax has already the quotient ([lba_sector]/[spt])
	div word [hpc]		; divide value in [dx:ax] by value already stored in word [hpc] as per rule
	mov [Cylinder], ax	; move new quotient to [Cylinder]
	mov [Head], dl		; store the remainder dl (lower 8 bits of dx) to [Head] 
	popa				; retrieve the state of general purpose regs before calling lba_2_chs
	ret 				; return 
