      ;*********************************** bios_print.asm *******************************
bios_print: ; a routine with a loop to print character by character
	pusha  ;pushing all the registers on the stack 
	.print_loop:  ;loop  label
	xor ax, ax   ;make sure that ax has no data 
	lodsb    ;load byte in si resgister 
              ;increment the adress by one
              ; si will be pointed to next character
	or al, al   ; load character in al
                 ;if al = 0, there will be zero flag

	jz .done  ;a jump will go to "done" and exit loop
             ; else,no zero flag, it will print the stored char
	mov ah, 0x0E  ;move to INT 0x10 
	int 0x10   ;print character in al
	jmp .print_loop  ;a loop to print next character
	.done:      ;ending lood label
	popa             ;pop the registers in reverse order 
	ret               
