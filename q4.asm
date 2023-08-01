org 0x7c00
string times 16 db 0
string2 times 16 db 0

jmp 0x0000:start

getchar:
    mov ah, 0x00
    int 16h
    ret

putchar:
    mov ah, 0x0e ;modo de imprmir na tela
    int 10h ;imprime o que tá em al
    ret
;função que coloca um único caracter na tela

delchar:

    mov al, 0x08
    call putchar

    mov al, ' '
    call putchar

    mov al, 0x08
    call putchar

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
        mov al,0
        stosb
        call reverse
        ret
    
reverse:
    mov di, si
    xor cx,cx

    .loop1:
        lodsb
        cmp al,0
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

printString:

    .loop:
        lodsb
        cmp al, 0

        je .endloop
        call putchar

        jmp .loop

    .endloop:
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

loopando:

    lodsb
    cmp al, 0
        je .acabou

    cmp al, '-'
        je .guardando

    call somando

    jmp loopando

    .acabou:
        
        xor ax, ax

        mov cl, bl
        mov al, cl
        mov cl, 10
        
        div cl
        mov bl, ah
        add bl, al
        push bx

        mov bx, 0

        pop ax
        pop bx
        pop cx

        add ax, bx
        add ax, cx
        ;resultado esta em ax
        
        mov bl, al

        xor ax, ax
        xor cx, cx

        mov cl, bl
        mov al, cl
        mov cl, 10

        div cl
        add al, ah

        mov bl, al

        xor ax, ax
        xor cx, cx

        mov cl, bl
        mov al, cl
        mov cl, 10

        div cl
        add al, ah
        
        add ax, 48
        call putchar
        
        jmp $

    .guardando:

        xor ax, ax

        mov cl, bl
        mov al, cl
        mov cl, 10

        div cl
        mov bl, ah
        add bl, al

        push bx

        mov bx, 0

        jmp loopando

somando:

    sub al, 48
    add bl, al

ret

        
start:
    xor ax, ax
    xor bx, bx
    mov ds, ax
    mov es, ax

    mov di, string
    call gets

    mov si, string
    call loopando
   
    jmp $


times 510 - ($ - $$) db 0
dw 0xaa55