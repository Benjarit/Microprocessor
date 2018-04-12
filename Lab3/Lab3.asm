.MODEL	SMALL
.STACK	266
.DATA
        Instring     DB 'Input String: $',0AH, 0DH
        consString   DB 'String contains: $',0AH, 0DH
        capEnding    DB ' capital letter(s).$',0AH,0DH
        lowerEnding  DB 09H," small letter(s).$"
        digitEnging  DB 09H,' number(s).$'
        symbEnding   DB 09H,' symbol(s).$'

        Break        DB  0AH,0DH,'$'  ; new line

        Buffer       DB   100         ; max number(100) of chars expected
        Num          DB   ?           ; returns the number of chars typed
        Act_Buf      DB   100 DUP (?) ; actual buffer w/ size=“max number”
        digit        DB   0H
        capital      DB   0H
        lower        DB   0H
        symb         DB   0H
.CODE
	.STARTUP
MAIN    PROC FAR
        MOV  AX,@data
        MOV  DS,AX
        MOV  ES,AX
        MOV  AX,0000H
        MOV  CX,0000H

        ;Input String
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

        ;Put dollar sign at the end of the string
        MOV SI, OFFSET Buffer + 1
        MOV CL, [SI]
        MOV CH, 0
        INC CX
        ADD SI, CX
        MOV AL, '$'
        MOV [SI], AL

        ;Print the user's input string
        MOV AH, 09H
        MOV DX, OFFSET Buffer + 2
        INT 21H
        
        ;Display  new line
        MOV DX, OFFSET Break
        MOV AH,09H
        INT 21H

        MOV SI, OFFSET Buffer + 1
        MOV CL, [SI]
        MOV CH, 00H

        MOV SI, OFFSET Buffer + 2    ;set SI to the beginning of the string
start_looking:
        INC  SI
        MOV AL, [SI-1]

        CMP CX, 00H          ;check if the end of string is reached
        JE finish                ;if it is the end then go to finish label
        DEC CX
check_aph:

        ;if( AL > 61H && AL < 7AH)
        CMP AL, 61H
        JB check_Upaph
        CMP AL, 7AH
        JA others

        ;True
        INC [lower]               ;increment the lower variable by 1 if meet condition
        JMP start_looking       ;back to the start_looking label

check_Upaph:

        ;if( AL > 41H && AL < 5A)
        CMP AL, 41H
        JB check_dig
        CMP AL, 5AH
        JA others

        ;true
        INC [capital]             ;increment the capital variable by 1 if meet condition
        JMP start_looking       ;back to the start_looking label

check_dig:

        ;if(AL > 30H && AL < 39H)
        CMP AL, 30H
        JB others
        CMP AL, 39h
        JA others

        ;true
        INC [digit]               ;increment the digit variable by 1 if meet condition
        JMP start_looking       ;back to the start_looking label

others:

        ;if( AL == 20H || AL == 09H )
        CMP AL, 20H
        JE start_looking
        CMP AL, 09H
        JE start_looking

        ;none of the above
        INC [symb]                ;increment the symb variable by 1  if meet condition
        JMP start_looking       ;back to the start_looping label
finish:
        ;Display "String contains:" string
        MOV DX, OFFSET consString
        MOV AH,09H
        INT 21H

        ;Display total number of capitals
        MOV SI, OFFSET capital
        MOV AL, [SI]
        AAM
        ADD AX, 3030H
        MOV DX, 0
        MOV BX, AX
        MOV DL,BH	;OUTPUT TENS DIGIT
        MOV AH,02H
        INT 21H

        MOV DL, BL      ; OUTPUT ONES DIGIT
        MOV AH,02H
        INT 21H

        ;Display capital letter(s) string
        MOV DX, OFFSET capEnding
        MOV AH,09H
        INT 21H

        ; Display  new line
        MOV DX, OFFSET Break
        MOV AH,09H
        INT 21H

        ;Display total number of small letter
        MOV SI, OFFSET lower
        MOV AL, [SI]
        AAM
        ADD AX, 3030H
        MOV DX, 0
        MOV BX, AX
        MOV DL,BH	;OUTPUT TENS DIGIT
        MOV AH,02H
        INT 21H

        MOV DL, BL      ; OUTPUT ONES DIGIT
        MOV AH,02H
        INT 21H
        ;Display small letter(s) string
        MOV DX, OFFSET lowerEnding
        MOV AH,09H
        INT 21H
        
        ; Display  new line
        MOV DX, OFFSET Break
        MOV AH,09H
        INT 21H

        ;Display total number of digit
        MOV SI, OFFSET digit
        MOV AL, [SI]
        AAM
        ADD AX, 3030H
        MOV DX, 0
        MOV BX, AX
        MOV DL,BH	;OUTPUT TENS DIGIT
        MOV AH,02H
        INT 21H

        MOV DL, BL      ; OUTPUT ONES DIGIT
        MOV AH,02H
        INT 21H
        ;Display number(s) string
        MOV DX, OFFSET digitEnging
        MOV AH,09H
        INT 21H

        ; Display  new line
        MOV DX, OFFSET Break
        MOV AH,09H
        INT 21H

        ;Display total number of symbol
        MOV SI, OFFSET symb
        MOV AL, [SI]
        AAM
        ADD AX, 3030H
        MOV DX, 0
        MOV BX, AX
        MOV DL,BH	;OUTPUT TENS DIGIT
        MOV AH,02H
        INT 21H

        MOV DL, BL      ; OUTPUT ONES DIGIT
        MOV AH,02H
        INT 21H
        ;Display symbol(s) string
        MOV DX, OFFSET symbEnding
        MOV AH,09H
        INT 21H


	.Exit
MAIN 	ENDP
END
