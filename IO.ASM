.xlist  ;запрет записи этого файла в листинг
        ;Файл с макросами ввода - вывода, подключаемый к
        ;программе по директиве: include io.asm
        ;***********************************************************
        ;               ОКОНЧАНИЕ СЧЕТА ПРОГРАММЫ
        ;***********************************************************
        ;========================================
        ;Окончание счета программы
        ;обращение: finish
        ;на выходе: al - код завершения (можно игнорировать)
        ;----------------------------------------
extrn procnl:far
newline macro
        call far ptr procnl
        endm
        ;========================================
        ; переход на новую строку
        ; обращение: newline
        ; ---------------------------------------
outch macro c
      push dx
      push ax
      mov dl,c
      mov ah,2
      int 21h
      pop ax
      pop dx
      endm
        ;========================================
        ;Вывод символа
        ;      обращение:
        ;      где  С - i8,r8 или m8
        ;----------------------------------------
outch  macro c
       push dx
       push ax
       mov dl,c
       mov ah,2
       int 21h
       pop ax
       pop dx
       endm
  outstr macro
       push ax
       mov ah,9
       int 21h
       pop ax
       endm
        ;========================================
        ;Вывод целого со знаком размером в слово
        ;      обращение: outint num[,leng]
        ;      где num - выводимое число: i16,r16 или m16
        ;      leng - ширина поля вывода: i8,r8 или m8 (со значением>=0)
        ;Особенности вывода:
        ;если поле больше, чем надо, то слева добавляются пробелы,
        ;если меньше - выводится только число (целиком);
        ;по умолчанию leng=0
        ;----------------------------------------
       extrn procoutnum:far
outint macro num,leng
       outnum <num>,<leng>,1
       endm
        ;========================================
        ;Вывод целого без знака размером в слово
        ;      обращение: outword num [,leng]
        ;      num и leng - как в outint
        ;----------------------------------------
outword macro num,leng
        outnum <num>,<leng>,0
        endm
        ;========================================
        ;Вспомогательный макрос проверки написания имени
        ;разными (большими и малыми) буквами
        ;----------------------------------------
same macro name, variants, ans
     ans=0
     irp v,<variants>
     ifidn <name>,<v>
     ans=1
     exitm
     endif
     endm
     endm
        ;=========================================
        ;Вспомогательный макрос для outint (sign=1) и outword (=0)
        ;-----------------------------------------
outnum macro num,leng,sign
       local regdx?
       push ax
       push dx
       same <num>,<dx,DX,Dx,dX>,regdx?
       if regdx?               ;;out dx,leng -->
       ifb <leng>              ;;mov al,leng
       mov al,0                ;;xchg ax,dx
       else
       mov al,leng
       endif
       xchg ax,dx
       else                    ;;out num,leng (num<>dx) -->
       ifb <leng>              ;;mov dl,leng
       mov dl,0                ;;mov ax,num
       else
       mov dl,leng
       endif
       mov ax,num
       endif
       mov dh,sign
       call far ptr procoutnum         ;;ax=num, dl=leng, dh=sign
       pop dx
       pop ax
       endm
;***************************************************************
;                  ВВОД С КЛАВИАТУРЫ
;***************************************************************
;============================================
;Очистка буфера ввода с клавиатуры
;        обращение: flush
;--------------------------------------------
extrn procflush:far
 flush macro
       call far ptr procflush
       endm
;============================================
;Ввод символа (с пропуском концов строк, т.е. Enter)
;обращение: inch x
;    где x - r8,m8
;на выходе: x- введенный символ
;--------------------------------------------
extrn procinch:far
  inch macro 
       local regax?
       same <x>,<ah,AH,Ah,aH>,regax?
       if regax?
       xchg ah,al    ;;x=ah
       mov al,0
       call far ptr procinch
       xchg ah,al
       else
       same <x>,<al,AL,Al,aL>,regax?
       if regax?
       mov al,0     ;;x=al
       call far ptr procinch
       else
       push ax      ;; x- не ah и не al
       mov al,0
       call far ptr procinch
       mov x,al
       pop ax
       endif
       endif
       endm
;=======================================================
;Ввод целого числа (со знаком и без) размером в слово
;обращение: inint x
;     где x - r16,m16
;на выходе: x- введенное число
;особенности ввода:
;     пропускаются все пробелы и концы строк перед числом;
;     число должно начинаться с цифры, перед ней возможен знак;
;     при минусе число вводится как отрицательное;
;     ввод идет до первой нецифры (в т.ч. до ENTER), она глотается;
;     при ошибке будет печать сообщения и останов программы;
;ошибки: "нет цифры" - в числе нет ни одной цифры
;        "переполнение" - большое по модулю число
;        (вне отрезка [-32768,+65535])
;-------------------------------------------------------
extrn procinint:far
  inint macro x
        local regax?
        same <x>,<ax,AX,Ax.aX>,regax?
        if regax?
        call far ptr procinint
        else
        push ax
        call far ptr procinint
        mov x,ax
        pop ax
        endif
        endm
;=======================================================
;восстановить запись в листинг
.list