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
          MOV CX, 10
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

     MSG          DB 0DH,0AH,'Enter an algebraic command line:',0DH,0AH,'$'
     NEWLINE      DB 0DH,0AH,'$'
     MSG_ERROR    DB 'Error, invalid input',0DH,0AH,'Input format: Operand1 Operator Operand2',0DH,0AH,'Operand: decimal numbers',0DH,0AH,'Operator: + - * / %$'
     AGAIN        DB 'Again?: $'

     OP1_BUFF   	 DB 10 DUP('$')
     OP2_BUFF   	 DB 10 DUP('$')
     OPERATOR_BUFF       DB 10 DUP('$')
     RESULT_BUFF         DB 10 DUP('$')


     OP1_S 	 DB 0
     OP2_S 	 DB 0
     OP1   	 DB 0
     OP2   	 DB 0
     OPERATOR    DB 0
     RESULT      DB 0
     SET_FALSE   DB 0H

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
;------------------END OF PRINTING CODE----------------
DONE:
          PRINT_STRING NEWLINE
          PRINT_STRING AGAIN  ;display prompt message
          READ_IN_STRING AGAIN2 ;
;------------------ASK FOR REPEAT-----------------------
          LEA SI, AGAIN2_BUF
          MOV AL, [SI]
          CMP AL, 59H
          JE START
          CMP AL, 79H
          JE START

   .EXIT
MAIN ENDP

INPUT PROC NEAR ;START OF INPUT FUNCTION
;---------------SET EVERY THING BACK TO ITS INITIAL VALUE-------------
          RESET_OP OP1_BUFF
          RESET_OP OP2_BUFF
          RESET_OP OPERATOR_BUFF
          LEA DI, SET_FALSE
          MOV BYTE PTR [DI], 0H
;----------------PROMT USER INPUT--------------------------
          PRINT_STRING MSG       ;display prompt message
          READ_IN_STRING Buffer  ;inut string
;-----------------PARSING START----------------------------
          LEA SI, ACT_BUF
          LEA DI, OP1_BUFF
;----------------PARSING OPERAND1--------------------------
          FIRST_OP:
          CLD
          LODSB     ;LOAD DATA CONTENT FROM ACT_BUF , SI+1
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
           MOV AL, [SI]
           MOV [DI], AL
           INC SI
           CMP byte ptr [SI], 20H
           JE NEXT_OP
           JMP ERROR_LABEL2  ;SAME WITH THIS ONE, WE KNOW IT DOES NOT HAVE SPACE
;-----------------PARSING OPERAND2-----------------------
           NEXT_OP:
           LEA DI, OP2_BUFF
           INC SI
           LOOP1:
           CLD
           LODSB     ;LOAD DATA CONTENT FROM ACT_BUF , SI+1
           CMP byte ptr [SI], 24H
           JE COMPARE_OP1
           STOSB
           JMP LOOP1
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
END