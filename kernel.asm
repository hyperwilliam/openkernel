; Basic kernel that prints a message and halts
org 0x7C00      ; BIOS loads bootloader at this address
bits 16         ; We start in 16-bit real mode

start:
    ; Set up segments and stack
    xor ax, ax  ; Zero AX register
    mov ds, ax  ; Set DS=0
    mov es, ax  ; Set ES=0
    mov ss, ax  ; Set SS=0
    mov sp, 0x7C00  ; Set stack just below bootloader

    ; Print message
    mov si, msg     ; Load message address
    call print_str  ; Call print routine
    
    ; Halt system
    cli            ; Clear interrupts
    hlt            ; Halt the system
    jmp $          ; Infinite loop in case of interrupt

; Print string routine
print_str:
    lodsb          ; Load byte from SI into AL
    or al, al      ; Check if byte is 0 (string end)
    jz done        ; If zero, we're done
    mov ah, 0x0E   ; TTY output function
    mov bx, 0x07   ; Page 0, light gray color
    int 0x10       ; Call BIOS video interrupt
    jmp print_str  ; Repeat for next character
done:
    ret

; Data
msg db 'Hello from kernel!', 13, 10, 0  ; Message to print (with newline)

; Boot sector magic
times 510-($-$$) db 0   ; Pad with zeros
dw 0xAA55              ; Boot signature
