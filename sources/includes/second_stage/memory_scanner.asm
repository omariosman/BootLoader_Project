%define MEM_REGIONS_SEGMENT         0x2000
%define PTR_MEM_REGIONS_COUNT       0x1000
%define PTR_MEM_REGIONS_TABLE       0x1018
%define MEM_MAGIC_NUMBER            0x0534D4150                
    memory_scanner:
		pusha        ; Pushing all general register to store them on the stack as they are
		mov ax,MEM_REGIONS_SEGMENT ; Set ES to 0x2000 to store the memory regions data in the third segment of our memory
		mov es,ax
		xor ebx,ebx ; xorring ebx to make it zero to start counting the memory regions scanned as this is the counter and will be incremented by the               
		mov [es:PTR_MEM_REGIONS_COUNT],word 0x0 ; Use the word at address 0x2000:0x0000 as a counter to count memory regions
		mov di, PTR_MEM_REGIONS_TABLE ;  DI should point to address 0x18 which is equivalen to 24 in order to be 24-bytes aligned as we will store the memory       regions                            ;data and this will be store in the form of 24 bytes as we assigned as the value of ECXe
		.memory_scanner_loop: ; This is the scanning loop to scan the memory regions
		mov edx,MEM_MAGIC_NUMBER ; This function 0xe820 int 0x15 expects to have the value of the magic number "SMAP" stored in EDX
		mov word [es:di+20], 0x1 ; The function 0xe820 int 0x15 expects this 
		mov eax, 0xE820 ; we will use interrupt 0x15 funtion 0xe820 which reads memoryregions and to do this it is expected to have the funcion value 0xe820 in EAX 
		mov ecx,0x18 ; we store in ECX 0X18 WHICH  IS E24 which is the size of the memory that we will use to store the memory regions data
		int 0x15
		jc .memory_scan_failed ; Checking the carry flag, if it is not set then no error happened, otherwise jumping to memory_scan_failed if it is set
		cmp eax,MEM_MAGIC_NUMBER ; cking if If eax is equal to the magic number then everything is okay as thissss is the success ouptut of func 0xe820 of int 0X1S
		jnz .memory_scan_failed ; Else something wrong happened so we need to exit with error message
		add di,0x18 ; making di point to the next 24-bytes to store the next memory region datache
		inc word [es:PTR_MEM_REGIONS_COUNT] ; Increment the memory regions counter by one as you read a region
		cmp ebx,0x0 ; Checking the value of EBX as if it is equal zero then the memory regions are finished and there is no more to scan so exit the scanning loop
		jne .memory_scanner_loop ; continue scanning the memory If not finished
		jmp .finish_memory_scan ; jumping to finish if we are done and no errors were enccountered
		.memory_scan_failed:    ;Entering this means that an error was encountered while scanning the memory
            mov si,memory_scan_failed_msg		
            call bios_print	
            jmp hang
		.finish_memory_scan:
            		popa           ; if everything is done then we should pop up all general regsiters from the stack          
          		  ret              ; returning from the function memory_scanner 

    print_memory_regions:           ; After scanning the memory we chould print its regions
            pusha
            mov ax,MEM_REGIONS_SEGMENT                  ; Set ES to 0x0000 to start from first segment
            mov es,ax       
            xor edi,edi
            mov di,word [es:PTR_MEM_REGIONS_COUNT]
            call bios_print_hexa
            mov si,newline
            call bios_print
            mov ecx,[es:PTR_MEM_REGIONS_COUNT]
            mov si,0x1018 
            .print_memory_regions_loop:
                mov edi,dword [es:si+4]
                call bios_print_hexa_with_prefix
                mov edi,dword [es:si]
                call bios_print_hexa
                push si
                mov si,double_space
                call bios_print
                pop si

                mov edi,dword [es:si+12]
                call bios_print_hexa_with_prefix
                mov edi,dword [es:si+8]
                call bios_print_hexa

                push si
                mov si,double_space
                call bios_print
                pop si

                mov edi,dword [es:si+16]
                call bios_print_hexa_with_prefix


                push si
                mov si,newline
                call bios_print
                pop si
                add si,0x18

                dec ecx
                cmp ecx,0x0
                jne .print_memory_regions_loop
            popa
            ret
