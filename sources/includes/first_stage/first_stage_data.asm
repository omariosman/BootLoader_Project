;************************************** first_stage_data.asm **************************************
boot_drive db 0x0 ;indicate driving device placeholder
lba_sector dw 0x1  ;lba sector placeholder
spt dw 0x12 ;sector per track
hpc dw 0x2 ;heads per cylinder
Cylinder dw 0x0 ;cylinder placeholder
Head db 0x0 ;head placeholder
Sector dw 0x0 ;setor placeholder
det_boot_msg db 'Detect Disk', 13 , 10, 0 ;detecting dvice msg
success db 'Done', 13, 10, 0 ;printed upon success
disk_error_msg db 'Disk Error', 13, 10, 0 ;error msg
fault_msg db 'Unknown Device', 13, 10, 0 ;fault msg printed on error
booted_from_msg db 'Boot from ', 0 ;booted from msg
floppy_boot_msg db 'flpy', 13, 10, 0 ;floppy idsk msg
drive_boot_msg db 'Disk', 13, 10, 0 ;drive disk msg
greeting_msg db '1st Stage', 13, 10, 0 ;greeting msg in the beginning of the phase
second_stage_loaded_msg db 13,10,'2nd Stage', 0 ;2nd stage bootloader
press_to_resume db 'press key to resume', 13, 10, 0 ;presss to resue stage
dot db '.',0 ;dot printed upon success of reading a sector
newline db 13,10,0 ;ne line character
disk_read_segment dw 0 ;disd read placeholder
disk_read_offset dw 0 ;disk offset placeholder
