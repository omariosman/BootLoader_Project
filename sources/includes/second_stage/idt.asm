ALIGN 4                 ;address divided by four  
IDT_DESCRIPTOR:         ;structure of the idt decripotr
      .Size dw    0x0     ; Size placeholder
      .Base dd    0x0     ; Base placeholder

load_idt_descriptor:
    pusha
    lidt [IDT_DESCRIPTOR]    ; load the IDT descriptor
    ;pop registers to get out of the function with correct values
    popa
    ret
