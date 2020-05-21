%define CONFIG_ADDRESS  0xcf8
%define CONFIG_DATA     0xcfc

ata_device_msg db 'Found ATA Controller',13,10,0
pci_header times 512 db 0



struc PCI_CONF_SPACE
.vendor_id          resw    1
.device_id          resw    1
.command            resw    1
.status             resw    1
.rev                resb    1
.prog_if            resb    1
.subclass           resb    1
.class              resb    1
.cache_line_size    resb    1
.latency            resb    1
.header_type        resb    1
.bist               resb    1
.bar0               resd    1
.bar1               resd    1
.bar2               resd    1
.bar3               resd    1
.bar4               resd    1
.bar5               resd    1
.reserved           resd    2
.int_line           resb    1
.int_pin            resb    1
.min_grant          resb    1
.max_latency        resb    1
.data               resb    192
endstruc

get_pci_device:

xor rax,rax
    ;Compose the Command Register: ((bus << 16) | (device << 11) | (function << 8) | (offset & 0xfc) | ( 0x80000000))
 
    ; Bit 7-2 : so we clear the last two bytes by & 0xfc
   
    xor rbx,rbx ;we zero out the rbx
    mov bl,[bus]  ; value of bus will ve stored in bl
    shl ebx,16     ; shift left  16 bits
    or eax,ebx       ; we need to store what is in ebx into eax
    xor rbx,rbx ;clear the rbx to store (device << 11)
    mov bl,[device]  
    shl ebx,11   ;another shiftleft by 11 bits to put the device number in its place
    or eax,ebx     ;eax has the the bus and decvice
    xor rbx,rbx ;clear rbx again for the (function << 8)
    mov bl,[function]
    shl ebx,8  ;shift left by 8bits to put the offset in its place
    or eax,ebx
    or eax,0x80000000 ;enaling  Bit 31
    xor rsi,rsi ; clear out rsi
;we need a loop to read 256 bytes
    pci_config_space_read_loop:
        push rax  
     
        or rax,rsi  ;
        and al,0xfc ;set the last 2 bits to zero
       
        mov dx,CONFIG_ADDRESS
        out dx,eax
 
        mov dx,CONFIG_DATA
        xor rax,rax
        in eax,dx
       
        mov [pci_header+rsi],eax ;store in pci_header the 256 bit of the header
        add rsi,0x4 ; increment rsi
        pop rax
        cmp rsi,0xff ;make sure that the 256 were read when rsi =ff

        jl pci_config_space_read_loop

 ret
