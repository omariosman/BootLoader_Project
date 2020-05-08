%define MASTER_PIC_COMMAND_PORT     0x20
%define SLAVE_PIC_COMMAND_PORT      0xA0
%define MASTER_PIC_DATA_PORT        0x21
%define SLAVE_PIC_DATA_PORT         0xA1


    disable_pic:
        pusha
        mov al,0xFF                 ;this value disables pic when passed to its controllers (master and slave)
        out MASTER_PIC_DATA_PORT,al
        out SLAVE_PIC_DATA_PORT,al
        nop                         ;requires 2 no operation to be compelely disabled
        nop
        mov si, pic_disabled_msg
        call bios_print             ;print msg to indicate that pic is disabled
        popa
        ret
