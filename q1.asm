org 0x7c00
jmp 0x0000:start
bandeira db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 7, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 8, 7, 8, 8, 8, 8, 0, 0, 0, 0, 8, 8, 0, 0, 0, 0, 8, 8, 8, 8, 3, 1, 8, 8, 8, 8, 1, 8, 0, 0, 0, 0, 0, 0, 8, 8, 1, 3, 9, 9, 8, 1, 9, 8, 0, 0, 0, 0, 0, 0, 8, 8, 9, 9, 15, 15, 9, 9, 9, 8, 0, 0, 0, 0, 8, 0, 8, 9, 9, 9, 9, 3, 9, 9, 9, 1, 0, 0, 0, 0, 8, 8, 8, 9, 15, 15, 15, 3, 9, 9, 9, 1, 0, 0, 0, 0, 8, 0, 8, 9, 9, 9, 15, 15, 9, 9, 3, 8, 0, 0, 0, 0, 8, 8, 8, 8, 8, 9, 9, 9, 9, 8, 8, 0, 0, 0, 0, 0, 8, 8, 8, 0, 0, 8, 1, 9, 9, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

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

ativar_modo_video:

    mov ah, 0
    mov al, 13h
    int 10h

ret

mudar_cor_tela:
    
    mov ah, 0xb
    mov bh, 0
    mov bl, 1
    int 10h

ret

loop:

    mov cx, 0
    inc dx
    cmp dx, 16
    je .done

    .loop1:

        lodsb
        mov ah, 0ch
        inc cx
        int 10h
        cmp cx, 16
        je loop
        jmp .loop1

    .done:
        jmp $


start:

    xor ax, ax
    xor bx, bx
    mov cx, ax
    mov dx, ax
    mov ds, ax
    mov es, ax
    
    call ativar_modo_video
    ;call mudar_cor_tela

    mov dx, 0
    mov si, bandeira

    jmp loop


times 510 - ($ - $$) db 0
dw 0xaa55