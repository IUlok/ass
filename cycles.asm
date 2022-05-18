include io.asm
.model small
.stack 100
.data
  vvod db "Enter string: ", 0Ah,0Dh,'$'
  vvod2 db "Enter len of string: ", 0Ah,0Dh,'$'
  msg db 100 dup('$')
  x dw ?
.code
.startup

  mov ah, 9
  lea dx,vvod
  int 21h
    
  mov ah,0ah
  lea dx,msg
  int 21h 

  mov ah, 9
  lea dx,vvod2
  int 21h

  InInt x
  mov     cx,     x
  add     cx,     3

  mov     ax,     ds     ; Запись сегмента данных (строки) в AX
  mov     es,     ax     ; 
  lea     si,     msg    ;
  mov     di,     si     ;

for:
  lodsb               ; Считать байт по адресу DS:(E)SI в AL
  cmp     al,     ' ' ; Сравнение AL с пробелом
  je      next        ; Если в регистре пробел, переход в next (т.е. не сохраняем этот элемент)
  stosb               ; Сохранить AL по адресу ES:(E)DI (т.е. сохраняем текущий элемент)
next:
  loop    for         ; Цикл

  mov ah,9            ; Вывод сообщения без пробелов
  lea dx,msg+2        ; Символы начинаются со второго байта
  int 21h
.exit 0
end
