; Tell the assembler that we use the 16-bit mode
BITS 16

;Loads it at the corresponding address
ORG 0x7C00

start:
    xor ax,ax   ; smaller machine code,faster
    mov ds,ax   ; ds - data segment register
    mov es,ax   ; es - extra segment - setting both to zero to ensure predictability of output(testing purpose)

    mov si,message  ; si - source index register , address is stored with the label message

print:
    lodsb   ; load byte at address range from DS to SI into AL and increment SI
    cmp al,0
    je done

    mov ah, 0x0E   ; BIOS teletype function
    mov bh, 0x00   ; hb - page number
    mov bl, 0x07   ; White Text
    int 0x10        ; Call BIOS video interrupt

    jmp print

done:
    cli
    hlt

message db "Hello from my OS!!!!", 0

; Fill remaining spaces to 510 bytes
times 510-($-$$) db 0

;BOOT SIGNATURE
dw 0x0AA55