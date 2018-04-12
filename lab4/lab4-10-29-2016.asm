;LAB 4 PROGRAM
;FILENAME: lab4.asm
;FILE TYPE: EXE
.MODEL MEDIUM
.STACK 1024
PRINT_NEWLINE macro NEWLINE
          LEA DX, NEWLINE
          MOV AH, 09H
          INT 21H
endm
PRINT_STRING macro CHARA
          LEA DX, CHARA
          MOV AH, 09H
          INT 21H
endm
READ_IN_STRING macro STRING2
          LEA DX, STRING2
          MOV AH, 0AH
          INT 21H
endm
RESET_OP macro OPE
          MOV AL, 24H
          LEA DI, OPE
          MOV CX, 20
          CLD
          REP STOSB
endm
.DATA
     Buffer   DB 20
     NUM      DB ?
     ACT_BUF  DB 20 DUP('$')

     AGAIN2        DB 2
     NUM2          DB ?
     AGAIN2_BUF    DB 2 DUP('$')

     MSG           DB 0DH,0AH,'Enter an algebraic command line:',0DH,0AH,'$'
     NEWLINE       DB 0DH,0AH,'$'
     MSG_ERROR     DB 'Error, invalid input',0DH,0AH,'Input format: Operand1 Operator Operand2',0DH,0AH,'Operand: decimal numbers',0DH,0AH,'Operator: + - * / %$'
     AGAIN         DB 'Again?: $'
     ;MSG2          DB 0DH,0AH,'Operand1: $'
     ;MSG3          DB 0DH,0AH,'Operand2: $'
     ;MSG4          DB 0DH,0AH,'Operator: $'

     OP1_BUFF   	 DB 20 DUP('$')
     OP2_BUFF   	 DB 20 DUP('$')
     OPERATOR_BUFF       DB 20 DUP('$')
     RESULT_BUFF         DB 20 DUP('$')
                

     OP1_S 	 DB 0
     OP2_S 	 DB 0
     OP1   	 DW 0
     OP2   	 DW 0
     OPERATOR    DB 0
     RESULT      DW 0
     SET_FALSE   DB 00H
     SIGN_FLAG   DB 00H
     NEGATIVE_SIGN DB'-$'
.CODE
     .STARTUP
MAIN PROC FAR
START:
          MOV AX,@DATA         ;startup
          MOV DS,AX
          MOV ES,AX
;-----------------PARSING START----------------------------------------
          CALL INPUT
;-----------------once SET_FALSE = 1 WE SKIP PRINTING DATA OUT---------
          LEA SI, SET_FALSE
          MOV AL, [SI]
          CMP AL, 1H
          JE DONE
;------------PRINT DATA PARSING OUT-----------------------------------
          MOV AX, 0000H
          PRINT_STRING NEWLINE
          PRINT_STRING OP1_BUFF
          PRINT_STRING NEWLINE
          PRINT_STRING OP2_BUFF
          PRINT_STRING NEWLINE
          PRINT_STRING OPERATOR_BUFF
          JMP CALL_HEX
START2:
          JMP START
          CALL_HEX:
          CALL ASC2HEX
          CALL ASC2HEX2
;--------------CHECK OPERATION------------------------
CHECK_OPE:
          LEA SI, OPERATOR_BUFF
          CMP BYTE PTR[SI], 2BH
          JE ADD_LABEL
          CMP BYTE PTR[SI], 2DH
          JE SUB_LABEL
;-------------CALL OPERATION PROCEDURE-----------------
ADD_LABEL:
          CALL DO_ADDITION
          JMP CALL_HexPOC
SUB_LABEL:
          CALL DO_SUBTRACTION
;--------------PRINT '-' IF NEGATIVE VALUE------------
CALL_HexPOC:
          PRINT_STRING NEWLINE
          CMP BYTE PTR[SIGN_FLAG], 01H
          JNE NONEGATIVE
          PRINT_STRING NEGATIVE_SIGN
;-------------PRINT RESULT-----------------------------
NONEGATIVE:
          CALL HEX2ASC
          PRINT_STRING RESULT_BUFF
;------------------END OF PRINTING CODE----------------
DONE:
          PRINT_STRING NEWLINE
          PRINT_STRING AGAIN  ;display prompt message
          READ_IN_STRING AGAIN2 ;
;------------------ASK FOR REPEAT-----------------------
          LEA SI, AGAIN2_BUF
          MOV AL, [SI]
          CMP AL, 59H
          JE START2
          CMP AL, 79H
          JE START2

   .EXIT
MAIN ENDP

INPUT PROC NEAR ;START OF INPUT FUNCTION
;---------------SET EVERY THING BACK TO ITS INITIAL VALUE-------------
          RESET_OP OP1_BUFF
          RESET_OP OP2_BUFF
          RESET_OP OPERATOR_BUFF
          RESET_OP ACT_BUF
          RESET_OP RESULT_BUFF
          MOV [SIGN_FLAG], 00H
          MOV [OP1], 0
          MOV [OP2], 0
          MOV BYTE PTR [SET_FALSE], 00H
;----------------PROMT USER INPUT--------------------------
          PRINT_STRING MSG       ;display prompt message
          READ_IN_STRING Buffer  ;inut string
;-----------------PARSING START----------------------------
;----------------PARSING OPERAND1--------------------------
          LEA SI, ACT_BUF
          LEA DI, OP1_BUFF
          FIRST_OP:
          CLD
          LODSB     ;LOAD DATA CONTENT FROM ACT_BUF , AL = [SI], SI+1
          STOSB     ;STORE DATA CONTENT FROM AL TO OP1, DI+1
          CMP byte ptr [SI], 20H
          JE NEXT_OPR
          CMP byte ptr [SI], 24H ;CMP IF IT IS THE END OF THE ACT_BUFF
          JE ERROR_LABEL1   ;IF YES, THEN WE KNOW STRING DOES NOT HAVE SPACE
          JMP FIRST_OP
;------------------PARSING OPERATOR-----------------------
          NEXT_OPR:
           LEA DI, OPERATOR_BUFF
           INC SI
           LODSB
           STOSB
           CMP byte ptr [SI], 20H
           JE NEXT_OP
           JMP ERROR_LABEL2  ;SAME WITH THIS ONE, WE KNOW IT DOES NOT HAVE SPACE
;-----------------PARSING OPERAND2------------------------
           NEXT_OP:
           LEA DI, OP2_BUFF
           INC SI
           LOOP1:
           LODSB     ;LOAD DATA CONTENT FROM ACT_BUF ,AL = [SI],  SI+1
           CMP byte ptr [SI], 24H   ;We have to consider 0DH return carriage
           JE COMPARE_OP1           ;We dont transfer 0DH to OP2_BUFF
           STOSB
           JMP LOOP1
;--------------------ERROR LABEL--------------------------
           ERROR_LABEL1:
           JMP ERROR_LABEL2
;----------------CHECK VALIDITY OPERAND1------------------
           COMPARE_OP1:
           LEA SI, OP1_BUFF
           LOOP2:
           INC SI
           CMP byte ptr [SI-1], 24H
           JE COMPARE_OPR
           CMP byte ptr [SI-1], 30H
           JB ERROR_LABEL
           CMP byte ptr [SI-1], 39H
           JA ERROR_LABEL
           JMP LOOP2
           ERROR_LABEL2:
           JMP ERROR_LABEL
;---------------CHECK VALIDITY OPERATOR---------------------
          COMPARE_OPR:
           LEA SI, OPERATOR_BUFF
           CMP byte ptr [SI], 2BH
           JE COMPARE_OP2
           CMP byte ptr [SI], 2DH
           JE COMPARE_OP2
           CMP byte ptr [SI], 2AH
           JE COMPARE_OP2
           CMP byte ptr [SI], 2FH
           JE COMPARE_OP2
           CMP byte ptr [SI], 25H
           JE COMPARE_OP2
           JMP ERROR_LABEL
;--------------CHECK VALIDITY OPERAND2------------------------
           COMPARE_OP2:
           LEA SI, OP2_BUFF
           LOOP3:
           INC SI
           CMP byte ptr [SI-1], 24H
           JE  RETURN
           CMP byte ptr [SI-1], 30H
           JB  ERROR_LABEL
           CMP byte ptr [SI-1], 39H
           JA  ERROR_LABEL
           JMP LOOP3
ERROR_LABEL:
            PRINT_STRING NEWLINE
            CALL ERROR_PROC
RETURN:
RET
INPUT ENDP ;END OF INPUT FUNCTION
ERROR_PROC PROC NEAR
           PRINT_STRING MSG_ERROR
           LEA DI, SET_FALSE
           MOV BYTE PTR [DI], 1H
RET
ERROR_PROC ENDP ;END OF ERROR_POC FUNCTION

ASC2HEX PROC NEAR
       PUSH AX
       PUSH DX
       SUB 	DI,DI 		;CLEAR DI FOR THE BINARY(HEX) RESULT
       MOV 	SI,OFFSET OP1_BUFF   ; Number that  has the ASCII value
       SUB	CX,CX		;clear register CX
L1:    MOV	CL,[SI]         ; move first ASCII vlaue
       INC	SI
       CMP	CL,24H          ; CHECK IF EMPTY
       JE	FINISH1
       SUB	CL,30H          ; FROM ASCII TO BCD /HEX/Binary
       MOV	AX,10           ;
       MUL	OP1             ; Place holder FOR THE RESULT , initially =0
       ADD	AX,CX
       MOV	OP1,AX
       JMP	L1
FINISH1:
	POP DX
	POP AX
	RET
ASC2HEX ENDP
ASC2HEX2 PROC NEAR
       PUSH AX
       PUSH DX
       SUB 	DI,DI 		;CLEAR DI FOR THE BINARY(HEX) RESULT
       MOV 	SI,OFFSET OP2_BUFF   ; Number that  has the ASCII value
       SUB	CX,CX		;clear register CX
L2:    MOV	CL,[SI]         ; move first ASCII vlaue
       INC	SI
       CMP	CL,24H          ; CHECK IF EMPTY
       JE	FINISH2
       SUB	CL,30H          ; FROM ASCII TO BCD /HEX/Binary
       MOV	AX,10           ;
       MUL	OP2           ; Place holder FOR THE RESULT , initially =0
       ADD	AX,CX
       MOV	OP2,AX
       JMP	L2
FINISH2:
	POP DX
	POP AX
	RET
ASC2HEX2 ENDP
HEX2ASC PROC NEAR ;ADD YOUR CODE HERE .. SEE TEXT  BOOK CHAPTER 8.3 FOR ALGORITHM AND CODE
        MOV AX, [RESULT]
        LEA DI, RESULT_BUFF
        PUSH 10
        L3:
        MOV BX, 10
        MOV DX, 0
        DIV BX
        PUSH DX
        CMP AX, 0
        JNZ L3
        L4:
        POP DX
        CMP DX, 10
        JE DONE2
        ADD DX, 30H
        MOV [DI], DX
        INC DI
        JMP L4
DONE2:
RET
HEX2ASC ENDP

DO_ADDITION PROC NEAR
        MOV AX, [OP1]
        ADD AX, [OP2]
        MOV [RESULT], AX
RET
DO_ADDITION ENDP

DO_SUBTRACTION PROC NEAR
        MOV AX, [OP1]
        CMP AX, [OP2]
        JGE B1
        SUB [OP2], AX
        MOV BX, [OP2]
        MOV [RESULT], BX
        MOV BYTE PTR[SIGN_FLAG], 01H
        JMP BYE
B1:
        SUB AX, [OP2]
        MOV [RESULT], AX
BYE:
RET
DO_SUBTRACTION ENDP
END ; end of the program
