%define VIDEO_BUFFER_SEGMENT                    0xB000
%define VIDEO_BUFFER_OFFSET                     0x8000
%define VIDEO_BUFFER_EFFECTIVE_ADDRESS          0xB8000
%define VIDEO_SIZE      0X0FA0    ; 25*80*2
    video_cls_16:
    pusha                                   ; Save all general purpose registers on the stack

    mov eax, 0x0                ;counter for loop
    mov ecx, VIDEO_SIZE
    mov ebx, VIDEO_BUFFER_EFFECTIVE_ADDRESS
    loop:
    mov byte[ebx],' '     ;store the space character into current video location
    inc ebx                ;Increment current video location
    inc eax                 ;increment counter
    mov byte[ebx],0x00   ; Store Black Background
    inc ebx                 ;Increment current video location
    inc eax                 ;increment counter
    cmp eax, ecx        ; if counter reached video size return
    jne loop

     popa                                ; Restore all general purpose registers from the stack
     ret
