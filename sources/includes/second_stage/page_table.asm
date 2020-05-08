%define PAGE_TABLE_BASE_ADDRESS 0x0000
%define PAGE_TABLE_BASE_OFFSET 0x1000
%define PAGE_TABLE_EFFECTIVE_ADDRESS 0x1000
%define PAGE_PRESENT_WRITE 0x3 ; 011b
%define MEM_PAGE_4K 0x1000
build_page_table:
;push all the registers before going int othe function
pusha
;adjust the segment:offset foramt to resetting all the 16k needed for the page table
mov ax,PAGE_TABLE_BASE_ADDRESS
mov es,ax
xor eax,eax
mov edi,PAGE_TABLE_BASE_OFFSET
;ecx is the o=coutner at which rep will work for
mov ecx, 0x1000 
;xor with itself to set it to zero
xor eax, eax 
;clear 4 bytes at a time
cld 
;store ehat is at eax into the tnry pointoed to by es:di
rep stosd 

;edi starting address of page table
mov edi,PAGE_TABLE_BASE_OFFSET 

;load effective addr
lea eax, [es:di + MEM_PAGE_4K] 
or eax, PAGE_PRESENT_WRITE 
mov [es:di], eax 

;increment pointer by 4k
add di,MEM_PAGE_4K
lea eax, [es:di + MEM_PAGE_4K]
or eax, PAGE_PRESENT_WRITE 
mov [es:di], eax 

;increment pointer to the next level
add di,MEM_PAGE_4K
lea eax, [es:di + MEM_PAGE_4K] 
or eax, PAGE_PRESENT_WRITE 
mov [es:di], eax 

;advance pointer by 4k
add di,MEM_PAGE_4K
mov eax, PAGE_PRESENT_WRITE 
.pte_loop: 
mov [es:di], eax
add eax, MEM_PAGE_4K
add di, 0x8
cmp eax, 0x200000 
jl .pte_loop 
popa
ret

