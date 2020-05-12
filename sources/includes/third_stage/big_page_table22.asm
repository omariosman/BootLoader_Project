%define BITMAP_BASE_ADDRESS 0x50000 ;EFFECTIVE ADDRESS OF BITMAP
counter db 0x0
bit_extracted db 0xFF
;This function allocates physical frame to the page table by putting zeros in the entries
initialize_page_entries: ;address is in r14
pushaq  
mov r8, 0x200       ;512
looping:
mov qword[r14], 0x0
add r14, 0x8          ;advance pointer by 8 bytes
dec r8                 ;decrement one from counter
cmp r8, 0x0
je my_return
jmp looping

my_return:
popaq
ret


get_page_physical:  ;finds a physical address of type 1
                    ;if found, set bit map to 1, set flag rax to 1, and send address back in r14
                    ;else set flag to 0 and return (all addresses are already mapped).
mov r9, 0x21000        ;effective addr of mem regions
add r9, 0x60           ;(4*24) address of 4th mmemory region (that starts with 0x100000 physical address)
find_page_physical:
    mov byte[counter], 0x0  ;reset the counter
    mov r14, qword[r9]      ;base
    add r9, 0x8
    mov rbx, qword[r9]      ;length
    add rbx, r14            ;last address (limit) in this region in rbx
    add r14, 0x1000         ;physical address to check (initially 0x101000 then act as last physical address)
    check_bit:
    mov rax, r14
    mov rcx, 0xFFFF0
    div rcx
    mov rcx, rdx
    call extract_bit        ;expects bit in rdx
    cmp byte[bit_extracted], 0x0
    jne mapped_already
    jmp not_mapped_yet
mapped_already:
        add r14, 0x1000     ; advance to next physical address
        cmp r14, rbx        ; if still less than limit go check bit
        jl check_bit
        add r9, 0x10        ; advance r9 16 bytes to point to next memory region
        add r9, 0x30        ; advance r9 (2*24) bytes to point to next memory region of type
        mov rbx, counter
        inc byte[rbx]
        cmp byte[rbx], 0x2
        jng find_page_physical
        mov rax, 0x0
        jmp return
not_mapped_yet:
        mov rax,0x1         ;set flag to 1
        mov rax, r14
        mov rcx, 0xFFFF0
        div rcx
        mov rcx, rdx
        call set_bitmap     ;mark bitmap that expects address index in rcx
return:
ret

get_PTE_physical:  ;finds a physical address of type 1
                    ;if found, set bit map to 1, set flag rax to 1, and send address back in r14
                    ;else set flag to 0 and return (all addresses are already mapped).
mov r9, 0x21000        ;effective addr of mem regions
add r9, 0x18           ;(24) address of 1st memory region (that starts with 0x0000 physical address)
find_PTE_physical:
    mov byte[counter], 0x0  ;reset the counter
    mov r14, qword[r9]      ;base
    add r9, 0x8
    mov rbx, qword[r9]      ;length
    add rbx, r14            ;last address (limit) in this region in rbx
    add r14, 0x1000         ;physical address to check (initially 0x101000 then act as last physical address)
    check_bit2:
    mov rax, r14
    mov rcx, 0xFFFF0
    div rcx
    mov rcx, rdx
    call extract_bit        ;expects bit in rdx
    cmp byte[bit_extracted], 0x0
    jne mapped_already2
    jmp not_mapped_yet2
    mapped_already2:
        add r14, 0x1000     ; advance to next physical address
        cmp r14, rbx        ; if still less than limit go check bit
        jl check_bit2
        add r9, 0x10        ; advance r9 16 bytes to point to next memory region
        add r9, 0x30        ; advance r9 (2*24) bytes to point to next memory region of type 1
        mov rbx, counter
        inc byte[rbx]
        cmp byte[rbx], 0x3  ;3 memory regions of type 1
        jng find_PTE_physical
        mov rax, 0x0
        jmp return
    not_mapped_yet2:
        mov rax,0x1         ;set flag to 1
        mov rax, r14
        mov rcx, 0xFFFF0
        div rcx
        mov rcx, rdx
        call set_bitmap     ;mark bitmap that expects address index in rcx
return2:
ret




;This is where our page table starts

start_here:

mov rsi,dot
call video_print
;Loop to construct page table
;mov rbx, 0x0 ;initialize last_physical
mov rcx, 0x100000 ;lsdt physical of page table levels
;mov rdi, rcx
;mov cr3, rdi
mov r15, 0x0 ;initialize last_page_physical
mov r8, 0x0 ; virtual address
loop_construct_page_table:

call page_walk
  add r8, 0x1000
    mov r9, 0x140000000 ;0x10019FC00
    cmp r8, r9
    jl loop_construct_page_table
    ret


;############################################################################



;expect r8 has v-address
;rbx = last physical (initialized to 0x0)

;page walk function that takes a virtual adddress and gives you a physical frame in the pte eventually

;it enters the page walk only once
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
;mov rdi, cr3
mov r15, 0x100000
shl r13, 3 ;multiply by 8
add r13, r15 ;address of an entry in PML4

cmp qword[r13], 0 ;null entry
je allocate1
jmp skip1


allocate1:

mov rsi, allocate1_msg
call video_print

call get_page_physical ;send physical address in r14
    cmp rax, 0x1
    je approve_allocate1 ; a physical address is found
    jmp go_out           ; no physical addresses of type 1 found any more

approve_allocate1:
mov rsi, hello_world_str
call video_print
    call initialize_page_entries         ;set 512 entries of new level to zeros
or r14, 0x3                          ;present and R/W bits 011b
mov [r13], r14                       ;mov last physical into the entry
mov r15, r14                 ;update last_page_physical
mov rdi, 0x100000
mov cr3, rdi
skip1:
    shl r12, 3            ;mult 8
    add r12, [r13]        ;[r13] is the starting address of this page table level
    cmp qword[r12], 0
    je allocate2
    jmp skip2

allocate2:
mov rsi, allocate2_msg
call video_print

call get_page_physical      ;sends physical address in r14
cmp rax, 0x1
je approve_allocate2
jmp go_out                  ; no physical addresses of type 1 found any more

approve_allocate2:
mov rsi, hello_world_str
call video_print
    call initialize_page_entries         ;set 512 entries of new level to zeros
or r14, 0x3                          ;present and R/W bits 011b
mov [r12], r14                       ;mov last physical into the entry
mov r15, r14                   ;update last_page_physical
mov rdi, 0x100000
mov cr3, rdi
skip2:
    shl r11, 3
    add r11, [r12]
    cmp qword[r11], 0x0
    je allocate3
    jmp skip3

allocate3:
mov rsi, allocate2_msg
call video_print
mov rsi, allocate3_msg
call video_print
call get_page_physical      ;sends physical address in r14
cmp rax, 0x1
je approve_allocate3
jmp go_out                  ; no physical addresses of type 1 found any more

approve_allocate3:
mov rsi, hello_world_str
call video_print
    call initialize_page_entries         ;set 512 entries of new level to zeros
or r14, 0x3                          ;present and R/W bits 011b
mov [r11], r14 ;mov last physical into the entry
mov r15, r14 ;update last_page_physical
mov rdi, 0x100000
mov cr3, rdi
skip3:
    shl r10, 3
    add r10, [r11]
    cmp qword[r10], 0x0
    je allocate4
    jmp skip4

allocate4:
mov rsi, pte_msg
call video_print
call get_PTE_physical
cmp rax, 0x1
je approve_allocate4
jmp go_out                  ; no physical addresses of type 1 found any more

approve_allocate4:
mov rsi, hello_world_str
call video_print
mov [r10], r14 ;mov last physical into the entry
mov rdi, 0x100000
mov cr3, rdi
skip4:
go_out:
ret





;##############################
;TESTER

tester_function:

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




;######################################


;Bitmap constructor function

bitmap_constructor:

pushaq
;loop for the first mega

mov r8, BITMAP_BASE_ADDRESS
mov r9, 0x0 ;counter



first_mega:
mov qword[r8], 0 ;zero 8 bytes at a time
add r8, 0x8 ;add 8 bytes to the pointer of the bitmap
add r9, 0x8
cmp r9, 0x100000 ;compare if the 1MB has finished  
jl first_mega ;jump if less than or equal

;Rest of the memory starting from 0x100000 we must check for the types here
;anything not type 1 will have 1 in the bitmap
;dont forget to adjust the pointer of the mem regions

;adjust the mem regions pointer to point after 256 region [each of size 24 bytes]

;256k * 24 = 6144 = 0x1800

mov r9, 0x20018
add r9, 0x1800 ;it points to the correspondent region in the memory regions  
mov r11, 0x7 ;shift by how many bits every time
add r9, 0x10 ;add 16 bytes to reach the type byte
rest_memory:
cmp dword[r9], 0x1
jne mark_one
jmp mark_zero
mark_one:
mov r10, 0x1
        mov cl, r11b
shl r10, cl ;shift r10 by a number of bits stored in r11
or byte[r8], r10b
dec r11
cmp r11, -1
je adjust_r11
add r9, 0x18 ;go to the next mem regions attributes
jmp rest_memory
mark_zero:
mov r10, 0x0
or byte[r8], r10b
dec r11
cmp r11, -1
je adjust_r11
add r9, 0x18 ;go to the next mem regions attributes
jmp rest_memory

adjust_r11:
add r8, 0x1 ;move r8 in the bitmap to point to the next byte
mov r11, 0x7
add r9, 0x18 ;go to the next mem regions attributes
jmp rest_memory

popaq
ret

;###############################



;How to get the bit correspondent to physical frame inside the page walk?

extract_bit: ;expect rcx index as PF ;base 0
pushaq

mov r8, BITMAP_BASE_ADDRESS
mov r13, 0x8

;R10 = rcx / 0x8   ;get the byte to be addressed
mov rax, rcx
div r13
mov r10, rax

;R11 = rcx % 0x8 ;get the bit inside this byte
mov rax, rcx
div r13
mov r11, rdx

add r8, r10         ;add how many bytes

inc r11             ;this is a technique to make the 1’ bit correspondent to the extracted bit

sub r13, r11        ;r13 = 5
mov rdx, 0x1        ;rdx = 00000001
mov cl, r13b
shl rdx, cl         ;rdx =  00100000
and rdx, [r8]         ;r8=   10100000  
mov [bit_extracted], rdx
popaq
ret                 ;return with val 0/1 in rdx

set_bitmap: ;expect rcx index as PF ;base 0
pushaq

mov r8, BITMAP_BASE_ADDRESS
mov r13, 0x8

;R10 = rcx / 0x8   ;get the byte to be addressed
mov rax, rcx
div r13
mov r10, rax

;R11 = r14 % 0x8 ;get the bit inside this byte
mov rax, rcx
div r13
mov r11, rdx

add r8, r10         ;add how many bytes

inc r11             ;this is a technique to make the 1’ bit correspondent to the extracted bit

sub r13, r11        ;r13 = 5
mov rdx, 0x1        ;rdx = 00000001
mov cl, r13b
shl rdx, cl         ;rdx =  00100000
or [r8], rdx         ;r8=   10100000  
popaq
ret                 ;return with val 0/1 in rdx
