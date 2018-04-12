.MODEL	SMALL
.STACK	266
.DATA
        Instring     DB 'You Entered:$',0AH, 0DH
        Break        DB  0AH,0DH,'$'  ; new line
        Buffer       DB   100         ; max number(100) of chars expected
        Num          DB   ?           ; returns the number of chars typed
        Act_Buf      DB   100 DUP (?) ; actual buffer w/ size=“max number”

.CODE
	.STARTUP
MAIN    PROC FAR
		MOV  AX,@data
		MOV  DS,AX
        MOV  ES,AX
		MOV  AX,0000H
        MOV  CX,0000H

        ;Enter String
        MOV  DX,OFFSET Buffer
        MOV  AH,0AH
        INT 21H

        ; Display  new line
        MOV DX, OFFSET Break
        MOV AH,09H
        INT 21H

        ; Display  "You Entered" string
        MOV DX, OFFSET Instring
        MOV AH,09H
        INT 21H

        ;TODO: Display the entered string
        MOV SI, OFFSET Buffer + 1
        MOV CL, [SI]
        MOV CH, 0
        INC CX
        ADD SI, CX
        MOV AL, '$'
        MOV [SI], AL

        MOV AH, 09H
        MOV DX, OFFSET Buffer + 2
        INT 21H

	.Exit
MAIN 	ENDP
END
