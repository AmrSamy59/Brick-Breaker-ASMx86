extrn BALL_X:word
extrn BALL_Y:word
extrn paddleX:word
extrn prevPaddleX:word

extrn BALL_X_REC:word
extrn BALL_Y_REC:word
extrn paddleX2:word
extrn prevPaddleX2:word

public COM_INIT
public SendCom
public RecCom

public SendStartFlag
public WaitForRec

.MODEL small
.STACK 100h
.code


COM_INIT proc
    ; initinalize COM
    ;Set Divisor Latch Access Bit
    mov dx,3fbh 			; Line Control Register
    mov al,10000000b		;Set Divisor Latch Access Bit
    out dx,al				;Out it
    ;Set LSB byte of the Baud Rate Divisor Latch register.
    mov dx,3f8h			
    mov al,0ch			
    out dx,al

    ;Set MSB byte of the Baud Rate Divisor Latch register.
    mov dx,3f9h
    mov al,00h
    out dx,al

    ;Set port configuration
    mov dx,3fbh
    mov al,00011011b
    out dx,al
    ret
COM_INIT endp

SendStartFlag proc
        waitToSendStart:
        mov dx , 3FDH		; Line Status Register
        In al , dx 			;Read Line Status
        AND al , 00100000b
        JZ waitToSendStart
        
        mov dx , 3F8H		; Transmit data register
        mov al, 'b'
        out dx , al
        
        RET
SendStartFlag endp

SendCom proc
        ;If empty put the VALUE in Transmit data register
        ; mov dx , 3FDH		; Line Status Register
        ; In al , dx 			;Read Line Status
        ; AND al , 00100000b
        ; JZ exitSend

        ; mov dx , 3F8H		; Transmit data register
        ; mov al, byte ptr BALL_X
        ; out dx , al 

        ; mov dx , 3FDH		; Line Status Register
        ; In al , dx 			;Read Line Status
        ; AND al , 00100000b
        ; JZ exitSend

        ; mov dx , 3F8H		; Transmit data register
        ; mov al, byte ptr BALL_Y
        ; out dx , al 

        mov dx , 3FDH		; Line Status Register
        In al , dx 			;Read Line Status
        AND al , 00100000b
        JZ exitSend

        mov dx , 3F8H		; Transmit data register
        mov ax, paddleX
        out dx , al

        ; mov dx , 3FDH		; Line Status Register
        ; In al , dx 			;Read Line Status
        ; AND al , 00100000b
        ; JZ exitSend

        ; mov dx , 3F8H		; Transmit data register
        ; mov al, byte ptr prevPaddleX
        ; out dx , al

        exitSend:
       
        RET
   
SendCom endp

WaitForRec proc
        rewait:
                mov dx , 3FDH		; Line Status Register
                In al , dx 			;Read Line Status
                AND al , 1
        JZ rewait

        mov dx, 03F8H
        in al, dx
        CMP al, 'b'
        JNZ rewait

        RET

WaitForRec endp

RecCom proc

        ; readBallX:
        ; mov dx , 3FDH		; Line Status Register
        ; in al , dx 
        ; AND al , 1
        ; JZ readBallX

        ; ; WE RECIEVED HERE
        ; mov dx , 03F8H
        ; in al , dx 
        ; mov byte ptr BALL_X_REC , al
        ; add BALL_X_REC, 161

        ; readBallY:
        ; mov dx , 3FDH		; Line Status Register
        ; in al , dx 
        ; AND al , 1
        ; JZ readBallY

        ; mov dx , 03F8H
        ; in al , dx
        ; mov byte ptr BALL_Y_REC , al
        ; add BALL_Y_REC, 161

        readPaddleX:
        mov dx , 3FDH		; Line Status Register
        in al , dx 
        AND al , 1
        JZ exitRec

        mov bx, paddleX2
        mov prevPaddleX2, bx
        mov dx , 03F8H
        in al , dx
        mov ah, 0
        mov paddleX2 , ax
        add paddleX2, 161

        ; readPaddlePrevX:
        ; mov dx , 3FDH		; Line Status Register
        ; in al , dx 
        ; AND al , 1
        ; JZ readPaddlePrevX

        ; mov dx , 03F8H
        ; in al , dx
        ; mov byte ptr prevPaddleX2 , al

        exitRec:

        RET
RecCom endp

; exit:
;     mov ah, 4ch
;     int 21h 

end COM_INIT

