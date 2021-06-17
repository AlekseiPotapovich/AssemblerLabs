.MODEL flat, stdcall
.STACK 100h
.DATA  
msg1 DB "Enter first operand: ",0Dh,0Ah,'$'
msg2 DB 0Dh,0Ah,"Enter second operand: ",0Dh,0Ah,'$'
msg3 DB 0Dh, 0Ah,"Enter operations: ",0Dh,0Ah,'$'
msg4 DB 0Dh,0Ah,"Result: ",0Dh,0Ah,'$'
msg5 DB 0Dh,0Ah,"Error",0Dh,0Ah,'$'
msg6 DB 0Dh,0Ah,"OVERFLOW",0Dh,0Ah,'$' 
msg7 DB 0Dh,0Ah,"Please, input number with sign", '$'
max_length equ 8
 
first_operand_str DB max_length dup('$')
second_operand_str DB max_length dup('$') 
answer_str DB 0Dh,0Ah,"+00000000", '$'
operation DB 4 dup('$')

first_operand DW 0
second_operand DW 0  

limit DW 0

ten DB 010h
isError DB 0
isNegative DB 0 

isSignNumber DB 0
isOverFlow DB 0
isSecondSing DB 0




.CODE   

str_output macro current_str 
    push ax
    mov ah, 09h
    lea dx, current_str
    int 21h
    pop ax
endm

str_input macro current_str   
    push ax
    mov ah, 0Ah
    lea dx, current_str
    int 21h
    pop ax
endm

str_check macro current_str    
   local @str_is_negative, @check_plus, @shift_plus, @goNextCheck, @goCheckSign, @negative, @error, @goEnd, @singNumber 
   push bx
   mov si, 2
   mov ax, 0
   mov isSecondSing, 0 
   ;clc
   mov isNegative, 0
   cmp current_str[si], '-' 
     mov limit, 65535
     je @str_is_negative      
     jne @check_plus
   @str_is_negative: 
     mov limit, 32768
     mov isNegative, 1
     mov isSignNumber, 1
     mov isSecondSing, 1
     ;stc
     inc si
     ;mov si, 1
     jmp @goNextCheck
   @check_plus:
     cmp current_str[si], '+'
        je @shift_plus
        ;clc
        jne @goNextCheck
     @shift_plus:
        mov isSignNumber, 1
        mov isSecondSing, 1
        mov limit, 32767
        ;stc
        inc si
   @goNextCheck:
     cmp current_str[si], '0'
        jl @error
     cmp current_str[si], '9'
        jg @error
     mov bx, 10
     mul bx
     jo @error   
     mov bx, 0
     mov bl, current_str[si]
     sub bl, '0'
     add ax, bx
     ;jo @error
     inc si
     cmp current_str[si], '$'    
        ;je @goEnd
        je @goCheckSign
        jne @goNextCheck 
   @goCheckSign:
     cmp isNegative, 1
        je @negative
        jne @goEnd 
     @negative:
        neg ax 
        ;mov , 0  
        jmp @goEnd      
   @error:
     mov isError, 1 
   @goEnd:
     pop bx
endm
   
str_preparation macro current_str  
    mov si, 1
    xor bx,bx
    mov bl, current_str[si]
    add si, bx
    inc si
    mov current_str[si], '$'
    mov isError, 0
endm

operation_add macro
    local @error, @goEnd, @go_withoutS, @isOver 
    mov ax, first_operand
    cmp isSignNumber, 0
    je @go_withoutS
    ;jne @signNumber
    
    add ax, second_operand
    jo @error
    ;jc @error
    jmp @goEnd
    @go_withoutS:
      add ax, second_operand
      jo @error
      jmp @goEnd  
    @error:
        mov isError, 1 
    @isOver:
        mov isOverFlow, 1
           
    @goEnd:  
endm 

operation_sub macro
    local @error, @goEnd
    mov ax, first_operand 
    sub ax, second_operand
    jo @error
    jmp @goEnd 
    @error:
        mov isError, 1
    @goEnd:    
endm

check_sign_operands macro   
    local @first_negative, @first_active, @go_next, @go_end, @second_negative, @second_active
    cmp first_operand, 0
        jl @first_negative
        jge @first_active
    @first_negative:
        mov isNegative, 1
        neg first_operand
        jmp @go_next
    @first_active:
        mov isNegative, 0
    @go_next:
    cmp second_operand, 0
        jl @second_negative
        jge @go_end
    @second_negative:
        xor isNegative, 1
        neg second_operand    
    @go_end:    
endm

operation_mul macro
    local @error, @goEnd
    check_sign_operands
    mov ax, first_operand
    mul second_operand
    jo @error 
    jmp @goEnd
    @error:
        mov isError, 1  
    @goEnd:    
endm 

operation_div macro
    local @error, @goEnd
    xor dx,dx
    check_sign_operands
    mov ax, first_operand
    div second_operand  
    xor dx,dx
    ;add dl, 04h
    ;mov ah,dl   
    jo @error
    jmp @goEnd
    @error:
        mov isError, 1
    @goEnd:
endm


add_symbol macro
    local @add_ah_55, @go_next, @add_ah_48, @add_al_55, @add_al_48, @go_end 
    cmp ah, 9
    jg @add_ah_55
    jle @add_ah_48
    @add_ah_55:
        add ah, 037h  
        jmp @go_next
    @add_ah_48:
        add ah, 030h   
    @go_next:
    
    cmp al, 9
    jg @add_al_55
    jle @add_al_48
    @add_al_55:
        add al, 037h
        jmp @go_end
    @add_al_48:
        add al, 030h
    @go_end:
    mov answer_str[si], ah
    dec si
    mov answer_str[si], al
    dec si
    
    
endm


convert_str_to_int macro
    local @skip_negative, _loop, @add_minus, @add_plus, @output_str, @delete_this, @go_end, @error 
    cmp ax, 0 
    jg @skip_negative
    neg ax
    mov isNegative, 1
    
    cmp isOverFlow, 1
    je @error
    
    @skip_negative:
    mov bx, 0
    mov si, 10
    
    mov bl, ah    
    mov bh, 0
    mov ah, 0
    div ten   
    add_symbol   
    
    mov ax, bx
    div ten
    add_symbol
    
    mov al, dl
    mov ah, 0
    div ten
    add_symbol
    
    
    mov al, dh
    mov ah, 0
    div ten
    add_symbol    
    
    cmp isNegative, 1
        je @add_minus
        jne @add_plus
    @add_minus:
        mov answer_str[si], '-'
        jmp @output_str
    @add_plus:
        mov answer_str[si], '+' 
    @output_str:
    
    mov si, 0    
    cmp answer_str[si], '$'
        je @delete_this
        jne @go_end
                           
    @delete_this:
        mov answer_str[si], ' '
    
    
    @go_end:
    str_output answer_str
    @error:
        mov isError, 1            
endm

begin:
    mov ax, @data
    mov ds, ax
    mov es,ax
    xor ax,ax
    
    firstInput:  
        str_output msg1   
        str_input first_operand_str  
        str_preparation first_operand_str   
        str_check first_operand_str   
        cmp isError, 1
            je output_error
            jne go_input_second
        output_error:
            str_output msg5
            jmp firstInput
    go_input_second:
        ;mov bx, 65535
        cmp limit, ax
        jo output_error
        jle good_input  
        good_input:
          mov first_operand, ax
            
    secondInput:
        str_output msg2
        str_input second_operand_str
        str_preparation second_operand_str
        str_check second_operand_str 
        
        cmp isError, 1
            je _output_error
            jne go_input_operation
        _output_error:
            str_output msg5
            jmp secondInput
        output_singError:
            str_output msg7
            jmp secondInput      
     go_input_operation: 
        cmp isSignNumber, 0
          jne chekSign
        cmp limit, ax
          jo _output_error
          jle good_input2
     good_input2: 
          mov second_operand, ax
          jmp thirdInput       
         
        chekSign: ;proverit elst' li znak y nashego number
          cmp isSecondSing, 0
            je output_singError
          cmp limit, ax
            jo _output_error
            jmp good_input2
          
       
     thirdInput:   
        str_output msg3
        str_input operation
        xor bx,bx
        mov si, 1
        mov bl, operation[si]
        mov isError, 0
        cmp bl, 1   
            jne __output_error
        inc si
        
        mov isNegative, 0
            
        _go_check_add:    
        cmp operation[si], '+'
            je _operation_add
            jne _go_check_sub
        _operation_add:
            xor dx,dx
            operation_add
            jmp _check_error
            
        _go_check_sub:             
        cmp operation[si], '-'
            je _operation_sub
            jne _go_check_mul
        _operation_sub:
            xor dx,dx
            operation_sub
            jmp _check_error
        
        _go_check_mul:    
        cmp operation[si], '*'
            je _operation_mul
            jne _go_check_div
        _operation_mul:
            operation_mul
            jmp _check_error
            
        _go_check_div:    
        cmp operation[si], '/'
            je _operation_div  
            jne __output_error
        _operation_div:
            cmp second_operand, 0
            je __output_overflow
            operation_div
            jmp _check_error
  
        _check_error:
            cmp isError, 1
                je __output_overflow
                jne _output_end_answer
        
        
        __output_overflow:
            str_output msg6
            jmp _goEnd
            
        __output_error:
            str_output msg5
            jmp thirdInput 
       
       _output_end_answer:
       
       mov bx, ax     
       convert_str_to_int
        
       _goEnd: 
       mov ah, 4ch
       int 21h
end begin