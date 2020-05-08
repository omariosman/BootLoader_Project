[ORG 0x10000]

[BITS 64]




Kernel:

bus_loop:
    device_loop:
        function_loop:
           ; call get_pci_device
            inc byte [function]
            cmp byte [function],8
        jne device_loop
        inc byte [device]
        mov byte [function],0x0
        cmp byte [device],32
        jne device_loop
    inc byte [bus]
    mov byte [device],0x0
    cmp byte [bus],255
    jne bus_loop

channel_loop:
    mov qword [ata_master_var],0x0
    master_slave_loop:
        mov rdi,[ata_channel_var]
        mov rsi,[ata_master_var]
     ;   call ata_identify_disk
        inc qword [ata_master_var]
        cmp qword [ata_master_var],0x2
        jl master_slave_loop

    inc qword [ata_channel_var]
    inc qword [ata_channel_var]
    cmp qword [ata_channel_var],0x4
    jl channel_loop
    


;call init_idt
;call setup_idt


;call bitmap_constructor


;address is in rcx
mov rcx, 0x100000
mov r8, 0x200 ;512
looping2:
mov qword[rcx], 0
add rcx, 0x8
dec r8
cmp r8, 0
je start_now
jmp looping2



start_now:
call start_here
call tester_function


kernel_halt: 
    hlt
    jmp kernel_halt


;*******************************************************************************************************************
      %include "sources/includes/third_stage/pushaq.asm"
     ; %include "sources/includes/third_stage/pic.asm"
      ;%include "sources/includes/third_stage/idt.asm"
      ;%include "sources/includes/third_stage/pci.asm"
      %include "sources/includes/third_stage/video.asm"
     ; %include "sources/includes/third_stage/pit.asm"
      ;%include "sources/includes/third_stage/ata.asm"
    %include "sources/includes/third_stage/big_page_table.asm"
;*******************************************************************************************************************


colon db ':',0
comma db ',',0
dot db '.', 0
newline db 13,0
allocate1_msg db 'PML4 Allocation     '
allocate2_msg db '    Level 2 Allocation     '
allocate3_msg db '    Level 3 Allocation     '
pte_msg db '       This is PTE Level     '
end_of_string  db 13        ; The end of the string indicator
start_location   dq  0x0  ; A default start position (Line # 8)

    hello_world_str db 'Hello all here',13, 0

    ata_channel_var dq 0
    ata_master_var dq 0

    bus db 0
    device db 0
    function db 0
    offset db 0
    hexa_digits       db "0123456789ABCDEF"         ; An array for displaying hexa decimal numbers
    ALIGN 4


times 8192-($-$$) db 0
