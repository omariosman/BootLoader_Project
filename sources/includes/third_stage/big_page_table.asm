;This function allocates physical frame to the page table by putting zeros in the entries
build_page_table2:
pushaq

;address is in rcx
mov r8, 0x200 ;512
looping:

mov qword[rcx], 0
add rcx, 0x8 ;advance pointer by 1 byte
dec r8 ;decrement one from counter
cmp r8, 0
je my_return
jmp looping

my_return:

popaq
ret

;current_memory_address resq 1

loop_over_mem_regions:

;push all registers before going into the fucniton
pushaq
mov r8, 0x21000 ;effective addr of mem regions

mov r9, 0x8 ;count of regions
;Multiply r9 by 24
;R10 = r9 * 24 ;the stopping address of mem regions
mov r12, 0x18 ;r12 = 24
mov rax, r9 ;rax = count of mem regions
mul r12
mov r10, rax ;r10 = stopping address of loop
add r10, 0x21000

add r8, 0x18 ;add 24 bytes on r8 to get the range of the 1st entry

check_type_loop:

;This loops over all the memory to check if this address iwthing the range of type 1 or not
mov r9, qword[r8] ;Base Address
add r8, 0x8 ;move r8 to point to the length
mov r11, qword[r8] ;Length

add r11, r9
 

 ;r9 < address < r11
;Base address < physical frame < base address + length

;Now you have the boundaries in r9 and r11
;and the physical address let’s say in rbx
cmp r14, r9
jg second_compare
jl edit_first
second_compare:
cmp r14, r11 ;flag set
jng within_range
    jmp edit_first

edit_first:
add r8, 0x10 ;add 16 bytes to make the pointer points to the start of the next entry
    cmp r8, r10
jl check_type_loop
    jmp make_flag_0
within_range:

;let’s check the type here
add r8, 0x8
mov r9d, dword[r8]
cmp r9, 0x1 ;if type 1
je make_flag_1 ;type 1 confirm
jmp make_flag_0
make_flag_1:
mov byte[flag], 0x1
   
jmp return
make_flag_0:
mov byte[flag], 0x0
return:


;restore all the registers to get out fro m the function
popaq
ret




;This is where our page table starts

start_here:


;Loop to construct page table
mov rbx, 0x0 ;initialize last_physical
mov rcx, 0x100000 ;lsdt physical of page table levels
add rcx, 0x1000 ;+4k

mov r8, 0x0
loop_construct_page_table:

;mov rdi, r8
;call video_print_hexa
;mov rsi, newline
;call video_print
call page_walk

  add r8, 0x1000
    mov r9, 0x140000000;0x10019FC00
    cmp r8, r9
    jl loop_construct_page_table
    mov rdi, 0x100000
    mov cr3, rdi
    ret


;############################################################################



;expect r8 has v-address
;rbx = last physical (initialized to 0x0)

;page walk function that takes a virtual adddress and gives you a physical frame in the pte eventually

;it enters the page walk only once
page_walk:

mov r9, r8 ;assume that we have virtual address in r8

and r9, 0xFFF ;r9 = offset

mov r10, r8
shl r10, 0x2B ;43 r10 = lowest 9 bits
shr r10, 0x37 ;55 shift 12 bits

mov r11, r8
shl r11, 0x22; 34 ;r11 = second lowest 9 bits
shr r11, 0x37

mov r12, r8
shl r12, 0x19; 25; 0x7FC0000000 ;r12 = second highest 9 bits
shr r12, 0x37

mov r13, r8
shl r13, 0x10 ;r13 = highest 9 bits
shr r13, 0x37

;^^^^^^^^^^^^^

mov r15, 0x100000 ;starting of the table
shl r13, 3 ;multiply by 8
add r13, r15 ;address of an entry in PML4
cmp qword[r13], 0 ;null entry
je allocate1
jmp skip1


allocate1:
mov rsi, allocate1_msg
call video_print

mov r14, rcx ;last physical of the page table

;call loop_over_mem_regions ;send physical address






;cmp byte[flag], 0x1
je approve_allocate1
jmp adjust_then_call1

adjust_then_call1:
add rcx, 0x1000 ;add 4k on last phys
    mov r14, rcx
call loop_over_mem_regions  
cmp byte[flag], 0x1
je approve_allocate1
jmp adjust_then_call1
approve_allocate1:


    call build_page_table2

or rcx, 0x3 ;present and R/W bits 011b
mov [r13], rcx ;mov last physical into the entry
;mov [current_memory_address], rcx ;update last_page_physical
add rcx, 0x1000 ;increment by 4k last phys
;mov rdi, 0x100000
;mov cr3, rdi
skip1:

shl r12, 3 ;mult 8
add r12, [r13] ;[r13] is the starting address of this page table level
cmp qword[r12], 0
je allocate2
jmp skip2

allocate2:
mov rsi, allocate2_msg
call video_print

mov r14, rcx
;call loop_over_mem_regions ;send physical address
;if type 1 or not
;if rax = 1 it is type 1
;else if rax = 0, it is not type 1


;cmp byte[flag], 0x1
je approve_allocate2
jmp adjust_then_call2

adjust_then_call2:
add rcx, 0x1000 ;add 4k on last phys
    mov r14, rcx
call loop_over_mem_regions  
cmp byte[flag], 0x1
je approve_allocate2
jmp adjust_then_call2
approve_allocate2:
    call build_page_table2
or rcx, 0x3 ;present and R/W bits 011b
mov [r12], rcx ;mov last physical into the entry
;mov [current_memory_address], rcx ;update last_page_physical
add rcx, 0x1000 ;increment by 4k last phys
;mov rdi, 0x100000
;mov cr3, rdi
skip2:
shl r11, 3
add r11, [r12]
cmp qword[r11], 0
je allocate3
jmp skip3

allocate3:
mov rsi, allocate3_msg
call video_print
;Check Bitmap
;call extract_bit
;check on the address
;call bitmap and send index
mov r14, rcx
call loop_over_mem_regions ;send physical address
;if type 1 or not
;if rax = 0 it is type 1
;else if rax = 1, it is not type 1

cmp byte[flag], 0x1
je approve_allocate3
jmp adjust_then_call3

adjust_then_call3:
    add rcx, 0x1000 ;add 4k on last phys
    mov r14, rcx
call loop_over_mem_regions  
cmp byte[flag], 0x1
je approve_allocate3
jmp adjust_then_call3

approve_allocate3:
       
    call build_page_table2
or rcx, 0x3 ;present and R/W bits 011b
mov [r11], rcx ;mov last physical into the entry
;mov [current_memory_address], rcx ;update last_page_physical
add rcx, 0x1000 ;increment by 4k last phys
;mov rdi, 0x100000
;mov cr3, rdi
skip3:
mov rsi, dot
;call video_print
shl r10, 3
add r10, [r11]
cmp qword[r10], 0
je allocate4
jmp skip4

allocate4:
mov rsi, pte_msg
call video_print

mov r14, rbx
cmp r14, 0x200000
jl approve_allocate4
;call loop_over_mem_regions ;send physical address


;cmp byte[flag], 0x1

je approve_allocate4
jmp adjust_then_call4

adjust_then_call4:
 
add rbx, 0x1000 ;add 4k on last phys
    mov r14, rbx
call loop_over_mem_regions  
cmp byte[flag], 0x1
je approve_allocate4
jmp adjust_then_call4
approve_allocate4:
    ;shl rbx, 0xC ;shift by 12 bits
    ;or rbx, r9 ;oring with offset
   
mov [r10], rbx ;mov last physical into the entry
;mov [current_memory_address], rbx ;update last_page_physical
add rbx, 0x1000 ;increment by 4k last phys
;mov rdi, 0x100000
;mov cr3, rdi
skip4:
;mov rsi, hello_world_str
;call video_print
ret


;##############################
;TESTER

tester:

pushaq
mov rbx, 0x10019FC00 ;the last physical address in the memory
mov rax, r15 ; last physical address of the page table place in memory
add r15, 0x100 ;add 4k
test:
mov byte[rax], 0x5 ; write any value in current address say 5
mov cl,byte[rax] ; read the value in the current address into cl
cmp cl, byte[rax] ;compare what we read with what we wrote

jne error_msg
;mov rsi, rax ;move the address to rsi to print it
;call video_print ;print on the screen

inc rax ; move to next byte
cmp rax, rbx ; check if size of mem is reached
jg out
jmp test

error_msg:
jmp out

out:
popaq
ret


