TITLE EDUARDO PERUCELLO(RA:22009978) E FELIPE KONDA(RA:22008026)
.MODEL SMALL
.DATA
    MSG DB 'BEM VINDO AO PROJETO DA CALCULADORA EM ASSEMBLY$'
    MSG1 DB 'ENTRE COM O PRIMEIRO NUMERO->$'
    MSG2 DB 'ENTRE COM O SEGUNDO NUMERO->$'
    MSG3 DB 'ENTRE COM A OPERACAO->$'
    MSG4 DB 'RESULTADO->$'
.CODE
pulalinha macro
    MOV AH,02
    MOV DL,10
    INT 21h
    endm

MAIN PROC 
    MOV AX,@data
    MOV DS,AX
    MOV AH,0
    MOV AL,06h  
    INT 10H
    MOV AH,0Bh   
    MOV BH,0
    MOV BL,0
    INT 10h
    MOV BH,1
    MOV BL,1
    INT 10H
    MOV AH,09
    LEA DX,MSG
    INT 21h
    pulalinha
    MOV AH,09h
    LEA DX,MSG1
    INT 21h

    MOV AH,01
    INT 21H
    AND AL,0FH
    MOV BH,AL

    pulalinha

    MOV AH,09h
    LEA DX,MSG2
    INT 21h

    MOV AH,01
    INT 21h
    AND AL,0FH
    MOV BL,AL 

    pulalinha

    MOV AH,09h
    LEA DX,MSG3
    INT 21h

    MOV AH,01
    INT 21h

    MOV CH,AL
    CMP CH,"+"
    JNZ N_SOMA
    CALL SOMA
    JMP FIM

    pulalinha

N_SOMA:
    CMP CH,"-"
    JNZ N_SUB
    CALL SUBTRACAO

N_SUB:
    CMP CH,"*"
    CALL MULTIPLICA

FIM:
    MOV AH,4ch
    INT 21H
MAIN ENDP

RESUL PROC

    xor ch,ch 
    mov ax,cx
    mov ch,10
    div ch 
    
    mov cl,al   
    mov ch,ah   

    mov ah,09h
    lea dx,MSG4 
    int 21h

    mov ah,02h 
    mov dl,bl
    int 21h

    mov ah,02h 
    or cl,30h 
    mov dl,cl 
    int 21h

    mov ah,02h 
    or ch,30h 
    mov dl,ch
    int 21h
    
    jmp FIM
RESUL ENDP


SOMA PROC
    ADD BH,BL
    MOV CL,BH
    MOV BL,"+"

    pulalinha    
    JMP RESUL
RET
SOMA ENDP 

SUBTRACAO PROC
 
    SUB BH,BL
    MOV CL,BH
    JS NEGA
    MOV BL,"+"
    pulalinha

    JMP RESUL
NEGA:
    NEG CL
    MOV BL,"-"
    pulalinha
    JMP RESUL 


    RET 
SUBTRACAO ENDP 

MULTIPLICA PROC
    MOV CH,0
    MOV CL,BL
    MOV BL,0
    JMP PT1

TOPO:   
    SHL BH,1 
    INC BL
PT1:
    ROR CL,1
    JNC CAR0
    JC CAR1
CAR1:
    ADD CH,BH
    CMP BL,3
    JNZ TOPO
    MOV CL,CH
    MOV BL,"+"
    JMP RESUL
CAR0:
    OR CH,00H
    CMP BL,3
    JNZ TOPO
    MOV CL,CH
    MOV BL,"+"
    pulalinha
    JMP RESUL
RET                 
MULTIPLICA   ENDP

END MAIN