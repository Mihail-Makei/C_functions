.model tiny
.386
.data
buff1		db 'Meow', 35 DUP(0), '$'
buff2		db 'Meow meow meow$'
buff		db 0, '$'

.code

org 100h

Start:
		mov	di, offset buff2
		mov	cx, 10
		mov	al, 'w'
		call	memchr

		mov	[buff], bl

		mov	ah, 09h
		mov	dx, offset buff
		int	21h

		xor	ah, ah
		int	21h

;============================================================
;			MEMCMP
;============================================================
;Expects: es:[di] - first buff, ds:[si] - second buff
;			cx - length
;Returns: ax 1 - equal, 2 - more, 3 - less
;
;Destroys: di, si, cx
;============================================================

EQUAL	equ	1
MORE	equ	2
LESS	equ	3

memcmp	proc
		cld
		
		repe	cmpsb
		
		ja	above
		jb	below
		
		mov	ax, EQUAL
		jmp	finishcmp

above:	
		mov	ax, MORE
		jmp	finishcmp

below:
		mov	ax, LESS

finishcmp:
		ret
endp	memcmp

;============================================================
;			MEMSET
;============================================================
;Expects: es:[di] - address of buff, al - data to fill with
;				cx - length of buff
;Returns: none
;
;Destroys di, cx
;============================================================

memset	proc
		cld
		
		rep	stosb
		ret
endp	memset
;============================================================
;			MEMCPY
;============================================================
; Expects: es:[di] - address to write, ds:[si] - address to copy from
;					cx - length of buff
; Returns: none
;
; Destroys: di, si, cx
;============================================================

memcpy	proc
		cld
		
		rep	movsb

		ret
endp	memcpy
;============================================================
;			MEMCHR
;============================================================
; Expects: es:[di] - address to search, al - symbol to search,
;					cx - length of buffer
; Returns: bx - symbol position, bx + cx if not found
;
; Destroys: di, cx
;============================================================

memchr	proc
		mov	bx, di
		cld

find:
		repne 	scasb
		sub	di, bx
		
		ret

endp	memchr
;==============================================================
end Start
