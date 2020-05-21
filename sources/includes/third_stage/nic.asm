%define ETHERTYPE_IP 0x0800 ; IP protocol
%define ETHERTYPE_ARP 0x0806 ; Address resolution protocol
; Ethernet Protocol packet
struc ethernet_packet
.h_dest resb 6 ; 6-octet destination HW address
.h_src resb 6 ; 6-octet source HW address
.h_type resw 1 ; Network-Layer protocol type
endstruc
;current_memory_address dq 0x0
hexa_pad dq 0x0
.quit:
e1000process_packet:
nop
;***************************************************************************

%define ARPHRD_ETHER 1 ; Ethernet hardware format
%define ARPHRD_IEEE802 6 ; Token-ring hardware format
%define ARPHRD_FRELAY 15 ; Frame relay hardware format
%define ARPHRD_IEEE1394 24 ; IEEE1394 hardware address
%define ARPHRD_IEEE1394_EUI64 27 ; IEEE1394 EUI-64
%define ARPOP_REQUEST 1 ; Request to resolve address
%define ARPOP_REPLY 2 ; Response to previous request
%define ARPOP_REVREQUEST 3 ; Request protocol address given hardware
%define ARPOP_REVREPLY 4 ; Response giving protocol address
%define ARPOP_INVREQUEST 8 ; Request to identify peer
%define ARPOP_INVREPLY 9 ; Response identifying peer

; ARP Protocol packet
struc arp_packet
.ethernet resb 14 ; Ethernet header
.ar_hwt resw 1 ; Hardware Type
.ar_pro resw 1 ; Protocol type for which resolution is performed e.g. IP
.ar_hln resb 1 ; Hardware address length
.ar_pln resb 1 ; Protocol address length
.ar_op resw 1 ; Operation, e.g. Request/Reply
.sender_hw_addr resb 6 ; Based on ar_hdr for ethernet 6-octet source HW address
.sender_proto_addr resb 4 ; Based on ar_pro for IP 4-octet source protocol address
.target_hw_addr resb 6 ; Based on ar_hdr for ethernet 6-octet target HW address
.target_proto_addr resb 4 ; Based on ar_pro for IP 4-octet target protocol address
endstruc
;***************************************************************************
%define IP_PACKET_TYPE_ICMP 0x1 ; ICMP Protocol number in IP header
%define IP_PACKET_TYPE_TCP 0x6 ; TCP Protocol number in IP header
%define IP_PACKET_TYPE_UDP 0x11 ; UDP Protocol number in IP header
; IP Protocol packet
struc ip_hdr
.ihlv resb 1 ; Upper half (4-bits) IP Header Length,
; Lower half (4-bits) is version
.tos resb 1 ; Type Of Service
.tot_len resw 1 ; Total size of packet Header+Data
.id resw 1 ; Used as an identifier for fragmentation
.flgs resb 1 ; High 5-bits reserved, Low 3-bits are flags
.frag_offset resb 1 ; Fragment offset within the same ID
.ttl resb 1 ; Time-to-Live
.protocol resb 1 ; Protocol number (ICMP, TCP, or UDP)
.check resw 1 ; Header only checksum Checksum
.saddr resd 1 ; Source 4-octet IP address
.daddr resd 1 ; Destination 4-octet IP address
endstruc

%define ICMP_ECHOREPLY 0
%define ICMP_ECHO 8
%define ICMP_INFO_REQUEST 15
%define ICMP_INFO_REPLY 16


; There are more types, a full list can be found at https://www.iana.org/assignments/icmp-parameters/icmpparameters.
;xhtml
; Different ICMP Protocol packets
struc ip_icmp_echo ; Echo Datagrams
.type resb 1 ; Protocol Type
.code resb 1 ; Type sub-code
.checksum resw 1 ; Checksum of ICMP header and data
.id resw 1 ; Used for time stamp matching by the client
.sequence resw 1 ; Used for time stamp matching by the client
endstruc
struc ip_icmp_frag ; MTU Discovery
.type resb 1 ; Protocol Type
.code resb 1 ; Type sub-code
.checksum resw 1 ; Checksum of ICMP header and data
.unused resw 1 ; Unused
.mtu resw 1 ; MTU of the next hop in case of errors
endstruc
struc ip_icmp_gw ; Gateway Diagnostics
.type resb 1 ; Protocol Type
.code resb 1 ; Type sub-code
.checksum resw 1 ; Checksum of ICMP header and data
.gateway resd 1 ; 4-octet IP address of the gateway for redirection
endstruc

;***************************************************************************
%define INTEL_VEND  0x8086 ; some definitions for pci_config
%define E1000_DEV   0x100E
%define E1000_DEV1  0x153A
%define E1000_DEV2  0x10EA
%define E1000_DEV3  0x100F
%define E1000_DEV4  0x1004
%define E1000_MODELS_COUNT          0x5
;******************************************
e1000_mem_base               dq 0x0   ; Physical Memory MMIO base address filled when pci scanned
e1000_rw_data                dd 0x0   ; Data to be written/read from MMIO or Port I/O address space
e1000_rw_address             dw 0x0   ; Offset address into MMIO or Port I/O address space
e1000_io_base                dw 0x0   ; Port base address
e1000_vaddress               dq 0x2000000000 ; Starting virtual address to map MMIO Physical Memory to
e1000_flag                   db 0x0          ; for E1000 NIC detection
e1000_ioport_flag            db 0x0          ; A flag used to be set if the NIC is PortIO-based
e1000_mac_address            db 0x0,0x0,0x0,0x0,0x0,0x0 ; A space to store E1000 NIC 6-octet MAC address
e1000_eeprom_addr            db 0x0     ; EEProm address
e1000_int_no                 db 0x0     ; IRQ number detected from PCI Header
e1000_eeprom_flag            db 0x0     ; A flag used to indicate that the EEPROM is detected
; Some messages to be used for notifications
found_intel_e1000_msg        db 'Found e1000 NIC device',13,10,0
e1000_configure_msg          db 'Configuring e1000',13,10,0
e1000_map_memio_msg          db 'Mapping e1000 MemIO',13,10,0
e1000_eeprom_detected_msg    db 'e1000 EEProm Detected',13,10,0
e1000_start_up_link_msg      db 'e1000 Started Link',13,10,0
e1000_setup_throttling_msg   db 'e1000 Throttling setup done',13,10,0
e1000_multicast_vt_msg       db 'e1000 clear Multicast VT done',13,10,0
e1000_mem_init_msg           db 'e1000 memory setup done',13,10,0
e1000_rx_init_msg            db 'e1000 init RX',13,10,0
e1000_tx_init_msg            db 'e1000 init TX',13,10,0
e1000_enable_interrupt_msg   db 'e1000 interrupts enabled',13,10,0
e1000_got_packet_msg         db 'e1000 got interrupt',13,10,0
e1000_link_restarted_int_msg db 'e1000(int) link restarted',13,10,0
e1000_good_threshold_int_msg db 'e1000(int) good threshold',13,10,0
e1000_process_packet_int_msg db 'e1000(int) process packet',13,10,0
e1000_sent_packet_msg        db 'e1000 sent packet',13,10,0
my_ip_msg                    db 'got ARP Packet',13,10,0
start_bus_mastering_msg     db 'started bus mastering',13,10,0
bus_mastering_msg     db 'bus mastering enabled',13,10,0


; PCI bus/device/function of slot that the detected E1000 NIC is connected to
e1000_bus db 0
e1000_device db 0
e1000_function db 0
e1000_rx_cur dw 0x0 ; Current descriptor index to be processed in the Receive Ring Buffer
e1000_tx_cur dw 0x0 ; Current descriptor index to be processed in the Transmit Ring Buffer
e1000_rx_desc_ptr dq 0x0 ; Address of the Receive Ring Buffer
e1000_tx_desc_ptr dq 0x0 ; Address of the Transmit Ring Buffer
e1000_rx_packets_ptr dq 0x0 ; Address of buffer that holds packets pointed to by receive descriptor ring
;buffer
e1000_tx_packets_ptr dq 0x0 ; Address of buffer that holds packets pointed to by transmit descriptor
;ring buffer
e1000_recv_packet dq 0x0 ; Address of a buffer that holds the last packet received for processing
e1000_send_packet dq 0x0 ; Address of a buffer that holds the next packet to be sent on the network
e1000_recv_packet_len dw 0x0 ; Length of the last received packet stored in e1000_recv_packet
e1000_send_packet_len dw 0x0 ; Length of the packet to be sent store in e1000_send_packet
my_ip_address db 192,168,1,88 ; IP address assigned to the E1000 NIC
%define e1000_desc_size 16 ; size of a single element in the ring buffer (size of a Transmit/Receive Descriptor)
%define e1000_desc_array_count 0x800 ; Number of Descriptor in Ring Buffer (2048)
%define e1000_desc_array_size 0x8000 ; Size of Ring Buffer (2048 x 16)
%define e1000_packet_area_size 0x400000 ; Size of Packets in Transmit/Receive Buffer (2048*2048)
%define e1000_bar0_mem_size 0x200000 ; Size of MMIO -> 128KB (From the Data Sheet)
%define e1000_packet_size 0x800 ; Size in bytes reserved for a network packet (2048)
;**********************************************************************************
%define E1000_CTRL_PHY_RST 0x80000000
%define FCAL 0x0028
%define FCAH 0x002C
%define FCT 0x0030
%define FCTT 0x0170
%define THROT 0x00C4
%define MULTICAST_VT 0x5200
%define REG_CTRL 0x0000
%define REG_STATUS 0x0008
%define REG_EEPROM 0x0014
%define REG_CTRL_EXT 0x0018
%define REG_ICR 0x00C0
%define REG_IMASK 0x00D0
%define REG_RCTRL 0x0100
%define REG_RXDESCLO 0x2800
%define REG_RXDESCHI 0x2804
%define REG_RXDESCLEN 0x2808
%define REG_RXDESCHEAD 0x2810
%define REG_RXDESCTAIL 0x2818
%define REG_TCTRL 0x0400
%define REG_TXDESCLO 0x3800
%define REG_TXDESCHI 0x3804
%define REG_TXDESCLEN 0x3808
%define REG_TXDESCHEAD 0x3810
%define REG_TXDESCTAIL 0x3818
%define REG_RDTR 0x2820 ; RX Delay Timer Register
%define REG_RXDCTL 0x3828 ; RX Descriptor Control
%define REG_RADV 0x282C ; RX Int. Absolute Delay Timer
%define REG_RSRPD 0x2C00 ; RX Small Packet Detect Interrupt

%define REG_TIPG 0x0410 ; Transmit Inter Packet Gap
%define ECTRL_ASDE 0x20 ;auto speed enable
%define ECTRL_FD 0x01 ;FULL DUPLEX
%define ECTRL_SLU 0x40 ;set link up
%define ECTRL_100M 0x100 ;set speed to 100 Mb/sec
%define ECTRL_1000M 0x200 ;set speed to 1000 Mb/sec
%define ECTRL_FRCSPD 0x800 ;Force Speed
%define RCTL_EN (1 << 1) ; Receiver Enable
%define RCTL_SBP (1 << 2) ; Store Bad Packets
%define RCTL_UPE (1 << 3) ; Unicast Promiscuous Enabled
%define RCTL_MPE (1 << 4) ; Multicast Promiscuous Enabled
%define RCTL_LPE (1 << 5) ; Long Packet Reception Enable
%define RCTL_LBM_NONE (0 << 6) ; No Loopback
%define RCTL_LBM_PHY (3 << 6) ; PHY or external SerDesc loopback
%define RTCL_RDMTS_HALF (0 << 8) ; Free Buffer Threshold is 1/2 of RDLEN
%define RTCL_RDMTS_QUARTER (1 << 8) ; Free Buffer Threshold is 1/4 of RDLEN
%define RTCL_RDMTS_EIGHTH (2 << 8) ; Free Buffer Threshold is 1/8 of RDLEN
%define RCTL_MO_36 (0 << 12) ; Multicast Offset - bits 47:36
%define RCTL_MO_35 (1 << 12) ; Multicast Offset - bits 46:35
%define RCTL_MO_34 (2 << 12) ; Multicast Offset - bits 45:34
%define RCTL_MO_32 (3 << 12) ; Multicast Offset - bits 43:32
%define RCTL_BAM (1 << 15) ; Broadcast Accept Mode
%define RCTL_VFE (1 << 18) ; VLAN Filter Enable
%define RCTL_CFIEN (1 << 19) ; Canonical Form Indicator Enable
%define RCTL_CFI (1 << 20) ; Canonical Form Indicator Bit Value
%define RCTL_DPF (1 << 22) ; Discard Pause Frames
%define RCTL_PMCF (1 << 23) ; Pass MAC Control Frames
%define RCTL_SECRC (1 << 26) ; Strip Ethernet CRC

; Buffer Sizes
%define RCTL_BSIZE_256 (3 << 16)
%define RCTL_BSIZE_512 (2 << 16)
%define RCTL_BSIZE_1024 (1 << 16)
%define RCTL_BSIZE_2048 (0 << 16)
%define RCTL_BSIZE_4096 ((3 << 16) | (1 << 25))
%define RCTL_BSIZE_8192 ((2 << 16) | (1 << 25))
%define RCTL_BSIZE_16384 ((1 << 16) | (1 << 25))
; Transmit Command
%define CMD_EOP (1 << 0) ; End of Packet
%define CMD_IFCS (1 << 1) ; Insert FCS
%define CMD_IC (1 << 2) ; Insert Checksum
%define CMD_RS (1 << 3) ; Report Status
%define CMD_RPS (1 << 4) ; Report Packet Sent
%define CMD_VLE (1 << 6) ; VLAN Packet Enable
%define CMD_IDE (1 << 7) ; Interrupt Delay Enable
; TCTL Register
%define TCTL_EN (1 << 1) ; Transmit Enable
%define TCTL_PSP (1 << 3) ; Pad Short Packets
%define TCTL_CT_SHIFT 4 ; Collision Threshold
%define TCTL_COLD_SHIFT 12 ; Collision Distance
%define TCTL_SWXOFF (1 << 22) ; Software XOFF Transmission
%define TCTL_RTLC (1 << 24) ; Re-transmit on Late Collision
%define TSTA_DD (1 << 0) ; Descriptor Done
%define TSTA_EC (1 << 1) ; Excess Collisions
%define TSTA_LC (1 << 2) ; Late Collision
%define LSTA_TU (1 << 3) ; Transmit Underrun
;*********************************************************************************
struc e1000_rx_desc     ; buffer descreptor for the receiving (16 bytes)
.addr resq 1 ; Address to the packet buffer corresponding to this descriptor.
.length resw 1 ; Length of the packet. This is filled up by the card on reception of a packet.
.checksum resw 1 ; can be used by the software to validate the packet. ehn packet is recevied the card will store it
.status resb 1 ; Should be initially zero and set to 0x1 when a packet is received and assigned.
; The driver should set it to 0x0 when it fetches the packet.
.errors resb 1 ; Error flag.
.special resw 1 ; Special purpose area that can be used by the software.
endstruc

; buffer descreptor for the transimitting (16 bytes)
struc e1000_tx_desc
.addr resq 1 ; Address of the packet buffer corresponding to this descriptor.
; The driver should copy a packet to this buffer to be sent by the card
.length resw 1 ; The driver should set this to the length of the packet
.cso resb 1 ; The Checksum offset field indicates where, relative to the start of
; the packet, to insert a TCP checksum if this mode is enabled
.cmd resb 1 ; Used to instruct the card how to send the packet
.status resb 1 ; Used to set the status of sending the packet
.css resb 1 ; The Checksum start field indicates where to begin computing the checksum.
.special resw 1 ; Special purpose area that can be used by the software.
endstruc
;************************************************************************************


e1000_pci_config: ; This function need to be invoked from within the PCI scan loop for each device
 pushaq
 mov r9,[pci_header] ; Checking if the VENDOR ID is INTEL_VEND
 cmp word[r9+PCI_CONF_SPACE.vendor_id],INTEL_VEND
 jne .quit ; Get out the device is definitely not and E1000 NIC
 ; Check to see if the DEVICE ID is equal to one of the E1000 NICs above, else quit.
 cmp word[r9+PCI_CONF_SPACE.device_id],E1000_DEV
 je .found
 cmp word[r9+PCI_CONF_SPACE.device_id],E1000_DEV1
 je .found
 cmp word[r9+PCI_CONF_SPACE.device_id],E1000_DEV2
 je .found
 cmp word[r9+PCI_CONF_SPACE.device_id],E1000_DEV3
 je .found
 cmp word[r9+PCI_CONF_SPACE.device_id],E1000_DEV4
 je .found
 jmp .quit
 .found: ; If we are here we have an NIC device, so let read its configuration data from the PCI header
 mov byte[e1000_flag],0x1 ; First set e1000_flag so we know we have it
 xor rax,rax
 mov al,byte[r9+PCI_CONF_SPACE.bar0] ; Check first bit of BAR0 which indicate
 and al,0x1 ; PORT/IO if set else MMIO
 mov [e1000_ioport_flag],al ; Set Port/IO flag if BAR0 bit-0 is set
 mov eax,[r9+PCI_CONF_SPACE.bar1] ; Read BAR1 as port number and clear first bit
 and eax,~0x1
 mov [e1000_io_base],ax
 xor rax,rax
 mov eax,[r9+PCI_CONF_SPACE.bar0] ; Read BAR0 and clear first 2 bits as MMIO base address
 and eax,~0x3
 mov [e1000_mem_base],rax
 xor rax,rax ; Get Interrupt Line and
 mov al,byte[r9+PCI_CONF_SPACE.int_line]
 or al,byte[r9+PCI_CONF_SPACE.int_pin] ; Get interrupt pin and or it with interrupt-line
 mov [e1000_int_no],al ; That is the IRQ number
 mov rsi,found_intel_e1000_msg ; Print a message indicating E1000 found
 call video_print
 mov al,[bus] ; Store the PCI bus/device/function
 mov [e1000_bus],al ; We will need them when we Bus-Master the device
 mov al,[device]
 mov [e1000_device],al
 mov al,[function]
 mov [e1000_function],al
 .quit:
 popaq
ret
;*****************************************************************************************************

e1000_init:
pushaq
cmp byte[e1000_flag],0x0 ; if flag is zero then NIC was not detected
   je .quit
mov rsi,e1000_configure_msg ; else print a message indicating the detection of an e1000 NIC
call video_print
call e1000_map_mem ; map the MMIO region to the page table

call e1000_init_mem ; initialize memory used for buffers and ring buffers

call e1000_bus_master ; enables the card to fire interrupts
call e1000_detect_eeprom ; detect the EEProm
cmp byte [e1000_eeprom_flag],0x1 ; Check if EEProm was detected
jne .quit                ; Exit if not detected
call e1000_read_mac_address ; from EEProm
call e1000_startlink ; Start the NIC Physical Link
call e1000_setup_interrupt_throttling ; Setup Interrupt Throttling: minimum rate of
; interrupt and buffering
call e1000_clear_multicast_table ; to receice packets from anywhere (no packet filtering)
call e1000_rx_init ; Configure Receive Ring-Buffer
call e1000_tx_init ; Configure Transmit Ring-Buffer
call e1000_enable_interrupts ; Enable Interrupts and Start Service Operations
.quit:
popaq
ret
;*******************************************************************************************

vaddress resq 1
paddress resq 1
section .data
e1000_map_mem:          ; this loop maps the vitual address to MMIO physical address
                        ; its done for 128 KB as per manual
pushaq
mov r9,0x0 ;counter
.loop:
mov rax,[e1000_vaddress] ; Virtual address
add rax,r9 ; Plus counter
mov [vaddress],rax ; Set vaddress -> parameter for map_page
mov rax,[e1000_mem_base] ; Physical MMIO adress
add rax,r9 ; Plus counter
mov [paddress],rax ; Set paddress -> parameter for map_page
;call page_walk ; Call map page
add r9,0x1000 ; Increment counter by 4KB
cmp r9,e1000_bar0_mem_size ; Check if we already mapped 128 KB
jl .loop ; Loop is we are not done yet
call reload_page_table ; Refresh page table
mov rsi,e1000_map_memio_msg ; Print a message indicating MMIP maping completed
call video_print
popaq
ret
reload_page_table:
pushaq
mov rdi, 0x100000
mov cr3, rdi
popaq
ret
;*****************************************************************************************

e1000_init_mem:     ; this builds the 2 rings buffers and initialize them
pushaq ; the current_memory_address stores the memory address after last page frame used
; in the page table during the page table build. It is very important that before
; we call this function all mapping should have already been done
add qword[current_memory_address],0x10000 ; just create a gap of 10 KB for safety
mov rax,[current_memory_address]
mov [e1000_rx_desc_ptr],rax ; Receive descriptors should start here
add rax,e1000_desc_array_size ; Advance 2048 x 16 Bytes = 8 KB
mov [e1000_tx_desc_ptr],rax ; Transmit descriptors should start here
add rax,e1000_desc_array_size ; Advance 2048 x 16 Bytes = 8 KB
mov [e1000_rx_packets_ptr],rax ; Receive packets should start here
add rax,e1000_packet_area_size ; Advance 2048 x 2048 Bytes = 4 MB
mov [e1000_tx_packets_ptr],rax ; Transmit packets should start here
add rax,e1000_packet_area_size ; Advance 2048 x 2048 Bytes = 4 MB
mov [e1000_recv_packet],rax ; Latest receive packet buffer should start here
add rax,e1000_packet_size ;Advance 2048 Bytes = 2 KB
mov [e1000_send_packet],rax ; Latest send packet buffer should start here
add rax,e1000_packet_size ; Advance 2048 Bytes = 2 KB
mov [current_memory_address],rax ; Update current_memory_address to start the
; address starting from which we can start
; allocating
; A loop to assign each receive descriptor address pointer to their corresponding
; packet buffer and initialize the status to 0x0
mov r8,[e1000_rx_desc_ptr]
mov r9,[e1000_rx_packets_ptr]
mov rcx,e1000_desc_array_count

.rx_loop:
mov [r8+e1000_rx_desc.addr],r9
mov byte[r8+e1000_rx_desc.status],0x0
add r8,e1000_desc_size
add r9,e1000_packet_size
dec rcx
cmp rcx,0x0
jg .rx_loop
; A loop to assign each transmit descriptor address pointer to their corresponding
; packet buffer and initialize the status to TSTA_DD (1 << 0) and cmd to 0x0
mov r8,[e1000_tx_desc_ptr]
mov r9,[e1000_tx_packets_ptr]
mov rcx,e1000_desc_array_count

.tx_loop:
mov [r8+e1000_tx_desc.addr],r9
mov byte[r8+e1000_tx_desc.cmd],0x0
mov byte[r8+e1000_tx_desc.status],TSTA_DD ; Descriptor Done
add r8,e1000_desc_size
add r9,e1000_packet_size
dec rcx
cmp rcx,0x0
jg .tx_loop
mov rsi,e1000_mem_init_msg
call video_print ; Print a message indicating the memory buffer reservation and setup has been done
popaq
ret
;*************************************************************************************************************
pci_bus_master: ; to tell the pci bus that a device can fire interrupts
 pushaq
 ; Load the current bus/device/function with offset 0x4 which is the Command register
 xor rbx,rbx ;((bus << 16)
 mov bl,[bus]
 shl ebx,16
 or eax,ebx
 xor rbx,rbx ;|(device << 11)
 mov bl,[device]
 shl ebx,11
 or eax,ebx
 xor rbx,rbx ;| (function << 8)
 mov bl,[function]
 shl ebx,8
 or eax,ebx
 or eax,0x80000000 ;| ( 0x80000000) as bit 31 needs to be 1
 mov rsi,0x4 ; offset 4
 or rax,rsi
 and al,0xfc ; This ensures the the last 2 bits are zeros
 mov rsi,start_bus_mastering_msg
 call video_print
 mov rdi,rax
 call video_print_hexa
 mov rsi,newline
 call video_print

 push rax ; Save the Config value for future use
 mov dx,CONFIG_ADDRESS ; Read the Command Register
 out dx,eax
 xor rax,rax
 mov dx,CONFIG_DATA
 in eax,dx
 mov rcx,rax ; Copy the current value of the command register
 or rcx,0x06 ; to enable bus-master to be able to fire interrupts, set the Bus-Master bits (2 and 3)
 pop rax ; Restore the Config value from the stack
 push rax ; Save the Config value for future use
 mov dx,CONFIG_ADDRESS ; Write the new Command register with Bus-Master Enabled
 out dx,eax
 mov dx,CONFIG_DATA
 mov rax,rcx
 out dx,eax
 pop rax ; Restore the Config value from the stack
 mov dx,CONFIG_ADDRESS ; Read the Command Register to verify it was written successfully
 out dx,eax
 xor rax,rax
 mov dx,CONFIG_DATA
 in eax,dx
 mov rdi,rax
 call video_print_hexa
 mov rsi,newline
 call video_print
 cmp rax,rcx ; Compare the intended Command register value with the stored one
 jne .quit
 mov rsi,bus_mastering_msg ; If Bus-Mastering is enabled print a message indicating that
 call video_print
 .quit:
 popaq
;***********************************************************************************************************
e1000_bus_master: ; this specifically bus master e1000 NIC
pushaq
; Reload saved bus/device/function during the PCI scan
mov al,[e1000_bus]
mov [bus],al
mov al,[e1000_device]
mov [device],al
mov al,[e1000_function]
mov [function],al
call pci_bus_master ; Do the bus mastering by calling pci_bus_master
popaq
ret
;**********************************************************************************

e1000_read_command: ; This routine reads a value from the card address space
                    ; designed to work with both MMIO (virtual address) and IOports(in command)based on the flag
pushaq
cmp byte[e1000_ioport_flag],0x1 ; Check if card is PortIO based
je .use_ports ; If not use MMIO
xor rax,rax
mov ax,word[e1000_rw_address] ; Use e1000_vaddress as the base addres
add rax,[e1000_vaddress] ; and use e1000_rw_address as offset
xor rbx,rbx
mov ebx,[rax]
mov [e1000_rw_data],ebx ; read into e1000_rw_data from the MMIO address
jmp .quit
.use_ports:
mov dx,[e1000_io_base] ; Use e1000_io_base to write the address
add ax,[e1000_rw_address] ; you want to read from
out dx,eax
mov dx,[e1000_io_base+0x4] ; read value ofrom port address e1000_io_base+0x4
in eax,dx ; to e1000_rw_data
add [e1000_rw_data],eax
.quit:
popaq
ret
;**************************************************************
e1000_write_command: ; This routine writes a value to the card address space
 pushaq
 cmp byte[e1000_ioport_flag],0x1 ; Check if card is PortIO based
 je .use_ports ; If not use MMIO
 xor rax,rax
 mov ax,word[e1000_rw_address] ; Use e1000_vaddress as the base address if the card is MMIO
 add rax,[e1000_vaddress] ; and use e1000_rw_address as offset
 xor rbx,rbx
 mov ebx,[e1000_rw_data] ; write e1000_rw_data to the MMIO address
 mov [rax],ebx
 jmp .quit
 .use_ports: ; then use out command to write
 mov dx,[e1000_io_base] ; Use e1000_io_base to write the address
 add ax,[e1000_rw_address] ; you want to write to
 out dx,eax
 mov dx,[e1000_io_base+0x4] ; write the value of e1000_rw_data to e1000_io_base+0x4
 add eax,[e1000_rw_data]
 out dx,eax
 .quit:
 popaq
ret
;*************************************************
e1000_detect_eeprom:
pushaq
mov word[e1000_rw_address],REG_EEPROM ; Write the value 0x1 to the EEPROM register
mov dword[e1000_rw_data],0x1
call e1000_write_command
mov rcx,0xFFFFFFFF ; loop this number of time until 0x1 is written in EEPROM register (bit 5)
.loop: ; Loop to read from the EERPOM REG until it has the value 0x10
cmp rcx,0x0 ; The loop will keep on retrying until rcx hits 0x0 or the
je .no_eprom ; EEPROM REG contains 0x10
mov word[e1000_rw_address],REG_EEPROM
call e1000_read_command
xor rdi,rdi
mov edi,dword[e1000_rw_data]
and rdi,0x10
cmp rdi,0x10
dec rcx
jne .loop
mov rsi,e1000_eeprom_detected_msg ; If we are here we have an EEPROM
call video_print
mov byte [e1000_eeprom_flag],0x1
jmp .quit
.no_eprom:
mov byte [e1000_eeprom_flag],0x0 ; No EEPROM detected
.quit:
popaq
ret
;*************************************************************
                                            ; eeprom read register is like an internal memory to read from
                                            ; used to read the mac address
                                            ; keep reading until bit 5 is found equal to 1
e1000_eeprom_read: ; The eeprom registers are 16 byte wide
 pushaq ; The eeprom reads double word: the lower one is the status and
 ; the higher one os the register value
 xor rax,rax
 mov al,[e1000_eeprom_addr] ;Read from e1000_eeprom_addr
 shl eax,0x8 ; Multiply by 16
 or eax,0x1 ; Store 1 in the right most bit (bit-0)
 mov word[e1000_rw_address],REG_EEPROM
 mov dword[e1000_rw_data],eax ; Use REG_EEPROM as the base address and e1000_rw_data
 call e1000_write_command ; as the offset
 .loop:
 mov word[e1000_rw_address],REG_EEPROM
 call e1000_read_command ; Read from the EEPROM registers
 xor rdi,rdi
 mov edi,dword[e1000_rw_data] ; Store read value in e1000_rw_data into edi
 and rdi, (1 << 4) ; Extract bit 5 if 0x1 we are done
 cmp rdi,0x0 ; else try again
 je .loop
 xor rdi,rdi
 mov edi,dword[e1000_rw_data]
 shr edi,16
 and edi,0xFFFF
 mov dword[e1000_rw_data],edi ; Store high word in e1000_rw_data
 popaq
ret
;*************************************************************************
; We want to read 6-octets(stored in 3 eeprom reg, each 1 has 2-octets)from e1000_eeprom_addr into
; then store the values in eeprom mac address buffer defined before
e1000_read_mac_address:
pushaq
mov r9,0x0 ; Register Index; each register contains 2 octets
mov r10,0x0 ; Memory index to store the mac octet
.loop:
mov byte[e1000_eeprom_addr],r9b ; Read register 0x0
call e1000_eeprom_read
xor rdi,rdi
mov edi,dword[e1000_rw_data]
and edi,0xff ; Extract the first byte
mov [e1000_mac_address+r10],dil ; Store it in e1000_mac_address
inc r10 ; Advance r10 to point to the next byte in
xor rdi,rdi ; e1000_mac_address
mov edi,dword[e1000_rw_data]
shr edi,0x8 ; Shift 0x8 to get the next byte in the
and edi,0xff ; low register and mask the rest
mov [e1000_mac_address+r10],dil ; Store it in e1000_mac_address
inc r10 ; Advance r10 to point to the next byte in
inc r9 ; e1000_mac_address and advance r9 to point
cmp r9,0x3 ; to the next register
jne .loop ; loop if we did not read three 2-octets yet
call e1000_print_mac_address ; We call print mac address after we finish
popaq
ret

e1000_print_mac_address:
pushaq
mov byte[hexa_pad],0x2 ; This is used by video_print_hexa to define the number of
; digits to process, we set it to 0x2 because an octet
; is maximum of 2 hexa digits
mov r9,0x0 ; Index to loop over all octets
.loop:
xor rdi,rdi
mov dil,byte[e1000_mac_address+r9]
call video_print_hexa ; Print octet
inc r9
cmp r9,0x6
je .skip_colon ; If not the last octet print ':'
mov rsi,colon
call video_print
.skip_colon:
cmp r9,0x6 ; If last octet get out else loop
jl .loop
mov byte[hexa_pad],0x10 ; reset hexa_pad to its default
mov rsi,newline ; print a new line
call video_print
popaq
ret
;***********************************************************************************************
e1000_startlink:
pushaq
mov word[e1000_rw_address],REG_CTRL ; Read the value on the control register
call e1000_read_command
xor rax,rax
mov eax,dword[e1000_rw_data]
or eax, ECTRL_SLU | ECTRL_ASDE | ECTRL_FD | ECTRL_100M| ECTRL_FRCSPD
; Set Link Up, Auto Speed Enabled, Full Duplex, Set Speed to 100 Mb/sec, Force Speed
mov dword[e1000_rw_data],eax
call e1000_write_command
xor rax,rax ; Disable Flow control by writing 0x0 to all registers, to enable auto-negotiation
                            ; this means teh card can auto-initiate the speed
mov dword[e1000_rw_data],eax
mov word[e1000_rw_address],FCAL
call e1000_write_command
mov word[e1000_rw_address],FCAH
call e1000_write_command
mov word[e1000_rw_address],FCT
call e1000_write_command
mov word[e1000_rw_address],FCTT
call e1000_write_command
mov word[e1000_rw_address],REG_STATUS
call e1000_read_command
xor rdi,rdi ; Read Status register and print it.
mov edi,dword[e1000_rw_data]
call video_print_hexa
mov rsi,newline
call video_print
; print a msg indicating the link is up. Assume that everything went well for the sake of demonstration
; but in reality you need to check that everything went well !
mov rsi,e1000_start_up_link_msg
call video_print
popaq
ret
;*********************************************************************************
; Throttling interval is defined in 256 ns.
; Interrupts/seconds = (256x10-9 x interval)-1 nanoseconds
; We use here interval = 4
; 1000000000/(256*4)
e1000_setup_interrupt_throttling:      ; basically caching the interrupts to have a better performance
; this fires an interrupt for each group of packets by limitting the number of interrupts per second
  pushaq
  mov rax,0x3B9ACA00 ; 10^9
  shr rax,10 ; 256*4 = 1024 = 2^10
  mov dword[e1000_rw_data],eax
  mov word[e1000_rw_address],THROT ; Write to Throttling address
  call e1000_write_command
  mov rsi,e1000_setup_throttling_msg ; Print a message for
  ; Throttling setting
  call video_print
  popaq
ret
;********************************************************************************
e1000_clear_multicast_table:
 pushaq
 mov rcx,0x80 ; 0x80 = 128, act as a counter for MTA Table entries
 mov r9,MULTICAST_VT ; Location of the multicast buffer 0x5200
  .loop:
  mov dword[e1000_rw_data],0x0 ; Store 0x0
  mov word[e1000_rw_address],r9w
  call e1000_write_command
  add r9,0x4 ; Increment register index by 0x4
  dec rcx ; Decrement counter

  cmp rcx,0x0 ; check counter
  jne .loop
mov rsi,e1000_multicast_vt_msg ; Print a message
  call video_print
 popaq
ret
;*********************************************************************************
e1000_rx_init: ; here we need to configure the header, tail, length, and the address of the buffer
; We assume here identity memory mapping, or else we need to use v2p
 pushaq
mov rax,[e1000_rx_desc_ptr] ; Set the low 32-bits of the Ring Buffer
  mov word[e1000_rw_address],REG_RXDESCLO ; address to the memory area we already
  mov dword[e1000_rw_data],eax ;
  call e1000_write_command
  xor rax,rax ; As we know that the address we are using
  mov word[e1000_rw_address],REG_RXDESCHI ; is less than 4GB so we store in the higher
  mov dword[e1000_rw_data],eax ; 32 bits 0x0
  call e1000_write_command
  mov rax,e1000_desc_array_size ; Set the size of the ring buffer
  mov word[e1000_rw_address],REG_RXDESCLEN
  mov dword[e1000_rw_data],eax
  call e1000_write_command
  xor rax,rax ;Set the index of the head pointer
  mov word[e1000_rw_address],REG_RXDESCHEAD
  mov dword[e1000_rw_data],eax
  call e1000_write_command
  xor rax,e1000_desc_array_count-1 ; Set the index of the tail
  mov word[e1000_rw_address],REG_RXDESCTAIL
  mov dword[e1000_rw_data],eax
  call e1000_write_command
  mov rax, RCTL_EN| RCTL_UPE | RCTL_MPE | RCTL_LBM_NONE | RTCL_RDMTS_HALF | RCTL_BAM | RCTL_SECRC|RCTL_BSIZE_16384
  ; Enable Recv, Enable Unicast Promiscuous md, Enable Multicast Promiscuous md, No loopback, Bcast mode, Strip Eth CRC
  mov word[e1000_rw_address],REG_RCTRL ; move all of the collected values into the receive control reg
  mov dword[e1000_rw_data],eax
  call e1000_write_command
  mov rsi,e1000_rx_init_msg
  call video_print
 popaq
ret
;*******************************************************************************************************
e1000_tx_init:  ; same as receving the buffer, but filling ratehr than reading
; We assume here identity memory mapping, or else we need to use v2p
 pushaq
  mov rax,[e1000_tx_desc_ptr] ; Set the low 32-bits of the Ring Buffer
  mov word[e1000_rw_address],REG_TXDESCLO ; address to the memory area we already
  mov dword[e1000_rw_data],eax ; reserved in e1000_init_mem
  call e1000_write_command
  xor rax,rax ; As we know that the address we are using
  mov word[e1000_rw_address],REG_TXDESCHI ; is less than 4GB so we store in the higher
  mov dword[e1000_rw_data],eax ; 32 bits 0x0
  call e1000_write_command
  mov rax,e1000_desc_array_size
  mov word[e1000_rw_address],REG_TXDESCLEN ; Set the size of the ring buffer
  mov dword[e1000_rw_data],eax
  call e1000_write_command
  xor rax,rax
  mov word[e1000_rw_address],REG_TXDESCHEAD ; Set teh index of the head pointer
  mov dword[e1000_rw_data],eax
  call e1000_write_command
  xor rax,rax
  mov word[e1000_rw_address],REG_TXDESCTAIL ; Set the index of the tail
  mov dword[e1000_rw_data],eax
  call e1000_write_command
mov rax,TCTL_EN | TCTL_PSP | (0xF << TCTL_CT_SHIFT) | (0x3F << TCTL_COLD_SHIFT) | TCTL_SWXOFF |TCTL_RTLC
  ; Enable Transmission, Pad short packets, Collision Threshold, Collision Distance, SW XOFF
  ; Transmission, Retransmit on Late Collision
  mov word[e1000_rw_address],REG_TCTRL
  mov dword[e1000_rw_data],eax
  call e1000_write_command
  ; Configure Inter Packet Gap Timer
  mov rax,0x00602006
  mov word[e1000_rw_address],REG_TIPG
  mov dword[e1000_rw_data],eax
  call e1000_write_command
  ; Print a message
  mov rsi,e1000_tx_init_msg
call video_print
popaq
ret
;*************************************************************************************************

e1000_enable_interrupts:
 pushaq
  xor rdi,rdi
  mov dil,[e1000_int_no]
  add rdi,32      ;32 is the start of pic
  mov rsi, e1000_int_handler ; register interrupt handler e1000_int_handler
  call register_idt_handler ; at e1000_int_no+32
  xor rdi,rdi
  mov dil,[e1000_int_no]
  call clear_irq_mask ; Clear PIC interrupt mask for e1000_int_no
  mov rax,0x1F6DC ; A bit array for interrupt masks
  mov word[e1000_rw_address],REG_IMASK
  mov dword[e1000_rw_data],eax
  call e1000_write_command
  ; Read status and print it
  mov word[e1000_rw_address],REG_ICR
  call e1000_read_command
  xor rdi,rdi
  mov edi,dword[e1000_rw_data]
  call video_print_hexa
  mov rsi,newline
  call video_print
  ; print a message
  mov rsi,e1000_enable_interrupt_msg
  call video_print
  popaq
ret
;***************************************************************************


e1000_send_out_packet:
pushaq
xor r11,r11 ; store e1000_tx_cur in r11 and multiply the value by 16
mov r11w,word[e1000_tx_cur]
shl r11,0x4
xor r9,r9 ; Store e1000_tx_desc_ptr (Ring Base address) into r9
mov r9,[e1000_tx_desc_ptr]
add r9,r11 ; Add e1000_tx_cur which is the current Ring Buffer index
mov rcx,e1000_packet_size ; Get Packet size and store in rcx (Counter Register)
cld
mov rsi,[e1000_send_packet] ; copy the packet into the ring buffer
mov rdi,[r9+e1000_tx_desc.addr]
rep movsb
mov byte[r9+e1000_tx_desc.status],0x0 ; Set status to 0x0 so the card can reset it
; when packet is sent
mov byte[r9+e1000_tx_desc.cmd],CMD_EOP | CMD_IFCS | CMD_RS | CMD_RPS

mov bx,[e1000_send_packet_len] ; Store the length into the ring buffer descriptor
mov [r9+e1000_tx_desc.length],bx
inc word[e1000_tx_cur] ; Advance e1000_tx_cur and reset it to the
cmp word[e1000_tx_cur],0x800 ; beginning of the ring buffer in case
jl .skip_mod ; end of buffer is reached
mov dword[e1000_tx_cur],0x0
.skip_mod:
mov word[e1000_rw_address],REG_TXDESCTAIL ; Update the tail with e1000_tx_cur
mov r8d,[e1000_tx_cur]
mov [e1000_rw_data],r8d
call e1000_write_command
.loop: ; Loop until status not equal to zero
cmp byte[r9+e1000_tx_desc.status],0x0
je .loop
mov rsi,e1000_sent_packet_msg ; print a message
call video_print
.quit:
popaq
ret
;********************************************************************

e1000_int_handler: ; This is the entry point when an interrupt is invoked
pushaq
mov word[e1000_rw_address],REG_ICR ; Read the status register
call e1000_read_command
xor rax,rax
mov eax,dword[e1000_rw_data]
and eax,0x04
cmp eax,0x04 ; Check status bit 3
jne .skip_link_started
mov rsi,e1000_link_restarted_int_msg ; If set then link is restarted
call video_print
jmp .out
.skip_link_started:
mov eax,dword[e1000_rw_data]
and eax,0x10 ; Else check bit 5
cmp eax,0x10
jne .skip_good_threshold ; If set then the packets are arriving
mov rsi,e1000_good_threshold_int_msg ; at a relatively high rate
call video_print
jmp .out
.skip_good_threshold:
mov eax,dword[e1000_rw_data]
and eax,0x80
cmp eax,0x80 ; Else check bit 7
jne .skip_process_packet
mov rsi,e1000_process_packet_int_msg ; Packet received and should be processed
call video_print
call e1000_process_packet ; Call process packet which will call the stack
jmp .out
.skip_process_packet: ; Else exit
.out:
popaq
ret
;******************************************************************************

e1000_process_packet:
pushaq
mov word[e1000_rw_address],REG_RXDESCHEAD ; Fetch the Receive Ring Buffer Head pointer
call e1000_read_command
xor r8,r8
mov r8d,[e1000_rw_data]
cmp r8w,[e1000_rx_cur] ; Compare it with the e1000_rx_cur
je .quit ; If they are equal nothing to process
.loop: ; Else we are going to start polling until
; to process all network packets arrived since
; the last previous interrupt
xor r8,r8
mov r8w,[e1000_rx_cur] ; Store e1000_rx_cur into r8
shl r8,0x4 ; Multiply r8 by descriptor size: 16 bytes
xor r9,r9
mov r9,[e1000_rx_desc_ptr] ; Store the descriptor buffer base into r9
add r9,r8 ; Add to it the e1000_rx_cur x 16 offset
xor rax,rax ; to point to the correct descriptor
mov al,byte[r9+e1000_rx_desc.status] ; fetch the status
and al,0x1
cmp al,0x1
jne .update_tail ; if status does not have bit-0 set then we
; are done and we should exit the loop and
; update the tail of the ring buffer
mov rcx,e1000_packet_size ; else copy the packet to the temp packet area
shr rcx,8
cld
mov rsi,[r9+e1000_rx_desc.addr]
mov rdi,[e1000_recv_packet]
rep movsq
mov bx,[r9+e1000_rx_desc.length] ; Fetch the packet length into the variable
mov [e1000_recv_packet_len],bx ; e1000_recv_packet_len
call network_stack ; Call the network_stack routine to start
mov byte[r9+e1000_rx_desc.status],0x0 ; processing the received packet
inc word[e1000_rx_cur] ; Advance e1000_rx_cur
cmp word[e1000_rx_cur],0x800 ; Wrap it around if we hit the end of the
jl .skip_mod ; ring buffer
mov dword[e1000_rx_cur],0x0
.skip_mod:
jmp .loop ; Check the next descriptor of the ring buffer
.update_tail: ; Update the tail of the ring buffer by writing
;it
mov word[e1000_rw_address],REG_RXDESCTAIL ; into the NIC
mov r8d,[e1000_rx_cur]
mov [e1000_rw_data],r8d
call e1000_write_command
.quit:
popaq
ret

network_stack:
pushaq
xor rdi,rdi ; Extract the type field from the ethernet header
mov di,[r9+ethernet_packet.h_type]
rol di,0x8 ;8 bits ; Perform network to host conversion (NTOH) (from big-endian to little-endian)
                    ; take lower 2 bytes and put higher 2 bytes in their place
cmp di,ETHERTYPE_ARP ; Check if the payload contains an ARP Packet
jne .skip_arp
call process_arp ; Call process_arp to process the ARP packet
jmp .quit
.skip_arp:
cmp di,ETHERTYPE_IP ; Check if the payload contains an IP Packet
jne .quit
; call process_ip ; Call process_ip to process the IP packet
.quit:
popaq
ret


process_arp:
pushaq
mov r9,[e1000_recv_packet] ; Extract the ARP operation from the ARP header
mov ax,word [r9+arp_packet.ar_op]
rol ax,0x8 ; Perform a network to host conversion (NTOH) (from big to little endian)
cmp ax,ARPOP_REQUEST ; If it is not an ARP request get out
jne .quit
mov ax,word [r9+arp_packet.ar_hwt] ; Extract HW Type from the ARP Header
rol ax,0x8 ; Perform a network to host conversion (NTOH)
cmp ax,ARPHRD_ETHER ; If it is not Ethernet get out
jne .quit
xor r8,r8
xor rbx,rbx
mov r8d,dword[r9+arp_packet.target_proto_addr] ; Extract IP address from the ARP packet header
mov ebx,dword[my_ip_address]
cmp r8,rbx ; Compare with my own IP address
jne .quit ; If not equal get out, else send ARP reply
mov rsi,my_ip_msg
call video_print
; Store addresses of Send/Recv packet buffers into r9 and r8
mov r8,[e1000_recv_packet]
mov r9,[e1000_send_packet]
; Copy the source of the Recv buffer into the dest of the Send buffer
lea rsi,[r8+ethernet_packet.h_src]
lea rdi,[r9+ethernet_packet.h_dest]
mov rcx,0x6
cld
rep movsb
lea rsi,[e1000_mac_address]
lea rdi,[r9+ethernet_packet.h_src]
mov rcx,0x6
cld
rep movsb
; Copy the ARP type from Recv to Send buffer
xor rax,rax
mov ax,[r8+ethernet_packet.h_type]
mov [r9+ethernet_packet.h_type],ax
; Set the ARP operation field in the Send buffer to ARPOP_REPLY
mov ax, ARPOP_REPLY
rol ax,0x8 ; Apply HTON (Host to Network)
mov [r9+arp_packet.ar_op],ax
mov word[r9+arp_packet.ar_hwt],ARPHRD_ETHER ; Set Hardware Type
mov word[r9+arp_packet.ar_pro],ETHERTYPE_IP ; Set Network Protocol Type
mov byte[r9+arp_packet.ar_hln],0x6 ; Set Hardware Address length (ETHER MAC)
mov byte[r9+arp_packet.ar_pln],0x4 ; Set Protocol Address length (IPv4)
; Copy the sender HW address from the Receive Packet to the sender target HW address
lea rsi,[r8+arp_packet.sender_hw_addr]
lea rdi,[r9+arp_packet.target_hw_addr]
mov rcx,0x6
cld
rep movsb
lea rsi,[e1000_mac_address]
lea rdi,[r9+arp_packet.sender_hw_addr]
mov rcx,0x6
cld
rep movsb
; Store sender IP of the receive buffer into the target IP of the sender buffer
mov eax,[r8+arp_packet.sender_proto_addr]
mov [r9+arp_packet.target_proto_addr],eax
; Store target IP of the receive buffer into the sender IP of the sender buffer
mov eax,[r8+arp_packet.target_proto_addr]
mov [r9+arp_packet.sender_proto_addr],eax
; Copy the length of the Receive Buffer into sender
mov bx,[e1000_recv_packet_len]
mov [e1000_send_packet_len],bx
; Call e1000_send_out_packet to store the packet in the NIC send ring buffer and fire it out
call e1000_send_out_packet
.quit:
popaq
ret



;process_ip:
;pushaq
; mov r9b, [ip_hdr.protocol]
 ;   cmp r9b, IP_PACKET_TYPE_TCP      ; check if protocol type is TCP
  ;  je .quit    
   ; cmp r9b, IP_PACKET_TYPE_UDP      ; check if protocol type is UDP
    ;je .quit
                                    ; else it is ICMP so process further
   ; mov r8b, [ip_icmp_echo.type]    ; check type
    ;cmp r8b, ICMP_ECHO              ; if it's not echo quit else proces further
    ;jne .quit
    ;rol r8b,0x8                     ; apply HTON (Host to Network)
;Check Sum
	;mov r10, [ip_hdr.ihlv]
	;add r10, [ip_hdr.tos]
	;add r10, [ip_hdr.tot_len]
	;add r10, [ip_hdr.id]
	;add r10, [ip_hdr.flgs]
	;add r10, [ip_hdr.frag]
	;ad r10, [ip_hdr.ttl]
	;add r10, [ip_hdr.protocol]
	;add r10, [ip_hdr.saddr]
	;add r10, [ip_hdr.daddr]
	;mov r11, r10
	;and r11, 0x3C000
	;shr r11, 0x10
	;add r10, r11
	;Now r10 contains checksum + carry
	;let's check if there is carry not
	;mov 11, r10	
	;and r11, 0x3C000
	;cmp r11, 0
	;jne carry:
	;jmp else
	;carry:
		;add r10, 1
	;else:
		
	;mov r12, 1
	;xor r10, r12
	;mov [ip_hdr.chesk], r10	
;.quit:
;popaq
;ret

