org 0x7c00
jmp 0x0000:start

data:
    n times 16 db 0
    resultado times 64 db 0
    res times 16 db 0

start:
    xor ax, ax
    mov ds, ax

    ;lendo entrada n
    mov di, n
    call gets
    mov si, n
    call prints
    call barraN

    ;transformando em inteiro
    mov si, n
    call stoi               ;retorna o valor inteiro e é colocado em ax
    mov cx, ax              ;iniciando contador (inicia no valor máx para ser decrementado)

    call fibonacci
    mov ax, [resultado]     ;colocando o resultado no registrador p/ calcular mod
    call mod11

    ;transf. resultado em string
    ;mov ax, [resultado]    ;não precisa dessa linha, pois o inteiro já está em ax
    mov di, resultado
    call tostring
    mov si, resultado
    call prints

    call fim


mod11:
    cmp ax, 11          ; ax(resultado) == 11?
        jb .achei       ; se ax < 11, ax = ax mod 11
    sub ax, 11          ; ax = ax - 11
    jmp mod11

    .achei:
        ret


fibonacci:
    cmp cx, 3 
    jb .base ;contador < 3 == casos bases

    mov ax, 1 ;inicializando casos bases para calcular fib(n)
    mov bx, 1
    jmp .fib
    
    ;casos bases do fibonacci
    .base:
        mov byte[resultado], 1
        ret

    ;calculando fib(n) para n > 2
    .fib:
        cmp cx, 2      ; o contador inicia em n e vai diminui até 2 
            je .end    ; (casos 1 e 2 são casos bases, logo a operação fib() é feita apenas n - 2 vezes)

        push bx        ; salva bx
        add bx, ax     ; bx = bx + ax
        pop ax         ; ax = bx antigo (salvo na pilha)
        dec cl         ; decrementa contador
        jmp .fib

        .end:
            mov [resultado], bx     ;último valor de bx é o resultado
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
        add ax, cx 
        jmp .loop1
    .endloop1:
        ret

reverse:             
    mov di, si
    xor cx, cx          
    .loop1:            
        lodsb
        cmp al, 0
        je .endloop1
        inc cl
        push ax
        jmp .loop1
    .endloop1:
    .loop2:            
        cmp cl, 0
        je .endloop2
        dec cl
        pop ax
        stosb
        jmp .loop2

    .endloop2:
        ret

tostring:             
    push di
    .loop1:
        cmp ax, 0
        je .endloop1
        xor dx, dx
        mov bx, 10
        div bx           
        xchg ax, dx       
        add ax, 48        
        stosb
        xchg ax, dx
        jmp .loop1
    .endloop1:
        pop si
        cmp si, di
        jne .done
        mov al, 48
        stosb
    .done:
        mov al, 0
        stosb
        call reverse
        ret


getchar:
    mov ah, 0x00
    int 16h
    ret

printchar:
    mov ah, 0xe
    int 10h
    ret

delchar:
    mov al, 0x08
    call printchar
    mov al, ''
    call printchar
    mov al, 0x08
    call printchar
    ret

barraN:
    mov al, 0x0a
    call printchar
    mov al, 0x0d
    call printchar

    ret

gets:
    xor cx, cx ;contador = 0
    mov al,0
    .loop:
        call getchar
        inc cx
        stosb
        call printchar
        cmp al, 0x0d ;0x0d = 13 = enter
            je .done

        jmp .loop
    .done:
        call printchar
        dec di
        mov al, 0
        stosb
        ret
    
prints:
    .loopp:
        lodsb
        cmp al, 0
        je .end 
        call printchar
        jmp .loopp
    
    .end:
        ret

fim:
    jmp $

times 510 - ($ - $$) db 0
dw 0xaa55