;This is a handler that calls the other functions to complete this mission        
check_long_mode:
            pusha                           
            call check_cpuid_support       
            call check_long_mode_with_cpuid 
            popa            
            ret
;To check long mode support I need to do two things:
;1- Check that cpuid is cupported 
;2- Check that long mode is suported
        check_cpuid_support:
		pusha           ;push all registers to restore them later
		pushfd 	;push eflags into stack
		pushfd 	;another copy of eflags
		pushfd 	;3rd copy of eflags
		pop eax 	;put a copy of eflags into eax
		xor eax,0x0200000 	;xor eax (eflags) with this umber to flip number 21 in the eflags
		push eax 	;put the new changed elfags on stack
		popfd 	;put the changed eflags into eflags rregister
		pushfd 	;put the changed eflags on stack again
		pop eax 	;put the changed 
		pop ecx 	;pop the origianl eflags into ecx
		xor eax,ecx 	;xor the origianl and the changed
		and eax,0x0200000 	;and the result of xoring with this number to see if 21 bit was changed or not
		cmp eax,0x0	 ;compare the result to zero
		jne .cpuid_supported 	;if the 21st bit is not zero then it is changed then cpuid is found
		mov si,cpuid_not_supported 	;print a msg to indicate that it is not supported
		call bios_print	;print th emsg
		jmp hang	;hang until an interrupt fires
		.cpuid_supported: 
		mov si,cpuid_supported 	;print msg that it is supported
		call bios_print	;print msg
		popfd ;pop the original eflags again
		popa ;restore all regs
		ret ;return to origianl place


;To check if the long mode is supported or not, we need to check the 29st bit in the extended features reg

        check_long_mode_with_cpuid:
		pusha              ;push all regs to restore lter 
		mov eax,0x80000000 	;mov this number as the documentation states into eax to get the max. number of the functions can be invoked
		cpuid	;call cpuid 
		cmp eax,0x80000001  	;see whether the number is less than 0x8000001 or not
		jl .long_mode_not_supported ;if it is less than then the long mode is not supported
		mov eax,0x80000001 ;move this number as documentaion into eax
		cpuid ;call cpuid
		and edx,0x20000000 	;andingthe extended features into edx and check bit number 29 
		cmp edx,0 ;if it is 0 then it is not suported
		je .long_mode_not_supported  ;go to label not supported
		mov si,long_mode_supported_msg  ;prit msg indicating it is supported
		call bios_print	 ;call print
		jmp .exit_check_long_mode_with_cpuid ;terminated
		.long_mode_not_supported:	;not supported label
		mov si,long_mode_not_supported_msg  ;printing msg to indicate not supported
		call bios_print ;print msg
		jmp hang ;hang and wait interrupts
		.exit_check_long_mode_with_cpuid: ;check long mode terminate label
		popa    		;restore all regs
		ret		;return to original place
