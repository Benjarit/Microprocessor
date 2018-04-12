;PROGRAM 1 OF LAB 6
;FILENAME: mmath.asm
.386C
.MODEL USE16 SMALL 
.DATA 
; put memory variables here
; You shouldn't need to use this if you properly design you code
.CODE
PUBLIC	_dotP
PUBLIC	_crossP

_dotP PROC
	;INT 	03H 
	PUSH BP		
	MOV BP,SP
	MOV SI, [BP+4]
	MOV DI, [BP+6]
	MOV BX, [BP+8]

	MOV BP, SI
	MOV AX, [BP]
	MOV BP, DI
	MOV CX, [BP]
	IMUL CX
	MOV BP, BX
	MOV [BP], AX
	MOV [BP+2], DX

	MOV BP, SI
	MOV AX, [BP+2]
	MOV BP, DI
	MOV CX, [BP+2]
	IMUL CX
	MOV BP, BX
	ADD [BP], AX
	ADC [BP+2], DX

	MOV BP, SI
	MOV AX, [BP+4]
	MOV BP, DI
	MOV CX, [BP+4]
	IMUL CX
	MOV BP, BX
	ADD [BP], AX
	ADC [BP+2], DX  
	
	POP BP
RET
_dotP ENDP

_crossP PROC

	PUSH BP	
	MOV BP,SP
	MOV SI, [BP+4]
	MOV DI, [BP+6]
	MOV BX, [BP+8]

        MOV AX, [SI+2]
        IMUL WORD PTR[DI+4]
        MOV BP,BX
        MOV [BP], AX
        MOV [BP+2], DX
        MOV AX, [SI+4]
        IMUL WORD PTR[DI+2]
        SUB [BP], AX
        SBB [BP+2], DX
        
        MOV AX, [SI+4]
        IMUL WORD PTR[DI]
        MOV BP,BX
        MOV [BP+4], AX
        MOV [BP+6], DX
        MOV AX, [SI]
        IMUL WORD PTR[DI+4]
        SUB [BP+4], AX
        SBB [BP+6], DX
        
        MOV AX, [SI]
        IMUL WORD PTR[DI+2]
        MOV BP,BX
        MOV [BP+8], AX
        MOV [BP+10], DX
        MOV AX, [SI+2]
        IMUL WORD PTR[DI]
        SUB [BP+8], AX
        SBB [BP+10], DX




	POP BP
RET
_crossP ENDP

END
