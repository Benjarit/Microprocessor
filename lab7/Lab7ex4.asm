; Write Character (0Ah)
; INT 10h Function 0Ah writes a character to the screen at the current cursor position without changing
; the current screen attribute. As shown in the next table, it is identical to Function 9, except that the
; attribute is not specified.


INCLUDE DOS.MAC
.MODEL SMALL
.386
.STACK 100H
.DATA

.CODE
.STARTUP

MAIN PROC FAR
  MOV AX,@DATA
  MOV DS,AX
  MOV ES, AX



MOV AH,0AH
MOV AL,'A' ; ASCII CHARACTER
MOV BH,0 ; VIDEO PAGE 0
MOV CX,10 ; REPETITION COUNT
INT 10H


;;;;;;;;END;;;;;;;;
  MOV AH,4CH
  INT 21H

  
MAIN ENDP

END


