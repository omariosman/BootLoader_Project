%define IDT_BASE_ADDRESS            0x40000 ;  0x4000:0x0000 which is free
%define IDT_HANDLERS_BASE_ADDRESS   0x41000 ;  0x4000:0x1000 which is free
%define IDT_P_KERNEL_INTERRUPT_GATE 0x8E; 1 00 0 1110 -> P DPL Z Int_Gate

struc IDT_ENTRY
.base_low         resw  1
.selector         resw  1
.reserved_ist     resb  1
.flags            resb  1
.base_mid         resw  1
.base_high        resd  1
.reserved         resd  1
endstruc

ALIGN 4                 ; Make sure that the IDT starts at a 4-byte aligned address    
IDT_DESCRIPTOR:         ; The label indicating the address of the IDT descriptor to be used with lidt
      .Size dw    0x1000                   ; Table size is zero (word, 16-bit) -> 256 x 16 bytes
      .Base dq    IDT_BASE_ADDRESS         ; Table base address is NULL (Double word, 64-bit)


load_idt_descriptor: ; A routine that loads the IDT descriptor
    pushaq
    lidt [IDT_DESCRIPTOR] ; load the IDT descriptor
    popaq
    ret
    mov rsi,isr0 ; setup_idt_entry expects that RDI = address of handler, and RDI = interrupt number
    mov rdi,0
    call setup_idt_entry
    
    mov rsi,isr1 ; setup_idt_entry expects that RDI = address of handler, and RDI = interrupt number
    mov rdi,1
    call setup_idt_entry

    mov rsi,isr2 ; setup_idt_entry expects that RDI = address of handler, and RDI = interrupt number
    mov rdi,2
    call setup_idt_entry

    mov rsi,isr3 ; setup_idt_entry expects that RDI = address of handler, and RDI = interrupt number
    mov rdi,3
    call setup_idt_entry

    mov rsi,isr4 ; setup_idt_entry expects that RDI = address of handler, and RDI = interrupt number
    mov rdi,4
    call setup_idt_entry

    mov rsi,isr5 ; setup_idt_entry expects that RDI = address of handler, and RDI = interrupt number
    mov rdi,5
    call setup_idt_entry

    mov rsi,isr6 ; setup_idt_entry expects that RDI = address of handler, and RDI = interrupt number
    mov rdi,6
    call setup_idt_entry

    mov rsi,isr7 ; setup_idt_entry expects that RDI = address of handler, and RDI = interrupt number
    mov rdi,7
    call setup_idt_entry

    mov rsi,isr8 ; setup_idt_entry expects that RDI = address of handler, and RDI = interrupt number
    mov rdi,8
    call setup_idt_entry

    mov rsi,isr9 ; setup_idt_entry expects that RDI = address of handler, and RDI = interrupt number
    mov rdi,9
    call setup_idt_entry

    mov rsi,isr10 ; setup_idt_entry expects that RDI = address of handler, and RDI = interrupt number
    mov rdi,10
    call setup_idt_entry

    mov rsi,isr11 ; setup_idt_entry expects that RDI = address of handler, and RDI = interrupt number
    mov rdi,11
    call setup_idt_entry

    mov rsi,isr12 ; setup_idt_entry expects that RDI = address of handler, and RDI = interrupt number
    mov rdi,12
    call setup_idt_entry

    mov rsi,isr13 ; setup_idt_entry expects that RDI = address of handler, and RDI = interrupt number
    mov rdi,13
    call setup_idt_entry

    mov rsi,isr14 ; setup_idt_entry expects that RDI = address of handler, and RDI = interrupt number
    mov rdi,14
    call setup_idt_entry

    mov rsi,isr15 ; setup_idt_entry expects that RDI = address of handler, and RDI = interrupt number
    mov rdi,15
    call setup_idt_entry

    mov rsi,isr16 ; setup_idt_entry expects that RDI = address of handler, and RDI = interrupt number
    mov rdi,16
    call setup_idt_entry

    mov rsi,isr17 ; setup_idt_entry expects that RDI = address of handler, and RDI = interrupt number
    mov rdi,17
    call setup_idt_entry

    mov rsi,isr18 ; setup_idt_entry expects that RDI = address of handler, and RDI = interrupt number
    mov rdi,18
    call setup_idt_entry

    mov rsi,isr19 ; setup_idt_entry expects that RDI = address of handler, and RDI = interrupt number
    mov rdi,0
    call setup_idt_entry

    mov rsi,isr20 ; setup_idt_entry expects that RDI = address of handler, and RDI = interrupt number
    mov rdi,20
    call setup_idt_entry

    mov rsi,isr21 ; setup_idt_entry expects that RDI = address of handler, and RDI = interrupt number
    mov rdi,21
    call setup_idt_entry

    mov rsi,isr22 ; setup_idt_entry expects that RDI = address of handler, and RDI = interrupt number
    mov rdi,22
    call setup_idt_entry

    mov rsi,isr23 ; setup_idt_entry expects that RDI = address of handler, and RDI = interrupt number
    mov rdi,23
    call setup_idt_entry

    mov rsi,isr24 ; setup_idt_entry expects that RDI = address of handler, and RDI = interrupt number
    mov rdi,24
    call setup_idt_entry

    mov rsi,isr25 ; setup_idt_entry expects that RDI = address of handler, and RDI = interrupt number
    mov rdi,25
    call setup_idt_entry

    mov rsi,isr26 ; setup_idt_entry expects that RDI = address of handler, and RDI = interrupt number
    mov rdi,26
    call setup_idt_entry

    mov rsi,isr27 ; setup_idt_entry expects that RDI = address of handler, and RDI = interrupt number
    mov rdi,27
    call setup_idt_entry

    mov rsi,isr28 ; setup_idt_entry expects that RDI = address of handler, and RDI = interrupt number
    mov rdi,28
    call setup_idt_entry

    mov rsi,isr29 ; setup_idt_entry expects that RDI = address of handler, and RDI = interrupt number
    mov rdi,29
    call setup_idt_entry

    mov rsi,isr30 ; setup_idt_entry expects that RDI = address of handler, and RDI = interrupt number
    mov rdi,30
    call setup_idt_entry


    mov rsi,isr31
    mov rdi,31
    call setup_idt_entry
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
    call load_idt_descriptor ; Every time we modify the IDT we need to load the IDT descriptor

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


init_idt:         ; Intialize the IDT which is 256 entries each entry corresponds to an interrupt number
                  ; Each entry is 16 bytes long
                  ; Table total size if 4KB = 256 * 16 = 4096 bytes
      pushaq
      ; This function need to be written by you.
    ;i think we ca make it all zeros here
      popaq
      ret


%define IDT_HANDLERS_BASE_ADDRESS 0x41000 ; 0x4000:0x1000 which is free
register_idt_handler: ; Store a handler into the handler array
    ; RDI contains the interrupt number
    ; RSI contains the handler address
    pushaq ; Save all general purpose registers
    shl rdi,3 ; Multiply interrupt number by 8 -> the index in handler array
    mov [rdi+IDT_HANDLERS_BASE_ADDRESS],rsi ; Store handler address in the corresponding array location
    popaq ; Restore general purpose registers
    ret

idt_default_handler:
    pushaq
    ;Do anything general here
    popaq
    ret

setup_idt:
          pushaq
                ; This function need to be written by you.
        ; i think we can load lidt register by the address of the idt here
          popaq
          ret


setup_idt_entry:  ; Setup and interrupt entry in the IDT
    ; RDI: Interrupt Number
    ; RSI: Address of the handler
    pushaq
    shl rdi,4 ; multiply interrupt number by 16 (entry location into IDT)
    add rdi,IDT_BASE_ADDRESS ; Add the IDT base address
    mov rax,rsi ; Calculate lower 16-bit of base address and store it
    and ax,0xFFFF
    mov [rdi+IDT_ENTRY.base_low],ax
    mov rax,rsi ; Calculate middle 16-bit of base address and store it
    shr rax, 16
    and ax,0xFFFF
    mov [rdi+IDT_ENTRY.base_mid],ax
    mov rax,rsi ; Calculate high 16-bit of base address and store it
    shr rax, 32
    and eax,0xFFFFFFFF
    mov [rdi+IDT_ENTRY.base_high],eax
    mov [rdi+IDT_ENTRY.selector], byte 0x8 ; The Selector is the GDT code segment index
    mov [rdi+IDT_ENTRY.reserved_ist], byte 0x0
    mov [rdi+IDT_ENTRY.reserved], dword 0x0
    mov [rdi+IDT_ENTRY.flags], byte IDT_P_KERNEL_INTERRUPT_GATE ; 0x8E, 1 00 0 1110 -> P DPL Z Int_Gate
    popaq
    ret



isr_common_stub:
    pushaq ; Save all general purpose registers
    cli ; Disable interrupt
    mov rdi,rsp ; Set RDI to the stack pointer
    mov rax,[rdi+120] ; Fetch the Interrupt number that was pushed by the macro
    shl rax,3 ; Multiple interrupt number by 8 -> offset in handlers array
    mov rax,[IDT_HANDLERS_BASE_ADDRESS+rax] ; Get the address of the registered routine
    cmp rax,0 ; Compare address with NULL
    je .call_default ; If yes, the no registered routine for the interrupt and we execute the default
    call rax ; Else call the registered routine
    jmp .out ; Skip the default
    .call_default:
        call idt_default_handler ; Call the default routine
    .out:
        popaq ; Restore all the general purpose registers
        add rsp,16 ; Make up for the interrupt number and the error code pushed by the macros
        sti ; Enable interrupts -> not necessary, why?
        iretq

irq_common_stub:
    pushaq ; Save all general purpose registers
    cli ; Disable interrupt
    mov rdi,rsp ; Set RDI to the stack pointer
    mov rax,[rdi+120] ; Fetch the Interrupt number that was pushed by the macro
    shl rax,3 ; Multiple interrupt number by 8 -> offset in handlers array
    mov rax,[IDT_HANDLERS_BASE_ADDRESS+rax] ; Get the address of the registered routine
    cmp rax,0 ; Compare address with NULL
    je .call_default ; If yes, the no registered routine for the interrupt and we execute the default
    call rax ; Else call the registered routine
    mov al,0x20 ; VERY IMPORTANT: Send EOI to PIC
    out MASTER_PIC_COMMAND_PORT,al
    out SLAVE_PIC_COMMAND_PORT,al
    jmp .out ; Skip the default
    .call_default:
    call idt_default_handler ; Call the default routine
    .out:
    popaq ; Restore all the general purpose registers
    add rsp,16 ; Make up for the interrupt number and the error code pushed by the macros
    sti ; Enable interrupts -> not necessary, why?
    iretq ; pops 5 things at once: CS, EIP, EFLAGS, SS, and ESP



setup_idt_irqs:
      pushaq
      ; This function need to be written by you.
      popaq
      ret


setup_idt_exceptions:
      pushaq
      ; This function need to be written by you.
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

