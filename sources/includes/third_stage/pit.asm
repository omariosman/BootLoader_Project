%define PIT_DATA0       0x40
%define PIT_DATA1       0x41
%define PIT_DATA2       0x42
%define PIT_COMMAND     0x43
%define PIT_DATA0 0x40
%define PIT_COMMAND 0x43
pit_counter dq 0x0 ; ticks count record



handle_pit:
      pushaq
            mov rdi,[pit_counter]         ; Value to be printed in hexa
            push qword [start_location]
            mov qword [start_location],0
            call bios_print_hexa          ; Print pit_counter in hexa
            pop qword [start_location]
            inc qword [pit_counter]       ; Increment pit_counter
      popaq
      ret
      
	  
configure_pit:
 pushaq
 mov rdi,32 ; irq0 is expected to fire interrupt 32
 mov rsi, handle_pit ; when pit is fired, handle_pit is called
 call register_idt_handler ; Interrupt request
 mov al,00110110b ; Set PIT Command Register 00 -> Channel 0, 11 -> Write lo,hi bytes, 011 -> Mode 3, 0-> Bin
 out PIT_COMMAND,al ; 
 xor rdx,rdx ; moving zero to rdx
 mov rcx,50
 mov rax,1193180 ; adjusting frequency
 div rcx ; RDX has the remainder of 11931280/50
 out PIT_DATA0,al ; Write low byte to channel 0 data port
 mov al,ah ; moving most significant byte to al register
 out PIT_DATA0,al ; 
 popaq
 ret
	  
	  
	  
	
