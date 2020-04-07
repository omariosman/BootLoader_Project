;************************************** first_stage_data.asm **************************************
boot_drive db 0x0 
lba_sector dw 0x1 
spt dw 0x12
hpc dw 0x2
Cylinder dw 0x0
Head db 0x0
Sector dw 0x0
det_boot_msg db 'Detecting Boot Disk', 13 , 10, 0
success db 'Done Sucessfully', 13, 10, 0
disk_error_msg db 'Disk Error', 13, 10, 0
fault_msg db 'Unknown Boot Device', 13, 10, 0
booted_from_msg db 'Booted from ', 0
floppy_boot_msg db 'Floppy', 13, 10, 0
drive_boot_msg db 'Disk', 13, 10, 0
greeting_msg db '1st Stage Loader', 13, 10, 0
second_stage_loaded_msg db 13,10,'2nd Stage loader', 0
press_to_resume db 'press any key to resume!', 13, 10, 0
dot db '.',0
newline db 13,10,0
disk_read_segment dw 0
disk_read_offset dw 0

