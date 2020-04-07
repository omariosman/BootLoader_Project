;*******************************************************************************************************
;**************                          MyOS First Stage Boot Loader                     **************
;*******************************************************************************************************
[ORG 0x7c00] 
             
;*********************************************** Macros ************************************************
%define SECOND_STAGE_CODE_SEG       0x0000 
%define SECOND_STAGE_OFFSET         0xC000 
%define THIRD_STAGE_CODE_SEG        0x1000 
%define THIRD_STAGE_OFFSET 0x0000
%define STACK_OFFSET                0xB000   
;********************************************* Main Program ********************************************
      xor ax,ax                           
      mov ds,ax              
      mov ss,ax                        
      mov sp,STACK_OFFSET                
      call bios_cls                      
      mov si,greeting_msg                
      call bios_print           
      mov si, det_boot_msg
      call bios_print
      mov si, press_to_resume
      call bios_print
      call get_key_stroke
      mov si, success
      call bios_print          
      call detect_boot_disk              
      mov di,0x8
      mov word [disk_read_segment],SECOND_STAGE_CODE_SEG
      mov word [disk_read_offset],SECOND_STAGE_OFFSET      
      call read_disk_sectors             
      mov di,0x7F
      mov word [disk_read_segment],THIRD_STAGE_CODE_SEG
      mov word [disk_read_offset],THIRD_STAGE_OFFSET
      call read_disk_sectors  
                               
                              
                               

; Enable the below code when you load successfully the second stage bootloader sectors
      mov si,second_stage_loaded_msg      ; Print a message indicated that second stage boot loader sectors are loaded from disl
      call bios_print
      call get_key_stroke                 ; Wait for key storke to jump to second boot stage
      jmp SECOND_STAGE_OFFSET             ; We perform what we call a long jump as we are going to jump to another segment jmp ox1000:0x0000

      hang:             
            hlt         
            jmp hang    
;************************************ Data Declaration and Definition **********************************
      %include "sources/includes/first_stage/first_stage_data.asm"
;************************************ Subroutines/Functions Includes ***********************************
      %include "sources/includes/first_stage/detect_boot_disk.asm"
      %include "sources/includes/first_stage/load_boot_drive_params.asm"
      %include "sources/includes/first_stage/lba_2_chs.asm"
      %include "sources/includes/first_stage/read_disk_sectors.asm"
      %include "sources/includes/first_stage/bios_cls.asm"
      %include "sources/includes/first_stage/bios_print.asm"
      %include "sources/includes/first_stage/get_key_stroke.asm"
;**************************** Padding and Signature **********************************

      times 510-($-$$) db 0   
                              
                               
      db 0x55,0xAA            


