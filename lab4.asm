.model tiny

.code

org 100h         
        
jmp start
Lvl      db '                                                                             '
         db '   ++++    +  +++      ++   +     ++  ++       +  +++      +  +  +     ++++++'  
         db '                                                                             '
         db '                                                                             '
         db '                                                                             '
         db '          ++     ++                            +  + ++                     ++'
         db '                                                                             '
         db ' ++++              +++      +++     +     ++                    +++     ++   '
         db '                                                                             '
         db '                                                                             '
         db '                                                                             ' 
         db '          +++                     +        +      +++     ++                 '
         db '                                                                             '
         db '                                                                             '
         db '                                      +                                      ' 
         db '                                                                             '
         db ' +++               +++     +++           +     ++++      ++        +++       '
         db '                                                                             '
         db '                                                                             '
         db '                                                                             '
         db '                                                                             '
         db '   ++++    +  +++      ++   +     ++  ++       +  +++      +  +  +     ++++++'  
         db '                                                                             '
         db '                                                                             '
         db '                                                                             '
         db '          ++     ++                            +  + ++                     ++'
         db '                                                                             '
         db ' ++++              +++      +++     +     ++                    +++     ++   '
         db '                                                                             '
         db '                                                                             '
         db '                                                                             ' 
         db '          +++                     +        +      +++     ++                 '
         db '                                                                             '
         db '                                                                             '
         db '                                      +                                      ' 
         db '                                                                             '
         db ' +++               +++     +++           +     ++++      ++        +++       '
         db '                                                                             '
         db '                                                                             '
         db '                                                                             '
            
                                      



msgEnd  db 'Game Over!'
s_size  equ     25    
lvlstr dw 25 dup(0)
lvlstrCostil dw 0

traceStr dw 35 dup(' ') 

traceCostil  dw '    '                                  

x db ? 

left  db 'a'
right db 'd'
exit db 27 

timeSec db 0
timeSec1 db 0
timeSec2 db 0
timeSec3 db 0
timeSec4 db 0

Time db 'Time: ' 

times db 0                                     
EndGameFlag db 0

old_handler dd ?
   
countTrace db 10 

border  dw ' ' 

flagRight  db 0

speed dw  60000

hellomsg db 'Control: a - left, d- right', 0dh,0ah
         db   ' The road is grey' , 0dh,0ah
         db  'Entering the green field is death$'

    
procLeft proc
 loopleft:    
    mov ah,22h           
    mov al,' '  
    mov word ptr es:[di],ax 
    add di,2
    loop loopleft
    ret
procLeft endp

procRight proc
 loopRight:
    mov ah,22h           
    mov al,' '
    mov word ptr es:[di],ax 
    add di,2
    loop loopRight
    ret
procRight endp   

procCenter proc
    loopcenter:    
    mov ah,70h           
    mov al,[si]
    mov word ptr es:[di],ax 
    add di,2
    inc si
    loop loopcenter  
    ret
procCenter endp 

newTime proc
    pusha
    pushf
    
    mov al,[EndGameFlag]
    cmp al,0
    je  endTime
    mov al,[Times]
    cmp al,18
    je  ready
    inc al
    mov [times],al
    jmp endTime 
    
ready:    
    mov [times],0 
    xor di,di
    mov ax,0B800h
    mov es,ax
    mov al,'u'
    mov ah,30h
    mov word ptr es:[di],ax  
    mov al,[timeSec]
    cmp al,9 
    je  t1
    inc al
    mov [timeSec],al  
               
printTime:
    mov cx,7
    lea si,Time  
loopTime:
    mov ah,30h
    mov al,[si]
    inc si
    mov word ptr es:[di],ax 
    add di,2
    loop loopTime      
    
    mov al,[timeSec4]
    add al,30h                
    call timeProc
    mov al,[timeSec3]
    add al,30h                
    call timeProc
    mov al,[timeSec2]
    add al,30h                
    call timeProc
    mov al,[timeSec1]
    add al,30h                
    call timeProc
    mov al,[timeSec]
    add al,30h                
    call timeProc
    
endTime:
    popf
    popa
    jmp dword ptr cs:[old_handler]
    iret
   
t1:
   mov [timeSec],0 
   mov al,[timeSec1]
   cmp al, 9
   je t2
   inc al
   mov [timeSec1],al
   mov ax, [speed]
   cmp ax,20000
   je  printTime
   sub ax,5000
   mov [speed],ax
   jmp printTime
t2: 
   mov [timeSec1],0
   mov al,[timeSec2]
   cmp al, 9
   je t3
   inc al
   mov [timeSec2],al
   jmp printTime
t3:
   mov [timeSec2],0 
   mov al,[timeSec3]
   cmp al, 9
   je t4
   inc al
   mov [timeSec3],al
   jmp printTime
t4: 
   mov [timeSec3],0
   mov al,[timeSec4]
   inc al
   mov [timeSec1],al
   jmp printTime    
newTime endp

timeProc proc
    mov ah,30h
    mov word ptr es:[di],ax 
    add di,2
    ret
timeProc endp 

       
start:

    lea dx,hellomsg
    mov ah,09h
    int 21h
    
    xor ax,ax
    mov ah,01h
    int 21h 


    mov ah, 1
    mov ch, 20h
    mov cl, 0bh 
    int 10h
                                        
    mov ax,0003h        
    int 10h      
    
    xor ax,ax
	  mov ax,3508h
    int 21h
    mov old_handler,bx
    mov old_handler+2,es 
                    
    mov ax,2508h
    mov dx, offset newTime
    int 21h 
    
 begin:      
    mov al, 80
    mov [x],al    
    mov ax,0B800h
    mov es,ax 
    mov [EndgameFlag],1
next:

    
    xor di,di
    mov ax,0B800h
    mov es,ax 
looplvl1:     
    xor cx, cx
    add cx, 25 
    lea si,lvlstr  
    lea di,tracestr 
    add di,20    
    mov bx,[di]
    add di,2
    push di
    xor di,di 
    add di,160  
    xor bh,bh   
print:   
    push cx
    mov ax,[si]
    push si
    lea si,lvl
    add si,ax
    mov cx, bx
    add si, bx
 
    call procLeft
    mov cx, 20
  
    call procCenter
    xor cx, cx
    mov cx, 80
    sub cx, 20
    sub cx, bx

      
    call procRight
     
    xor ax,ax
    mov ax, di
    pop si 
    pop cx
    pop di    
    mov bx,[di]
    xor bh,bh
    add di,2
    push di
    mov di,ax
    add si,2
    loop print 
    
    xor di,di
    mov ax,0B800h
    mov es,ax
    xor ax,ax
    xor di,di
    add di,3840
    mov al,[x]
    add di,ax 
    mov al,23h
    mov ah,1eh
    mov word ptr es:[di],ax  

   
    
    mov cx,24 
    lea di,lvlstr
    mov bx,[di]
sdvigg:       
    add di,2
    mov ax, bx
    mov bx, [di]
    mov [di],ax
    loop sdvigg
    
  

    mov  bx,38
    in   ax,40h
    xor  dx,dx
    div  bx    
    mov  ax, dx
    mov  dl,80    
    mul  dl  
    sub  di,48
    mov  [di],ax 
    
    mov cx,34 
    lea di,tracestr
    mov bx,[di]
sdvigTrace:       
    add di,2
    mov ax, bx
    mov bx, [di]
    mov [di],ax
    loop sdvigTrace
    
    mov al,[countTrace]
    cmp al,10
    je  randomTrace
    inc al
    mov [countTrace],al
              
    mov ax,[speed]
    mov cx,ax     
delay1: 
    mov     ah, 01h
    int     16h
    jnz     key
delay2:    
    jmp    check
delay:
    cmp cx,0
    jne delay1 
        
             
    jmp  next  
    
  
key:
   mov  ah, 00h
   int 16h 
   mov ah,[right]
   cmp al, ah
   je goRight
   mov ah,[left]
   cmp al,ah
   je goLeft 
   mov ah, [exit]
   cmp al, ah
   je _exit 
   jmp delay1        

goRight:
    xor di,di
    mov ax,0B800h
    mov es,ax
    xor ax,ax
    xor di,di
    add di,3840
    mov al,[x] 
    add al,2 
    mov [x],al
    add di,ax
    mov al,' '
    mov ah,70h 
    mov word ptr es:[di-2],ax 
    mov al,23h
    mov ah,1eh
    ;mov al,01h
    ;mov ah,2eh   
    mov word ptr es:[di],ax 
    jmp delay2
goLeft:
    xor di,di
    mov ax,0B800h
    mov es,ax
    xor ax,ax
    xor di,di
    add di,3840
    mov al,[x] 
    sub al,2
    mov [x],al
    add di,ax
    mov al,' '
    mov ah,70h 
    mov word ptr es:[di+2],ax 
    mov al,23h
    mov ah,1eh
    mov word ptr es:[di],ax    
    jmp delay2
     
     
check:
   lea di, lvlstr
   add di, 48  
   mov ax,[di]
   lea si, lvl
   add si,ax
   xor ah,ah
   mov al,[x] 
   mov dl,2
   div dl  
   add si,ax
   mov bx,[si]
   cmp bl,' '
   jne endgame
   sub cx,2
   lea di,tracestr  
   add di,68
   mov bx,[di]
   cmp ax,bx
   jle endgame
   add bx,20
   cmp ax,bx
   jge  endgame
   jmp delay
    
endgame:
   mov ah, 1
   mov ch, 20h
   mov cl, 0bh 
   int 10h                                    
   mov ax,0003h 
    
   mov [endGameFlag],0 
   
   mov [TimeSec],0
   mov [timesec1],0
   mov [TimeSec2],0
   mov [timesec3],0
   mov [TimeSec4],0 
                                       
   ;mov ax,0003h    
   ;int 10h  
   
   xor di,di
   mov ax,0B800h
   mov es,ax 
   mov  [flagRight],0 
   add di,366h 
   
   lea si,msgEnd  
   xor cx,cx
   add cx,10
msg:   
    mov al,[si]
    mov ah,30 
    mov word ptr es:[di],ax  
    add di,2
    inc si
    loop msg
    
    lea di,tracestr
    mov cx,37
reset:
    mov [di],' '
    add di,2
    loop reset
    
    lea di,lvlstr
    mov cx,27
resetlvl:
    mov [di],0
    add di,2
    loop resetlvl
    
    mov [x],80
    mov [speed],60000 
    xor ax,ax
    mov ah,01h
    int 21h 
     
   jmp begin    

randomTrace:
    
    mov [countTrace],0
    mov cx, 10 
    lea di,tracestr
    add di,20
    
    mov  bx,3
    in   ax,40h
    xor  dx,dx
    div  bx    
    mov  ax, dx
    cmp ax,1
    je  doNothing
    cmp ax,0
    je  loopLeftTrace     
loopRightTrace:
    mov ax,[di]
    mov bl, [flagRight]
    cmp bl, 1
    je loopLeftTrace
    sub di,2
    add ax,2
    mov [di],ax   
    loop loopRightTrace 
    mov [flagright],1
    jmp delay1 
loopLeftTrace:
    mov ax,[di]
    cmp ax,4
    jle loopRightTrace
    sub di,2
    sub ax,2
    mov [di],ax 
    mov  [flagRight],0  
    loop loopLeftTrace 
    jmp delay1 
     
doNothing:
   mov ax,[di]
   sub di,2
   mov [di],ax  
   loop doNothing
   jmp godelay 
 
goDelay:
   mov ax,[speed]
   cmp ax,20000
   jl  def   
   mov cx,ax
   jmp delay1  
def:
   mov cx,20000
   jmp delay1
     

_exit:
   
    mov ax, 0003h
    int 10h 
    mov ah, 4ch
    int 20h    
    
end start

 








