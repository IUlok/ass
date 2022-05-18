include io.asm ;30 var fyodorov
.model small
.stack 100
.data ;segment data
	x dw ?
	y dw ? ;peremennye
	text db "Enter x: ", '$'
	text2 db "Y = ", '$' ;texts
.code ;segment code
.startup ;start
	mov ah,9
	lea dx, text
	int 21h ;output text

	InInt x ;input x

	cmp x,3 ;sravnenye x, 3
	jg MORE ;if more - jump to MORE
	jl LESS ;if less - jump to LESS
	mov y,2 ;else y=2
	jmp OUTP ;jump to OUTP

LESS:	mov ax,x ;if less - y=x-1
	dec ax
	mov y,ax
	jmp OUTP

MORE:	mov ax,x ;if more - y=-x+5
	neg ax
	add ax,5
	mov y,ax

OUTP:	mov ah,9
	lea dx,text2
	int 21h
	OutInt y ;output y
.exit 0 ;ending start
end ;ending code