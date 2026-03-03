; Tell the assembler that we use the 16-bit mode
BITS 16

;Loads it at the corresponding address
ORG 0x7C00

start:
    xor ax,ax   ; smaller machine code,faster
    mov ds,ax   ; ds - data segment register
    mov es,ax   ; es - extra segment - setting both to zero to ensure predictability of output(testing purpose)

;    mov si,message  ; si - source index register , address is stored with the label message

main_loop:
    call print_prompt
    call read_input
    call process_command
    jmp main_loop

; -------------------
; PRINT
; -------------------
print_prompt:
    mov si, prompt
    call print_string
    ret

; -------------------
; READ INPUT
; -------------------
read_input:
    mov di,buffer

.read:
    mov ah, 0x00
    int 0x16    ; wait for keypress

    cmp al,13   ; Enter key?
    je .done

    mov ah, 0x0E
    int 0x10   ; echo charater

    stosb       ; store in buffer
    jmp .read

.done:
    mov byte [di], 0 ; null terminate
    ret

; -------------------
; PROCESS COMMAND
; -------------------

process_command:
    mov si,buffer
    mov di, cmd_hello
    call strcmp
    cmp ax,0
    je do_hello

    mov si,buffer
    mov di, cmd_cls
    call strcmp
    cmp ax, 0
    je do_cls

    ret

do_hello:
    mov si, msg_hello
    call print_string
    ret

do_cls:
    mov ax, 0x0003
    int 0x10    ; clear screen
    ret

; ------------------
; STRING PRINT
; ------------------

print_string:
.next:
    lodsb
    cmp al, 0
    je .done
    mov ah, 0x0E
    int 0x10
    jmp .next
.done:
    ret

; ------------------
; STRING COMPARE
; ------------------
strcmp:
.compare:
    lodsb
    mov bl, [di]
    inc di
    cmp al,bl
    jne .not_equal
    cmp al,0
    je .equal
    jmp .compare

.equal:
    xor ax,ax
    ret
.not_equal:
    mov ax,1
    ret

;-----------------
; DATA
;-----------------

prompt db 13,10,"C:\> ",0
msg_hello db 13,10,"Hello from Ymir DOS!",13,10,0

cmd_hello db "El psy congroo",0
cmd_cls db "cls",0

buffer times 32 db 0
times 510-($-$$) db 0
dw 0xAA55

;print:
;    lodsb   ; load byte at address range from DS to SI into AL and increment SI
;    cmp al,0
;    je done
;
;    mov ah, 0x0E   ; BIOS teletype function
;    mov bh, 0x00   ; hb - page number
;    mov bl, 0x07   ; White Text
;    int 0x10        ; Call BIOS video interrupt
;
;    jmp print

;done:
;    cli
;    hlt

;message db "Hello from my OS!!!!", 0

; Fill remaining spaces to 510 bytes
;times 510-($-$$) db 0

;BOOT SIGNATURE
;dw 0x0AA55