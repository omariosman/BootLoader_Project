
check_a20_gate:
	pusha             
	mov ax,0x2402
	int 0x15
	jc .error
	cmp al,0x0
	je enable_a20
	.error:
	popa         
	ret

enable_a20:
	mov ax,0x2401
	int 0x15
	jc .error
	jmp check_a20_gate
	.error:



