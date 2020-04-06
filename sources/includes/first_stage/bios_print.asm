      ;*********************************** bios_print.asm *******************************
bios_print: 
	pusha 
	.print_loop:
	xor ax, ax
	lodsb
	or al, al
	jz .done 

	mov ah, 0x0E 
	int 0x10
	jmp .print_loop
	.done:
	popa
	ret
