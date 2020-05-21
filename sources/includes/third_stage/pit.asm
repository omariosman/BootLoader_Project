%define PIT_DATA0       0x40
%define PIT_DATA1       0x41
%define PIT_DATA2       0x42
%define PIT_COMMAND     0x43
%define PIT_DATA0 0x40
%define PIT_COMMAND 0x43
pit_counter dq 0x0 ; to count the number of ticks issued by the pit
outer_counter dq 0x0 ;equivalent to 1000 to print the counter every 1000 ticks
handle_pit:
    ;subroutine to print the counter every 1000 interrupts
      pushaq
            continue:
            inc qword [pit_counter]       ; Increment pit_counter
            inc qword[outer_counter]; This will increment the outer_counter 
            je [outer_counter],0x3E8,print_counter ; print the counter if 1000 interrupts have been invoked 
            jl continue ;continue incrementing th counter as it didn't reach 1000
            print_counter: 
                   push qword [start_location]
                   mov qword [start_location],0   ; This should be edited to accomodate with the scorallable screen
                   pop qword [start_location]
                   mov rdi,[pit_counter]        
                   call video_print_hexa    ; Print pit_counter in hexa
                   mov outer_counter, 0x0  ;resetting the outer counter
      popaq
      ret
      
	  
configure_pit:
 pushaq
 mov rdi,32 ; pit is supposed to be configured as interrupt 32
 mov rsi, handle_pit ; we call handle_pit subroutine to act the the routine to handle the fire of interrupt from the pit
 call register_idt_handler ; calling the ISR of pit which is handle_pit routine
 mov al,00110110b ; Set PIT Command Register 00 -> Channel 0, 11 -> Write lo,hi bytes, 011 -> Mode 3, 0-> Bin
 out PIT_COMMAND,al ; 
 xor rdx,rdx ; zeroing out rdx 
 mov rcx,50; This generates 50 interrupts/second
 mov rax,1193180 ; adjusting frequency needed by the oscillator of the PIT which is a constant info
 div rcx ; RDX has the remainder of 11931280/50
 out PIT_DATA0,al 
 mov al,ah 
 out PIT_DATA0,al 
 popaq
 ret
	  
	  
	  
	

