


build_page_table:
pushaq

;address is in rcx
mov r8, 0x200 ;512
looping:
mov qword[rcx], 0
add rcx, 0x8
dec r8
cmp r8, 0
je my_return
jmp looping

my_return:
popaq
ret



;R8 point to mem regions
;Get maximum address of the mem regions
;Starting address: 0x20018
;Get count of the mem regions and multiply by 24




loop_over_mem_regions:
push r8
push r9
push r10
push r11
push r12
push r13

mov r8, 0x20000 ;effective addr of mem regions
mov r9w, word[r8] ;count of regions
;Multiply r9 by 24
;R10 = r9 * 24 ;the stopping address of mem regions
mov r12, 0x18 
mul r12
mov r10, rax 


add r8, 0x18 ;add 24 bytes on r8 to get the range of the 1st entry

check_type_loop:
mov r9, qword[r8]
add r8, 0x8 ;move r8 to point to the length 
mov r11, qword[r8]
add r11, r9


;Base address < physical frame < base address + length

;Now you have the boundaries in r9 and r11
;and the physical address let’s say in rbx
cmp r14, r9
jg second_compare
jl edit_first
second_compare:
	cmp r14, r11
	jl within_range
jg edit_first
	
edit_first:
	add r8, 0x8 ;add 8 bytes to make the pointer points to the start of the next entry 
    cmp r8, r10
	jl check_type_loop
    jmp make_rax_0 
within_range:
;let’s check the type here
add r8, 0x8
mov r9d, dword[r8]
cmp r9, 0x1 ;if type 1
je make_rax_1 ;type 1 confirm
jmp make_rax_0
make_rax_1:
	mov rax, 0x1
	jmp return
make_rax_0:
	mov rax, 0x0
return:
pop r13
pop r12
pop r11
pop r10
pop r9
pop r8
ret




start_here:

mov rsi, hello_world_str
call video_print

;Loop to construct page table
mov rbx, 0x0 ;initialize last_physical
mov rcx, 0x100000 ;lsdt physical of page table levels
mov r15, 0x0 ;initialize last_page_physical
mov r8, 0x0
loop_construct_page_table:
	call page_walk
 	add r8, 0x1000
    mov r9, 0x10019FC00
    cmp r8, r9
    jl loop_construct_page_table
    ret


	
	
	

;############################################################################



;expect r8 has v-address
;rbx = last physical (initialized to 0x0)


page_walk:
mov rsi, hello_world_str
call video_print

mov r9, r8 ;assume that we have virtual address in r8
and r9, 0xFFF ;r9 = offset

mov r10, r8
and r10, 0x1FF000 ;r10 = lowest 9 bits
shr r10, 0xc ; shift 12 bits

mov r11, r8
and r11, 0x3FE00000 ;r11 = second lowest 9 bits
shr r11, 0x15

mov r12, r8
and r12, 0x7FC0000000 ;r12 = second highest 9 bits
shr r12, 0x1E

mov r13, r8
and r13, 0xFF8000000000 ;r13 = highest 9 bits
shr r13, 0x27

;^^^^^^^^^^^^^
mov rdi, cr3
mov r15, rdi
shl r13, 3 ;multiply by 8
add r13, r15 ;address of an entry in PML4
cmp qword[r13], 0 ;null entry
je allocate1
jmp skip1

allocate1:
mov r14, rcx
call loop_over_mem_regions ;send physical address
;if type 1 or not
;if rax = 0 it is type 1
;else if rax = 1, it is not type 1


cmp rax, 0x1
je approve_allocate1
jmp adjust_then_call1

adjust_then_call1:
	add rcx, 0x1000 ;add 4k on last phys
    mov r14, rcx
	call loop_over_mem_regions  
	cmp rax, 0x1
	je approve_allocate1
	jmp adjust_then_call1
approve_allocate1:
    
    call build_page_table
	or rcx, 0x3 ;present and R/W bits 011b
	mov [r13], rcx ;mov last physical into the entry
	mov r15, rcx 		;update last_page_physical
	add rcx, 0x1000 ;increment by 4k last phys
	mov rdi, 0x100000
	mov cr3, rdi
skip1:
shl r12, 3 ;mult 8
add r12, [r13] ;[r13] is the starting address of this page table level 
cmp qword[r12], 0
je allocate2
jmp skip2

allocate2:
;check on the address
;call bitmap and send index
mov r14, rcx
call loop_over_mem_regions ;send physical address

;if type 1 or not
;if rax = 1 it is type 1
;else if rax = 0, it is not type 1


cmp rax, 0x1
je approve_allocate2
jmp adjust_then_call2

adjust_then_call2:
	add rcx, 0x1000 ;add 4k on last phys
    mov r14, rcx
	call loop_over_mem_regions  
	cmp rax, 0x1
	je approve_allocate2
	jmp adjust_then_call2
approve_allocate2:
  
    call build_page_table
	or rcx, 0x3 ;present and R/W bits 011b
	mov [r12], rcx ;mov last physical into the entry
	mov r15, rcx 		;update last_page_physical
	add rcx, 0x1000 ;increment by 4k last phys
	mov rdi, 0x100000
	mov cr3, rdi
skip2:
shl r11, 3
add r11, [r12]
cmp qword[r11], 0
je allocate3
jmp skip3

allocate3:
;check on the address
;call bitmap and send index
mov r14, rcx
call loop_over_mem_regions ;send physical address
;if type 1 or not
;if rax = 0 it is type 1
;else if rax = 1, it is not type 1


cmp rax, 0x1
je approve_allocate3
jmp adjust_then_call3

adjust_then_call3:
    add rcx, 0x1000 ;add 4k on last phys
    mov r14, rcx
	call loop_over_mem_regions  
	cmp rax, 0x1
	je approve_allocate3
	jmp adjust_then_call3
approve_allocate3:
    
    call build_page_table
	or rcx, 0x3 ;present and R/W bits 011b
	mov [r11], rcx ;mov last physical into the entry
	mov r15, rcx 		;update last_page_physical
	add rcx, 0x1000 ;increment by 4k last phys
	mov rdi, 0x100000
	mov cr3, rdi
skip3:
shl r10, 3
add r10, [r11]
cmp qword[r10], 0
je allocate4
jmp skip4

allocate4:
;check on the address
;call bitmap and send index
mov r14, rbx
call loop_over_mem_regions ;send physical address
;if type 1 or not
;if rax = 0 it is type 1
;else if rax = 1, it is not type 1


cmp rax, 0x1
je approve_allocate4
jmp adjust_then_call4

adjust_then_call4:
	add rbx, 0x1000 ;add 4k on last phys
    mov r14, rbx
	call loop_over_mem_regions  
	cmp rax, 0x1
	je approve_allocate4
	Jmp adjust_then_call4
approve_allocate4:

	mov [r10], rbx ;mov last physical into the entry
	mov r15, rbx 		;update last_page_physical
	add rbx, 0x1000 ;increment by 4k last phys
	mov rdi, 0x100000
	mov cr3, rdi
skip4:

ret







































