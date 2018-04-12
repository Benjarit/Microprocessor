; Program to read DECIMAL NUMBER and save it in Memory,
; convert the number from ASCIIto  HEX (Binary), then
; and then multily it by 2, and save In RESULT"
; COnvert the Result to  ASCCI again to  print to  screen( Your task to Do)!

include DOS.mac
.MODEL SMALL           ; this defines the memory model
.STACK 100             ; define a stack segment of 100 bytes

.DATA                  ; this is the data segment
MSG          DB  'Enter a number: ',0DH,0AH,'$'
CMD_LINE     DB 8,?,8 dup('$')
NUM          DB 7 DUP('$')    ; hold the ASCII value.
NUM_SIGN     DB 0
MULT1        DW 0000H         ; Initial result= 0
RESULT       DW  0             ; SAVE THE MUTIPLICATION
DISPLAY1     DB  5 DUP('$')       ; HOLD THE ascii TO  BE DISPALYED ON  SCREEN
NEGATIVE_SIGN DB'-$'
NEW_LINE     DB 0DH,0AH,'$'
ILLEGAL_MSG  DB 0DH,0AH,'Error!!',0DH,0AH
             DB 'Input format: invalid input!',0DH,0AH,'$'
ONES		 DB 0H
TENS		 DB 0H

.CODE           ; this is the code segment
.startup
MAIN    PROC FAR
          MOV AX,@DATA    ; get the address of the data segment
          MOV DS,AX       ; and store it in register DS
          MOV ES, AX      ; INitialise the Extended segment

          OUTPUT MSG
          INPUT   CMD_LINE              ; input  expression   using  MACRO
          ;OUTPUT  CMD_LINE+2
          OUTPUT NEW_LINE
         
          XOR CX,CX                     ; same as MOV CX, 0  : reset CX
          MOV CL,[CMD_LINE+1]           ; move count  of butes read from console
          MOV SI,OFFSET CMD_LINE+2      ; SI  points to  the first  charachter read in Memory
          MOV DI,OFFSET NUM             ; DI  points to  the NUM to convert and multiply
          CLD                           ; set  DF= 0 i.e DI, and SI  increasing
;can use in our code
          LODSB                         ; load the first charachter  into AL
          CMP  AL,'-'                   ; If negative update the sign
          JNE  NUMBER
          MOV  [NUM_SIGN],01H           ; set the Negative flag to  1
          DEC CX
NEXTCHAR: LODSB
NUMBER:   STOSB							; store content in AL to [DI]
          JMP CHECK_NUM
CHECK_NUM:CMP  AL,30H                    ; make sure it is a valid digit
          JB   NOTNUMBER
          CMP  AL,39H
          JA   NOTNUMBER
		  LOOP NEXTCHAR
          JMP   FINISH

NOTNUMBER: OUTPUT  ILLEGAL_MSG
           JMP EF

FINISH:    CALL ASC2HEX    ; to onvert the inout from ASCII to binary or HEX
                           ; example: 123 ACII will be saved as 313233H in memory,
                           ; But we need to use THE Hex or BINARY in our arithmetic operation
                           ; 123 wentered will be (7B)HEXADECIMAL
                           ; 123*2= 246decimal which is (F6) Hexadecimal
                           ; see animated video
           ; MULTIPLY  by 2
            MOV       AX,[MULT1]
            MOV       BX,2
            IMUL      BX
            MOV       [RESULT], AX
			
            CALL HEX2ASC     ;  to  display  the result back as ASCII.
                            ; in  Lab3 we used AAM for number <100 but this will not work
                            ; for this lab you  need to write the code as described in  text book
                            ; chapter 8  section  3


           ; To  display  the results 
            CMP BYTE PTR[NUM_SIGN],01H
            JNE NONEGATIVE
            OUTPUT NEGATIVE_SIGN
NONEGATIVE:
            OUTPUT DISPLAY1
EF:
.Exit
MAIN    ENDP


; prcedure to output a charachter
OUTCHAR PROC NEAR
    PUSH AX
    PUSH DX
	MOV AH, 2H
	INT 21H
	POP DX
	POP AX
	RET
OUTCHAR ENDP

ASC2HEX PROC NEAR
       PUSH AX
       PUSH DX
       SUB 	DI,DI 		;CLEAR DI FOR THE BINARY(HEX) RESULT
       MOV 	SI,OFFSET NUM   ; Number that  has the ASCII value
       SUB	CX,CX		;clear register CX
L1:    MOV	CL,[SI]         ; move first ASCII vlaue
       INC	SI
       CMP	CL,24H          ; CHECK IF EMPTY
       JE	FINISH1
       SUB	CL,30H          ; FROM ASCII TO BCD /HEX/Binary
       MOV	AX,10           ;
       MUL	MULT1           ; Place holder FOR THE RESULT , initially =0
       ADD	AX,CX
       MOV	MULT1,AX
       JMP	L1
FINISH1:
	POP DX
	POP AX
	RET
ASC2HEX ENDP

HEX2ASC PROC NEAR ;ADD YOUR CODE HERE .. SEE TEXT  BOOK CHAPTER 8.3 FOR ALGORITHM AND CODE
		MOV AX, [RESULT]
		MOV [ONES], AL
		MOV [TENS], AH
       
        CMP [ONES], 09h		;compare QOUT=A with 9h
		JA greater1		;*******if greater than 9**********
		ADD [ONES], 30h		;if not greater than 9h then adds 30h
		MOV AL, [ONES]
		jmp NEXT1
		greater1: 
		SUB [ONES], 09h
		ADD [ONES], 40h
		MOV AL, [ONES]
		
        NEXT1:
		CMP [TENS], 09h		;compare QOUT=A with 9h
		JA greater2		;*******if greater than 9**********
		ADD [TENS], 30h		;if not greater than 9h then adds 30h
		MOV AH, [TENS]
		jmp NEXT2
		greater2: 
		SUB [TENS], 09h
		ADD [TENS], 40h
		MOV AH, [TENS]
		
		
        NEXT2:
		LEA DI, DISPLAY1
        MOV [DI], AH
		MOV [DI+1], AL
		

         ret
HEX2ASC ENDP
END ; end of the program