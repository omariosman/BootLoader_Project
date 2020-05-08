%define CODE_SEG     0x0008         ; Code segment selector in GDT
%define DATA_SEG     0x0010         ; Data segment selector in GDT


switch_to_long_mode:

;*********************************** Long Mode 64-bit **********************************
  ;these are fixed configurations before switching
;set bits 5 and 7 (PAE and PGE)
mov eax, 10100000b
mov cr4, eax ; move eax into CR4

mov edi,PAGE_TABLE_EFFECTIVE_ADDRESS
mov edx, edi ; Point CR3 at the PML4
mov cr3, edx
mov ecx, 0xC0000080
rdmsr
; modify bit 8 so we will not touch edx
; modify bit 8 in eax and write back edx:eax
or eax, 0x00000100 ; Set the Long Mode Bit
wrmsr

mov ebx, cr0 ; Read CR0
or ebx,0x80000001 ; Set Bit 0 and 31

mov cr0, ebx ; Set CR0
lgdt [GDT64.Pointer] ; Load GDT.Pointer de  fined below.
    jmp CODE_SEG:LM64 ; Load CS with 64 bit GDT segment and flush the instruction cache
    ret
