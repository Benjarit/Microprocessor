
; monochrome monitors
; mode 07h
;(a)Change the video mode
;(b)Display the letter 'F'
; use set of functions as macros

INCLUDE DOS.MAC
.model small
.386
.stack 100h
.data

    SYMBOL DB    'F'  ; ASCII CHARCHTER 1H= FUNNY  FACE, 03H HEART...ETC
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

; PRINT FADI USING HEARTS
    ; macros are defined in  DOS.AMC

    SET_CURSOR   30,10
    WRITE_CHAR   SYMBOL,0F0H,8        ;FFFFFFF
    SET_CURSOR   30,11
    WRITE_CHAR   SYMBOL,0F0H,2        ;FF
    SET_CURSOR   30,12
    WRITE_CHAR   SYMBOL,0F0H,2        ;FF
    SET_CURSOR   30,13
    WRITE_CHAR   SYMBOL,0F0H,8        ;FFFFFFF
    SET_CURSOR   30,14
    WRITE_CHAR   SYMBOL,0F0H,2        ;FF
    SET_CURSOR   30,15
    WRITE_CHAR   SYMBOL,0F0H,2        ;FF
    SET_CURSOR   30,16
    WRITE_CHAR   SYMBOL,0F0H,2        ;FF

;;;;;;;;END;;;;;;;;
  mov ah,4ch
  int 21h

  
main endp



end


