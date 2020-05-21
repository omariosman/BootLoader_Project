%define IDT_BASE_ADDRESS            0x40000
%define IDT_HANDLERS_BASE_ADDRESS   0x41000
%define IDT_P_KERNEL_INTERRUPT_GATE 0x8E

struc IDT_ENTRY
.base_low         resw  1
.selector         resw  1
.reserved_ist     resb  1
.flags            resb  1
.base_mid         resw  1
.base_high        resd  1
.reserved         resd  1
endstruc

ALIGN 4                 ; setting the IDT start at aligned address that is  4-byte  
IDT_DESCRIPTOR:      
      .Size dw    0x1000                   ; set the size to be 1000 hexa= 4k byte as we have 256 x 16 bytes
      .Base dq    IDT_BASE_ADDRESS      


load_idt_descriptor: ;routine to loads the IDT descriptor
    pushaq
    lidt [IDT_DESCRIPTOR] ; load the IDT descriptor
    popaq
    ret

init_idt:         ; Intialize t 256 entries of IDT as each entry corresponds to an interrupt number
                  ; Each entry is 16 bytes
               
      pushaq
      mov rdi,IDT_BASE_ADDRESS   ;
  mov rcx, 0x400     ;since the Table total size if 4KB = 256 * 16 = 4096 byte, then we a counter goes up to 4096
      xor rax, rax        ;  clear eax
      cld                 ; we clear the direction flag as we decrement the rcs
      rep stosq          
      popaq
      ret


%define IDT_HANDLERS_BASE_ADDRESS 0x41000 ; 0x4000:0x1000 which is free
register_idt_handler: ; Store a handler into the handler array
    ; the interrupt number are in the RDI
    ; handler address are in the RSI
    pushaq ; Save all general purpose registers
    shl rdi,3 ;this is a shift left where  Multiply interrupt number by 8 -> the index in handler array
    mov [rdi+IDT_HANDLERS_BASE_ADDRESS],rsi ; Store handler address in the corresponding array location
    popaq ; Restore general purpose registers
    ret

idt_default_handler:
    pushaq
    ;Do anything general here
    popaq
    ret
;in the set up function we need to configure the pic and pit
; we also need call the irqs and exceptions to go over the RSIs and IRQs
setup_idt:
          pushaq   ;
             cli
            call configure_pic ;we call pic
            mov rcx,0x0
            .setup_idt_loop:   ;we created a loop
               mov rdi,rcx  ;move rcx to rdi
                  call set_irq_mask
                  inc rcx  ;increment rcx
                  cmp rcx,16  ;coming the rcx to 16, if it is more than 16,  then we get out if  the loop
                  jne .setup_idt_loop  

            call setup_idt_exceptions  ;calling the exception function
            call setup_idt_irqs             ; calling the irqs function
            mov rsi,isr255
            mov rdi,255
            call setup_idt_entry           
            call load_idt_descriptor ;lidt
            ;call configure_pit ;calling the pit configuration 
            mov rdi,0x0
            call clear_irq_mask 
            sti
          popaq 
          ret

 ; RSI:handler Address
  ; RDI: Interrupt Number

setup_idt_entry:
 
     
    pushaq
    shl rdi,4 ; we do shift left by 4 to multiply interrupt by 16
    add rdi,IDT_BASE_ADDRESS ; Add the IDT base address to get the location of the entry
    mov rax,rsi ; move the rsi in rax to calculate  and store lower 16-bit of base address
    and ax,0xFFFF ;get the lowest  16 bit
    mov [rdi+IDT_ENTRY.base_low],ax
    mov rax,rsi  ;move the rsi in rax to calculate  and store middle 16-bit of base address
    shr rax, 16 ;shift right the rax with 16
    and ax,0xFFFF
    mov [rdi+IDT_ENTRY.base_mid],ax
    mov rax,rsi ; move the rsi in rax to calculate  and store high 16-bit of base address
    shr rax, 32
    and eax,0xFFFFFFFF
    mov [rdi+IDT_ENTRY.base_high],eax
    mov [rdi+IDT_ENTRY.selector], byte 0x8
    mov [rdi+IDT_ENTRY.reserved_ist], byte 0x0
    mov [rdi+IDT_ENTRY.reserved], dword 0x0
    mov [rdi+IDT_ENTRY.flags], byte IDT_P_KERNEL_INTERRUPT_GATE ;
    popaq
    ret



isr_common_stub:
    pushaq
    cli ; disabling the  interrupt
    mov rdi,rsp ; Set RDI to the stack pointer
    mov rax,[rdi+120] ; get the Interrupt number pushed by the macro
    shl rax,3
    mov rax,[IDT_HANDLERS_BASE_ADDRESS+rax]
    cmp rax,0 ; we need to compare address at rax with NULL
    je .call_default
    call rax
    jmp .out
    .call_default:
        call idt_default_handler ; make  the default routine call
    .out:
        popaq ; Restore the general purpose registers
        add rsp,16 ; for the interrupt number and the error code pushed by the macros
        sti
        iretq

irq_common_stub:
    pushaq ; Save all general purpose registers
    cli ; disabling the interrupt
    mov rdi,rsp ; Set RDI to the stack pointer
    mov rax,[rdi+120] ; we need to get the Interrupt number  pushed by the macro
    shl rax,3
    mov rax,[IDT_HANDLERS_BASE_ADDRESS+rax] ; the address of the registered routine of IDT_HANDLERS_BASE
    cmp rax,0 ;we need to compare rax to null
    je .call_default ;if it is null, then there is  no registered routine for the interrupt and go back the default
    call rax ; if it is no,then  call the registered routine
    mov al,0x20 ;EOI going  to  the PIC
    out MASTER_PIC_COMMAND_PORT,al
    out SLAVE_PIC_COMMAND_PORT,al
    jmp .out   ; Skip the default
    .call_default:
    call idt_default_handler ; Call the default routine
    .out:
    popaq
    add rsp,16 ; Make up for the interrupt number and the error code pushed by the macros
    sti ; enabling the  interrupts
    iretq


;we go over the 16 IRQs  
setup_idt_irqs:
      pushaq
    mov rsi,irq0
      mov rdi,32
      call setup_idt_entry
 
      mov rsi,irq1
      mov rdi,33
      call setup_idt_entry
 
      mov rsi,irq2
      mov rdi,34
      call setup_idt_entry
 
      mov rsi,irq3
      mov rdi,35
      call setup_idt_entry
 
      mov rsi,irq4
      mov rdi,36
      call setup_idt_entry
 
      mov rsi,irq5
      mov rdi,37
      call setup_idt_entry
 
      mov rsi,irq6
      mov rdi,38
      call setup_idt_entry
 
      mov rsi,irq7
      mov rdi,39
      call setup_idt_entry
 
      mov rsi,irq8
      mov rdi,40
      call setup_idt_entry
 
      mov rsi,irq9
      mov rdi,41
      call setup_idt_entry
 
      mov rsi,irq10
      mov rdi,42
      call setup_idt_entry
 
      mov rsi,irq11
      mov rdi,43
      call setup_idt_entry
 
      mov rsi,irq12
      mov rdi,44
      call setup_idt_entry
 
      mov rsi,irq13
      mov rdi,45
      call setup_idt_entry
 
      mov rsi,irq14
      mov rdi,46
      call setup_idt_entry
 
      mov rsi,irq15
      mov rdi,47
      call setup_idt_entry
      popaq
      ret

;setup_idt_exceptions goes over the 32 processor exceptions so it is going over all the ISRs from 0 to 31
setup_idt_exceptions:
      pushaq
      mov rsi,isr0
      mov rdi,0
      call setup_idt_entry
 
      mov rsi,isr1
      mov rdi,1
      call setup_idt_entry
 
      mov rsi,isr2
      mov rdi,2
      call setup_idt_entry
 
      mov rsi,isr3
      mov rdi,3
      call setup_idt_entry
 
      mov rsi,isr4
      mov rdi,4
      call setup_idt_entry
 
      mov rsi,isr5
      mov rdi,5
      call setup_idt_entry
 
      mov rsi,isr6
      mov rdi,6
      call setup_idt_entry
 
      mov rsi,isr7
      mov rdi,7
      call setup_idt_entry
 
      mov rsi,isr8
      mov rdi,8
      call setup_idt_entry
 
      mov rsi,isr9
      mov rdi,9
      call setup_idt_entry
 
      mov rsi,isr10
      mov rdi,10
      call setup_idt_entry
 
      mov rsi,isr11
      mov rdi,11
      call setup_idt_entry
 
      mov rsi,isr12
      mov rdi,12
      call setup_idt_entry
 
      mov rsi,isr13
      mov rdi,13
      call setup_idt_entry
 
      mov rsi,isr14
      mov rdi,14
      call setup_idt_entry
 
      mov rsi,isr15
      mov rdi,15
      call setup_idt_entry
 
      mov rsi,isr16
      mov rdi,16
      call setup_idt_entry
 
      mov rsi,isr17
      mov rdi,17
      call setup_idt_entry
 
      mov rsi,isr18
      mov rdi,18
      call setup_idt_entry
 
      mov rsi,isr19
      mov rdi,19
      call setup_idt_entry
 
      mov rsi,isr20
      mov rdi,20
      call setup_idt_entry
 
      mov rsi,isr21
      mov rdi,21
      call setup_idt_entry
 
      mov rsi,isr22
      mov rdi,22
      call setup_idt_entry
 
      mov rsi,isr23
      mov rdi,23
      call setup_idt_entry
 
      mov rsi,isr24
      mov rdi,24
      call setup_idt_entry
 
      mov rsi,isr25
      mov rdi,25
      call setup_idt_entry
 
      mov rsi,isr26
      mov rdi,26
      call setup_idt_entry
 
      mov rsi,isr27
      mov rdi,27
      call setup_idt_entry
 
      mov rsi,isr28
      mov rdi,28
      call setup_idt_entry
 
      mov rsi,isr29
      mov rdi,29
      call setup_idt_entry
 
      mov rsi,isr30
      mov rdi,30
      call setup_idt_entry
 
      mov rsi,isr31
      mov rdi,31
      call setup_idt_entry
      popaq
      ret

; This macro will be used with exceptions that does not push error codes on the stack
; NOtice that we push first a zero on the stack to make it consistent with other excptions
; that pushes an error code on the stack
%macro ISR_NOERRCODE 1
  [GLOBAL isr%1]
  isr%1:
      cli
      push qword 0
      push qword %1
      jmp isr_common_stub
%endmacro

; This macro will be used with exceptions that push error codes on the stack
; Notice that we here push only the interrupt number which is passed as a parameter to the macro
%macro ISR_ERRCODE 1
  [GLOBAL isr%1]
  isr%1:
      cli
      push qword %1
      jmp isr_common_stub
%endmacro


; This macro will be used with the IRQs generated by the PIC
%macro IRQ 2
  global irq%1
  irq%1:
      cli
      push qword 0
      push qword %2
      jmp irq_common_stub
%endmacro



ISR_NOERRCODE 0
ISR_NOERRCODE 1
ISR_NOERRCODE 2
ISR_NOERRCODE 3
ISR_NOERRCODE 4
ISR_NOERRCODE 5
ISR_NOERRCODE 6
ISR_NOERRCODE 7
ISR_ERRCODE   8
ISR_NOERRCODE 9
ISR_ERRCODE   10
ISR_ERRCODE   11
ISR_ERRCODE   12
ISR_ERRCODE   13
ISR_ERRCODE   14
ISR_NOERRCODE 15
ISR_NOERRCODE 16
ISR_NOERRCODE 17
ISR_NOERRCODE 18
ISR_NOERRCODE 19
ISR_NOERRCODE 20
ISR_NOERRCODE 21
ISR_NOERRCODE 22
ISR_NOERRCODE 23
ISR_NOERRCODE 24
ISR_NOERRCODE 25
ISR_NOERRCODE 26
ISR_NOERRCODE 27
ISR_NOERRCODE 28
ISR_NOERRCODE 29
ISR_NOERRCODE 30
ISR_NOERRCODE 31


IRQ   0,    32
IRQ   1,    33
IRQ   2,    34
IRQ   3,    35
IRQ   4,    36
IRQ   5,    37
IRQ   6,    38
IRQ   7,    39
IRQ   8,    40
IRQ   9,    41
IRQ  10,    42
IRQ  11,    43
IRQ  12,    44
IRQ  13,    45
IRQ  14,    46
IRQ  15,    47


isr255:
        iretq


