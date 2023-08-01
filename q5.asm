org 0x7c00            ;
jmp _start

_data:    
	number times 4 db 0 


_start:
    xor ax, ax     ; limpa reigistradores
    mov ds, ax
    mov es, ax

    mov di, number   ; coloca em si o endereço de hello
    call gets
    
    mov si, number 
    call stoi
    
    mov cx, ax
    
    call putcharC
    call putcharO
    call putcharM
    call putcharO
    call putcharNULL
    call putcharE
    call putcharNULL
    call putcharF
    call putcharA
    call putcharC2
    call putcharI
    call putcharL
    call putcharNULL
    call putcharT
    call putcharR
    call putcharO
    call putcharC2
    call putcharA
    call putcharR
    call putcharNULL
    call putcharD
    call putcharE
    call putcharNULL
    call putcharC2
    call putcharO
    call putcharR
    
    
    call _fim
             

putcharC: 
    mov ah, 0
    mov al, 18
    int 10h 
    
    
    mov ah, 0xe 
    mov al, 'c'
    mov bh, 0
    mov bl, cl
    int 10h
  ret


putcharC2: 
  
    mov ah, 0xe 
    mov al, 'c'
    mov bh, 0
    mov bl, cl
    int 10h
  ret


putcharO: 
    
    
    mov ah, 0xe 
    mov al, 'o'
    mov bh, 0
    mov bl, cl
    int 10h
  ret


putcharM: 
   
    mov ah, 0xe 
    mov al, 'm'
    mov bh, 0
    mov bl, cl
    int 10h
  ret
 

putcharE: 
  
    mov ah, 0xe 
    mov al, 'e'
    mov bh, 0
    mov bl, cl
    int 10h
  ret  
 
 

putcharT: 
  
    mov ah, 0xe 
    mov al, 't'
    mov bh, 0
    mov bl, cl
    int 10h
  ret 
 

putcharR: 
  
    mov ah, 0xe 
    mov al, 'r'
    mov bh, 0
    mov bl, cl
    int 10h
  ret 
  
putcharD: 
  
    mov ah, 0xe 
    mov al, 'd'
    mov bh, 0
    mov bl, cl
    int 10h
  ret 
  
putcharF: 
    
    mov ah, 0xe 
    mov al, 'f'
    mov bh, 0
    mov bl, cl
    int 10h
  ret  
  
putcharA: 
  
    
    mov ah, 0xe 
    mov al, 'a'
    mov bh, 0
    mov bl, cl
    int 10h
  ret  

putcharI: 
   
    mov ah, 0xe 
    mov al, 'i'
    mov bh, 0
    mov bl, cl
    int 10h
  ret  
 
putcharL: 
   
    mov ah, 0xe 
    mov al, 'l'
    mov bh, 0
    mov bl, cl
    int 10h
  ret  
putcharNULL:  
   
    mov ah, 0xe 
    mov al, ''
    mov bh, 0
    mov bl, cl
    int 10h
  ret 
  
gets:
    xor cx, cx

    .loop1:
        call getchar
        cmp al, 0x08
        je .backspace
        cmp al, 0x0d
        je .done
        cmp cl,50
        je .loop1
        stosb
        inc cl
        call putchar
        jmp .loop1

        .backspace:
            cmp cl, 0
            je .loop1
            dec di
            dec cl
            mov byte[di], 0
            call delchar
            jmp .loop1
    
    .done:
        mov al,0
        stosb
        call endl
    ret

endl:
    mov al, 0x0a ;10 = nova linha
    call putchar
    mov al, 0x0d ;13 = carriage return
    call putchar
    ret
    
delchar:

    mov al, 0x08
    call putchar

    mov al, ' '
    call putchar

    mov al, 0x08
    call putchar

ret

stoi:
    xor cx, cx
    xor ax, ax
    .loop1:
        push ax
        lodsb
        mov cl, al
        pop ax
        cmp cl, 0
        je .endloop1

        sub cl, 48
        mov bx, 10
        mul bx
        add ax,cx
        jmp .loop1

    .endloop1:
        ret 
getchar:
    mov ah, 0x00
    int 16h
    ret
putchar:
	mov ah, 0x0e
	int 10h
	ret
	
_fim:
    jmp $                  ; jmp $ é uma forma de terminar o programa.

times 510-($-$$) db 0
dw 0xaa55
