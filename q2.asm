org 0x7c00
jmp 0x0000:start


data:
    string times 16 db 0
    qtd_char times 16 db 0
    tamanho_str times 16 db 0

start:
    mov ax, 0 ; ou xor ax,ax
    mov ds, ax ;ds não pode ser inicializado diretamente

    ;lendo a palavra
    mov di, string
    call gets
    mov si, string
    call prints
    call barraN
    
    ;lendo o caracter a ser encontrado
    call getchar
    mov bx, ax
    call printchar
    call barraN

    ;qtd de vezes que o char aparece
    xor cx, cx
    mov si, string
    call encontrarchar
    
    ;fração
    mov ax, '/'
    call printchar

    ;tamanho da palavra
    xor cx, cx
    mov si, string
    call encontrar_tamanhototal

    call fim


encontrarchar:
    .for:
        lodsb
        cmp al,0        ; al == fim da string?
            je .cabou
        cmp al, bl      ; al == char que eu quero?
            je .achouletra
        jmp .for

        .achouletra:
            inc cl      ; incrementa contador
            jmp .for
    .cabou:
        ; transformando contador em inteiro
        mov ax, cx
        mov di, qtd_char
        call tostring
        mov si, qtd_char
        call prints
        ret

encontrar_tamanhototal:
    .for2:
        lodsb
        cmp al,0    ; al == fim da string?
            je .cabou2
        inc cl      ; incrementa contador
        jmp .for2
    
    .cabou2:
        ; transformando contador em inteiro
        mov ax, cx
        mov di, tamanho_str
        call tostring
        mov si, tamanho_str
        call prints
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