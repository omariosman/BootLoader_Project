;************************************** get_key_stroke.asm **************************************      
get_key_stroke: 
	pusha       ;pushing all the registers on the stack 
	mov ah,0x0 ;stop everything until there is an input from the keyboard
	int 0x16   ;start"keyboard interrupt"
	popa       ;pop the registers in reverse order 
	ret
