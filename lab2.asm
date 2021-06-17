;delete word befor known word
.model small
.stack 100h
.data  
msg1 db "Enter string: ",13,10,'$'
msg2 db "Enter word: ",13,10,'$' 
msg3 db "Result string: ",13,10,'$' 
not_found db "Word not found!",13,10,'$'
string db 200 dup(?)       
word db 80 dup(?)         
new_line db "",13,10,'$'


.code

start:
    mov ax,@data
    mov ds,ax 
    mov es,ax
   
    mov ah,9
    mov dx, offset msg1
    int 21h
    
    mov bx,0
    mov string[bx],' '
    inc bx 
    
     
    
    
loop1:;enter string
    mov ah,01h
    int 21h
    cmp al,13
    je loop2
   
    mov byte ptr string[bx],al
    cmp bx,198
    je loop2
    inc bx
   
    loop loop1   

loop2:;add $ to string 
    mov string[bx],' '
    
   inc bx
    mov string[bx],'$'
    
    mov ah,9
    mov dx,offset new_line
    int 21h
    
    mov bx,0
    mov ah,9
    mov dx, offset msg2
    int 21h 
     
loop3:;enter word
    mov ah,01h
    int 21h
    cmp al,13
    je loop4
    mov byte ptr word[bx],al
    inc bx
    loop loop3 
     
loop4:;add $ to word
    mov word[bx],'$'
    mov bx,0
    mov dx,0
    lea di,word    
    
next_word:
    mov di,0 
    mov cl,byte ptr string[bx]
    mov al,byte ptr word[di]
    cmp cl,al
    je find_space
    cmp cl,'$'
    je loop9; not_found1 
    inc bx
    inc si
    jmp next_word
        
    
find_space:
    dec bx
    mov cl,byte ptr string[bx]
    cmp cl,' '
    je inc_bx  
   ;je prev_space
    inc bx
    inc bx
    jmp next_word 
        
inc_bx:
    inc bx
    jmp find_word           
    
find_word:
    inc bx
    inc di
    mov cl,byte ptr string[bx]
    mov al,byte ptr word[di]
    mov si,bx
    push si
    cmp al,'$'
    je find_end_str
    cmp al,cl
    je find_word
    jmp find_end_str
    
find_end_str: 
    cmp cl,'$'
    je find_end_word
    ;jmp next_word 
find_spc_str:
    cmp cl,' '
    je find_end_word
    jmp next_word

find_end_word:
    cmp al,'$'                    
    je move_back
    inc dx
    jmp next_word

move_back:
    dec bx
    ;cmp bx,0
    ;je exit
    mov cl,byte ptr string[bx]
    xor si,si  
    cmp cl,' '
    ;je prev_space
    je remove
    jmp move_back
    
prev_space:
   ; dec bx
    mov cl,byte ptr string[bx-1]      
    cmp cl,' '
    je remove
    ;inc si
    jmp inc_si
    
inc_si:
    dec bx
    mov cl,byte ptr string[bx]
    cmp cl,' '
    je inc_bx1
    inc si
    loop inc_si    

remove:          
    cmp bx,0
    je loop8
    dec bx
    mov cl,byte ptr string[bx]
    cmp cl,' '   
    je prev_space
    ;je del_word       
    inc si      
    jmp inc_si  
    
inc_bx1:
    ;inc bx             
del_word:
    xor dl,dl
    mov dl,byte ptr string[bx+1+si]
    mov byte ptr string[bx],dl 
    cmp dl,'$'
    ;je loop6
    je loop8
    inc bx 
    loop del_word 
    
loop9:
    xor bx,bx
    xor dl,dl
        
                     
loop6:               
             
    ;xor dl,dl
    mov dl,byte ptr string[bx+1]
    mov byte ptr string[bx],dl 
    cmp dl,'$'
    je exit   
    ;je next_word
    inc bx
    loop loop6  
  
loop8:  
    mov bp,si   
    pop si
    xor bx,bx
    sub si,bp  
    mov bx,si
    jmp next_word
   ; loop loop8  
      
not_found1:
    mov ah,9 
    mov dx,offset new_line
    int 21h 
    mov ah,9 
    mov dx,offset not_found
    int 21h    
    mov ax,4c00h
    int 21h 
    ret
    
exit:      
    mov ah,9 
    mov dx,offset new_line
    int 21h           
    mov ah,9
    mov dx,offset msg3
    int 21h
    mov dx,0
    
    mov bx, 0 
     
loop7:   

            
    mov ah,9
    mov dx,offset string
    int 21h
    mov ax,4c00h
    int 21h 
    ret                                   
end start    
