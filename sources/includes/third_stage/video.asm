video_print_hexa:  ; A routine to print a 16-bit value stored in di in hexa decimal (4 hexa digits)
pushaq
mov rbx,0x0B8000          ;starting address of the video RAM
;mov es,bx              
    add bx,[start_location] ; move the start location for printing in BX
    mov rcx,0x10                                ; loop counter of 16 one for each digit
    ;mov rbx,rdi                                
    .loop:                                    ; loop on all 4 digits
            mov rsi,rdi                          
            shr rsi,0x3C                          ; shift 60 bits right
            mov al,[hexa_digits+rsi]             ; get the right hexadcimal digit from the array          
       .check_to_scroll_hexa:

            cmp rbx, 0xB8FA0         ; if rbx reached the end of the screen (bottom right) 0xB8000+0x0FA0 (0xB8000+2*80*25)
            je .scroll_hexa
       .continue_print_hexa:    
            mov byte [rbx],al     ; store the charcater into current video location
            inc rbx                ; Increment current video location
            mov byte [rbx],1Fh    ; set Blue Background
            inc rbx                

            shl rdi,0x4                          ; Shift bx 4 bits left so the next digits is in the right place to be processed
            dec rcx                              ; decrement loop counter
            cmp rcx,0x0                          ; compare loop counter with zero.
            jg .loop                            ; Loop again we did not yet finish the 4 digits
.scroll_hexa:
    ;mov rsi, hello_world_str
   ; call video_print
   
    mov rbx, 0xB80A0    ; from-line
    mov rax, 0xB8000    ; to-line
    mov rdx, 0x0        ;counter
    .copy_up_hexa:  
    mov r8, qword[rbx]
    mov qword[rax], r8
    add rbx, 0x8        ; advance to the next qword
    add rax, 0x8
    inc rdx
    cmp rdx, 0x1E0       ;480  ;20*8 = 160 bytes --> content of 1 line
                         ;20*24=480 times (for 24 lines)
    jl .copy_up_hexa
    mov rdx, 0x0           ;reset counter
    mov rbx,0xB8F00      ;beginning of last line down (0xB8000+24*160)
    .clear_last_line_hexa:
        mov byte[rbx], ' '
        inc rbx
        mov byte[rbx], 0x0
        inc rbx
        inc rdx
        cmp rdx, 0xA0   ;80 characters
        jne clear_last_line
        mov rbx,0xB8F00         ;prepare to write in the last line
        jmp .continue_print_hexa
    add [start_location],word 0x20
    popaq
    ret
;*******************************************************************************************************************

video_print:
    pushaq
    mov rbx,0x0B8000          ; start of the video RAM
    ;mov es,bx               ; Set ES to the start of teh video RAM
    add bx,[start_location] ; move the start location for printing in BX
    xor rcx,rcx             ; counter
video_print_loop:           ; Loop for a character by charcater processing
    lodsb                   ; Load character pointed to by SI into al
    cmp al,13               ; Check  new line character to stop printing
    je out_video_print_loop
    cmp al,0                
    je out_video_print_loop1 ; If so get out    
check_to_scroll:
    cmp rbx, 0xB8FA0         ; if rbx reached the end of the screen (bottom right) 0xB8000+0x0FA0 (0xB8000+2*80*25)
    je scroll
    cont_printing:  
    mov byte [rbx],al     ; Else Store the charcater into current video location
    inc rbx                ; Increment current video location
    mov byte [rbx],1Fh    ; Store Blue Backgroun, Yellow font color
    inc rbx                ; Increment current video location
                            ; Each position on the screen is represented by 2 bytes
                            ; The first byte stores the ascii code of the character
                            ; and the second one stores the color attributes
                            ; Foreground and background colors (16 colors) stores in the
                            ; lower and higher 4-bits
    inc rcx
    inc rcx
    jmp video_print_loop    ; Loop to print next character
out_video_print_loop:
    xor rax,rax
    mov ax,[start_location] ; Store the start location for printing in AX
    mov r8,160
    xor rdx,rdx
    add ax,0xA0             ; Add a line to the value of start location (80 x 2 bytes)
    div r8
    xor rdx,rdx
    mul r8
    mov [start_location],ax
    jmp finish_video_print_loop
out_video_print_loop1:
    mov ax,[start_location] ; Store the start location for printing in AX
    add ax,cx             ; Add a line to the value of start location (80 x 2 bytes)
    mov [start_location],ax
    jmp finish_video_print_loop
scroll:
    mov rbx, 0xB80A0    ; from-line
    mov rax, 0xB8000    ; to-line
    mov rdx, 0x0        ;counter
    copy_up:  
    mov r8, qword[rbx]
    mov qword[rax], r8
    add rbx, 0x8        ; advance to the next qword
    add rax, 0x8
    inc rdx
    cmp rdx, 0x1E0       ;480  ;20*8 = 160 bytes --> content of 1 line
                         ;20*24=480 times (for 24 lines)
    jl copy_up
    mov rdx, 0x0           ;reset counter
    mov rbx,0xB8F00      ;beginning of last line down (0xB8000+24*160)
    clear_last_line:
        mov byte[rbx], ' '
        inc rbx
        mov byte[rbx], 0x0
        inc rbx
        inc rdx
        cmp rdx, 0xA0   ;80 characters
        jne clear_last_line
        mov rbx,0xB8F00         ;prepare to write in the last line
        jmp cont_printing
finish_video_print_loop:
    popaq
ret
 
clear_screen:
    pushaq                                   ; Save all general purpose registers on the stack
    mov rax, 0x0                ;counter for loop
    mov rcx, 0X0FA0             ; 25*80*2
    mov rbx,  0xB8000           ; MMIO effective address
    clear_screen_loop:
    mov byte[rbx],' '     ;store the space character into current video location
    inc rbx                ;Increment current video location
    inc rax                 ;increment counter
    mov byte[rbx],0x00   ; Store Black Background
    inc rbx                 ;Increment current video location
    inc rax                 ;increment counter
    cmp rax, rcx        ; if counter reached video size return
    jne clear_screen_loop

;the idea of this code is guided by this article
; https://wiki.osdev.org/Text_Mode_Cursor#Moving_the_Cursor_2
reset_cursor:
; input bx = x, ax = y
; modifies ax, bx, dx
 
mov dl, 0x50    ;80 decimal
mul dl
add bx, ax

; input bx = cursor offset
; modifies al, dx
 
mov dx, 0x03D4
mov al, 0x0F        ; starting position
out dx, al          ; write to port
 
inc dl
mov al, bl
out dx, al            ; writing to port 0x3D5
 
dec dl
mov al, 0x0E        ; starting position
out dx, al          ; writing to port
 
inc dl
mov al, bh
out dx, al
     popaq                                ; Restore all general purpose registers from the stack
     ret
