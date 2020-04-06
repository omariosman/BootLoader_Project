;************************************** get_key_stroke.asm **************************************      
get_key_stroke:
	pusha
	mov ah,0x0
	int 0x16
	popa 
	ret
