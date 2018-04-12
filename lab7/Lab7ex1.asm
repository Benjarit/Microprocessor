
; monochrome monitors
; mode 07h
;(a)Change the video mode
;(b)Display the letter 'F' in 5 locations with attributes
; functions are called as Procedures

.model small
.386
.stack 100h
.data
      col  db 0
      row  db 0
      CHAR DB ?         ; FOR AH=09 FUNCTION
      ATTRIBUTE DB ?
      COUNT DW 0

.code
.startup

main proc far
  mov ax,@data
  mov ds,ax
  mov es, ax
;;;;;; SET THE VIDEO MODE;;;;;;;;;;;
       mov ah,00h
       mov al,07h    ; monochrome mode
       int  10h


;;;;;;POSITION THE CURSOR IN THE CENTER;;;;;;
      mov col,40
      mov row, 13
      call SET_CURSOR
      MOV CHAR, 'F'
      MOV ATTRIBUTE, 0F0H
      MOV COUNT,5
      CALL WRITE_CHAR

;;;;;;;;END;;;;;;;;
  mov ah,4ch
  int 21h

  
main endp

include proclib.mac   ; useful set of procedures

end


