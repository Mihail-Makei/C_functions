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
;Destroys: di, bl
;===========================================

strlen proc
		cld
		xor	cx, cx

compare:
		mov	bl, byte ptr es:[di]
		cmp	bl, 0
		je	finish
		
		inc	cx
		inc	di
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
; Destroys: cx, si
;======================================================

strcpy	proc
		cld

copypaste:
		mov	cx, ds:[si]
		cmp	cx, 0
		je	endcpy

		movsb
		jmp	copypaste

endcpy:
		ret
endp	strcpy

;======================================================
;			STRCHR
;======================================================
; Expects: es:[di] - string, ch - symbol
;
; Returns: ax - position of symbol (-1 if not found)
;
; Destroys: di, bx
;======================================================

strchr	proc
		cld
		xor	ax, ax

findchr:
		mov	cl, es:[di]
		cmp	cl, ch
		je	found

		cmp	cl, 0
		je	not_found

		inc	di
		inc	ax
		jmp	findchr

not_found:
		mov	ax, -1

found:
		ret

endp	strchr

end Start
