;The mission of this file is to check whether the  a20 gate is enabled or not
; if it is not enabled, then we will enable it

check_a20_gate:
	pusha     ;push all regs to stack to restore later        
	mov ax,0x2402 ;function used to check whether gate is enabled or not
	int 0x15	;fire interrupt
	jc .error	;jump to error if an error happened
	cmp al,0x0	;if al = 0 then the gate is disabled
	je enable_a20  ;then i need to enable it in this case [al = 0]
	jmp .skip
        .error:
	cmp ah, 0x1
	je .keyboard_error
	cmp ah, 0x86
	je .function_not_supported
	jmp .unknown_error
	.keyboard_error:
	mov si, keyboard_controller_error_msg
	call bios_print
	jmp hang
	.function_not_supported:
	mov si, a20_function_not_supported_msg
        call bios_print
	jmp hang
	.unknown_error:
	mov si, unknown_a20_error
	call bios_print
	jmp hang
	.skip:
	mov si, a20_enabled_msg
	call bios_print 
	popa
	ret


;Enabling the gate then check again
enable_a20:
	mov ax,0x2401 ;function number into ax as the dicumentation
	int 0x15	;fire interrupt
	jc .error	;jump to error label if error happend
	jmp check_a20_gate ;check again after enabling
	.error:	
	cmp ah, 0x1
        je .keyboard_error
        cmp ah, 0x86
        je .function_not_supported
        jmp .unknown_error
        .keyboard_error:
        mov si, keyboard_controller_error_msg
        call bios_print
        jmp hang
        .function_not_supported:
        mov si, a20_function_not_supported_msg
        call bios_print
        jmp hang
        .unknown_error:
        mov si, unknown_a20_error
        call bios_print
	jmp hang

