INCLUDE DOS.MAC
.MODEL SMALL
.386
.STACK 100H
.DATA

 ATTRIB_HI = 10000000B
 STRING DB "ECE3210 LAB7!"
 COUNT DW $-STRING
 COLOR DB (0 SHL 4) OR 1      ; 0  black, 1 blue

.CODE
.STARTUP

MAIN PROC FAR
  MOV AX,@DATA
  MOV DS,AX
  MOV ES, AX

    CLEAR_SCREEN
    SET_CURSOR 40,12
    MOV CX,COUNT
    MOV SI,OFFSET STRING
L11: 
    PUSH CX         ; SAVE LOOP COUNTER
    MOV AH,9        ; WRITE CHARACTER/ATTRIBUTE
    MOV AL,[SI]     ; CHARACTER TO DISPLAY
    MOV BH,0        ; VIDEO PAGE 0
    MOV BL,COLOR    ; ATTRIBUTE
    OR BL,ATTRIB_HI ; SET BLINK/INTENSITY BIT
    MOV CX,1        ; DISPLAY IT ONE TIME
    INT 10H
    MOV CX,1        ; ADVANCE CURSOR TO
     ADVANCECURSOR ; NEXT SCREEN COLUMN
    INC COLOR           ; NEXT COLOR
    INC SI              ; NEXT CHARACTER
    POP CX              ; RESTORE LOOP COUNTER
    LOOP L11


;;;;;;;;END;;;;;;;;
  MOV AH,4CH
  INT 21H

  
MAIN ENDP

END


