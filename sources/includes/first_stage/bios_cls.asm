;************************************** bios_cls.asm **************************************      
bios_cls: ;set the video mode to clear the screen 
	pusha   ;pushing all the regirters on the stack 
	mov ah,0x0  ;intializing video mode 80x25
	mov al,0x3  
	int 0x10  ;doing interrupt 10 "video intrrupt" 
	popa  ;poping the registers in reverse order 
	ret
