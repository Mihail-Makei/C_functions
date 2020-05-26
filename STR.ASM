.model tiny
.386
.data
msg		db 'I love catsnxzcvmnmxn,mxvn,mzxw', 0
msgtwo		db 'Hello world', 0
buff		dw 0, '$'
.code

org 100h

Start:
		mov	di, offset msg
		mov	ch, '5'
		call	strchr
		mov	word ptr [buff], ax
		
		mov	ah, 09h
		mov	dx, offset buff
		int	21h

		xor	ah, ah
		int	21h

;===============STRLEN======================
;===========================================
;Expects: es:[di] - offset to string
;
;Returns: cx - length of string
;
;Destroys: di, al
;===========================================

strlen proc
		cld
		xor	cx, cx
		xor	al, al

compare:
		scasb
		je	finish
		
		inc	cx
		jmp	compare

finish:
		ret

endp	strlen
;============================================
;==================STRCMP====================
;============================================
;Expects: es:[di] - offset to first string
;	  ds:[si] - offset to second string
;Returns: ax 1 if equal, 2 if less, 3 if more        
;
;Destroys: di, si
;============================================

EQUAL		equ	1
MORE		equ	2
LESS		equ	3

strcmp	proc
		cld

		push	di
		call	strlen	;Get length of the 1st line
		inc	cx
		pop	di

		repe	cmpsb
		
		ja	strmore
		jb	strless
		
		mov	ax, EQUAL
		jmp	exit

strmore:
		mov	ax, MORE
		jmp	exit

strless:
		mov	ax, LESS

exit:
		ret
endp	strcmp

;======================================================
;		       STRCPY
;======================================================
; Expects: es:[di] - address to write, 
;	ds:[si] - address of string to copy
; Returns: none
;
; Destroys: al, si
;======================================================

strcpy	proc
		cld
		
		xor	al, al

copypaste:
		scasb
		je	endcpy
		dec	di

		movsb
		jmp	copypaste

endcpy:
		ret
endp	strcpy

;======================================================
;			STRCHR
;======================================================
; Expects: es:[di] - string, al - symbol
;
; Returns: cx - position of symbol (-1 if not found)
;
; Destroys: di, bx
;======================================================

strchr	proc
		cld
		xor	bx, bx
		
		push	di
		call 	strlen
		pop	di

findchr:
		scasb
		je	found
		
		inc	bx
		loop	findchr

not_found:
		mov	bx, -1

found:
		ret

endp	strchr

end Start
