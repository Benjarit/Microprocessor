
;CGA text mode
; mode 03h
;(a)Change the video mode
;(b)Display the letter 'F' IN high ontensity white on blue

INCLUDE DOS.MAC
.model small
.386
.stack 100h
.data

    SYMBOL  DB    'F'  ; ASCII CHARCHTER 1H= FUNNY  FACE, 03H HEART...ETC
    STRING  DB    'ECE3210 LAB7$'
    STRING2 DB    "H: Horizontal bars    V: Vertical bars    Q: Quit$"
    STRING3 DB    "Press B to go back to MENU$"
    CHOICE  DB    ?
    COLOR   DB    1FH    ; high intensity white on blue
.code
.startup

main proc far
  mov ax,@data
  mov ds,ax
  mov es, ax

;;;;;; SET THE VIDEO MODE;;;;;;;;;;;
       mov ah,00h
       mov al,03h    ;CGA color text mode of 80*25
       int  10h


; macros are defined in  DOS.AMC
START:
    MOV AX, 0600H
    MOV CL, 0
    MOV CH, 0
    MOV DL, 80
    MOV DH, 24
    MOV BH, 17H
    INT 10H

    SET_CURSOR 30,10
    MOV DX, OFFSET STRING
    MOV AH, 09H
    INT 21H

    SET_CURSOR 20,15
    MOV DX, OFFSET STRING2
    MOV AH, 09H
    INT 21H

    MOV AH, 01H
    INT 21H
    MOV CHOICE, AL
    CMP CHOICE, "H"
    JE HORIZ
    CMP CHOICE, 'V'
    JE VERTI
    JMP DONE

HORIZ:
    MOV AX, 0600H
    MOV CL, 0
    MOV CH, 0
    MOV DL, 26
    MOV DH, 24
    MOV BH, 20H
    INT 10H

    MOV CL, 27
    MOV CH, 0
    MOV DL, 52
    MOV DH, 24
    MOV BH, 40H
    INT 10H

    MOV CL, 53
    MOV CH, 0
    MOV DL, 79
    MOV DH, 24
    MOV BH, 10H
    INT 10H
    
    SET_CURSOR 30,10
    MOV DX, OFFSET STRING3
    MOV AH, 09H
    INT 21H

    MOV AH, 01H
    INT 21H
    MOV CHOICE, AL
    CMP AL, "B"
    JE START
    JMP DONE
VERTI:
    MOV AX, 0600H
    MOV CL, 0
    MOV CH, 0
    MOV DL, 79
    MOV DH, 8
    MOV BH, 20H
    INT 10H

    MOV CL, 0
    MOV CH, 9
    MOV DL, 79
    MOV DH, 16
    MOV BH, 40H
    INT 10H

    MOV CL, 0
    MOV CH, 17
    MOV DL, 79
    MOV DH, 24
    MOV BH, 10H
    INT 10H

    SET_CURSOR 30,10
    MOV DX, OFFSET STRING3
    MOV AH, 09H
    INT 21H

    MOV AH, 01H
    INT 21H
    MOV CHOICE, AL
    CMP AL, "B"
    JE START
    JMP DONE
;;;;;;;;END;;;;;;;;
DONE:
  mov ah,4ch
  int 21h
main endp
end


