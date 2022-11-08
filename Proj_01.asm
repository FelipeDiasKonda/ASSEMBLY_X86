TITLE EDUARDO PERUCELLO(RA:22009978) E FELIPE KONDA(RA:22008026)
.MODEL SMALL
.DATA
    MSG DB 'BEM VINDO AO PROJETO DA CALCULADORA EM ASSEMBLY$'
    MSG1 DB 'ENTRE COM O PRIMEIRO NUMERO(0 a 9)->$'
    MSG2 DB 'ENTRE COM O SEGUNDO NUMERO(0 a 9)->$'
    MSG3 DB 'ENTRE COM A OPERACAO(+,-,* ou %)->$'
    MSG4 DB 'RESULTADO->$'
    MSGERRO DB 'DIVISAO POR 0$'
    MSGERRO2 DB 10,'ERRO NA LEITURA DA OPERACAO$'
    MSGQUOCIENTE DB 'QUOCIENTE ->$'
    MSGRESTO DB 'RESTO->$'
    PULALINHA2 DB 10,13
.CODE
pulalinha macro
    MOV AH,02
    MOV DL,10            ;Macro para pular linha
    INT 21h
    endm

MAIN PROC 
    MOV AX,@data         ;Inicializa o Data e move ele para AX
    MOV DS,AX            ;Move o que esta em AX(Data) para DS
    MOV AH,0
    MOV AL,06h  
    INT 10H
    MOV AH,0Bh   
    MOV BH,0             ;Funcao para trocar a cor do fundo
    MOV BL,0
    INT 10h
    MOV BH,1             ;FUncao para trocar a cor das letras
    MOV BL,1
    INT 10H
    MOV AH,09
    LEA DX,MSG           ;Printa a mensagem que esta contida em MSG
    INT 21h
    pulalinha
    MOV AH,09h
    LEA DX,MSG1          ;Printa a mensagem que esta contida em MSG1
    INT 21h

    MOV AH,01            ;Funcao para ler o primeiro numero
    INT 21H
    AND AL,0FH           ;Transforam o valor de AL em numeral
    MOV BH,AL            ;Salva o valor lido em BH

    pulalinha

    MOV AH,09h
    LEA DX,MSG2          ;Printa a mensagem que esta contida em MSG2
    INT 21h

    MOV AH,01            ;Funcao para ler o segundo numero
    INT 21h
    AND AL,0FH           ;Transforma o valor de AL em numeral
    MOV BL,AL            ;Salva o valor lido em BL

    pulalinha

    MOV AH,09h
    LEA DX,MSG3          ;Printa a mensagem que esta contida em MSG3
    INT 21h

    MOV AH,01            ;Funcao para ler a operacao que sera realizada
    INT 21h

    MOV CH,AL            ;Move o valor que esta em AL(esta armazenado a operacao escolhida) para CH
    CMP CH,"+"           ;Compara o valor de CH(operacao) com o sinal de '+'
    JNZ N_SOMA           ;Se nao for igual ele ira pular para a N_SOMA
    CALL SOMA            ;Chama o procedimento de Soma
    JMP FIM              

    pulalinha

N_SOMA:
    CMP CH,"-"           ;Compara o valor de Ch(operacao) com o sinal de '-'
    JNZ N_SUB            ;Se nao for igual ele ira pular para o N_SUB
    CALL SUBTRACAO       ;Chama o procedimento de subtracao

N_SUB:
    CMP CH,"*"           ;Compara o valor de CH(operacao) com o sinal de '*'
    JNZ N_MULT           ;Se nao for igual ele ira pular para o N_MULT
    CALL MULTIPLICA      ;Chama o procedimento de multiplicacao

N_MULT:
    CMP CH,"%"           ;Compara o calor de CH(operacao) com o sinal de '%'
    JNZ ERRO2            ;se nao for igual ele ira pular para o ERRO2
    jmp DIVIDE           ;Pula para o procedimento de dividir

FIM:
    MOV AH,4ch           ;Funcao para terminar o programa
    INT 21H

ERRO2:
MOV AH,09
LEA DX,MSGERRO2          ;Printa a mensagem que esta contida em MSGERRO2
INT 21H
JMP FIM                  ;Pula para o FIM

MAIN ENDP

RESUL PROC

    xor CH,CH            ;Zera o valor de CH 
    mov AX,CX            ;Move o valor que esta em CX para AX
    mov CH,10            ;Atribui o valor 10 para CH
    div CH              
    
    mov CL,AL            ;CL se torna cosciente
    mov CH,AH            ;CH se torna resto
    mov AH,09h
    lea DX,MSG4          ;Printa a mensagem que esta contida em MSG4
    int 21h
    
    mov AH,02h 
    mov DL,BL            ;Printa o valor movido de BL para DL
    int 21h
    
    mov AH,02h 
    or CL,30h            ;Transorma o valor de CL que esta em numeral em char
    mov DL,CL            ;Printa o valor movido de CL para DL
    int 21h

    mov AH,02h 
    or CH,30h            ;Transorma o valor de CH que esta em numeral em char
    mov DL,CH            ;Printa o valor movido de CH para DL
    int 21h
    
    jmp FIM              ;Pula para o FIM
RESUL ENDP


SOMA PROC
    ADD BH,BL            ;Soma os valores contidos em Bl com os de BH
    MOV CL,BH            ;Move o valor de BH para CL
    MOV BL,"+"           ;Move o sinal de '+' para ser printado depois

    pulalinha    
    JMP RESUL            ;Pula para o procedimento de resultado
RET
SOMA ENDP 

SUBTRACAO PROC
 
    SUB BH,BL            ;Subtrai os valores contidos em BL com os de BH
    MOV CL,BH            ;Move o valor de Bh para CL
    JS NEGA              ;Pula para o NEGA se o resultado for negativo
    MOV BL,"+"           ;Move o sinal de '+' para ser printado depois
    pulalinha

    JMP RESUL            ;Pula para o procedimento de resultado
NEGA:
    NEG CL               ;Transormar em negativo o valor de CL
    MOV BL,"-"           ;Move o sinal de '-' para ser printado depois 
    pulalinha
    JMP RESUL            ;Pula para o procedimento de resultado
RET 
SUBTRACAO ENDP 

MULTIPLICA PROC
    MOV CH,0             ;Atribui o valor 0 para CH
    MOV CL,BL            ;Move o valor que esta em Bl para CL
    MOV BL,0             ;Atribui o valor 0 para BL
    JMP PT1              ;Pula para o PT1

TOPO:   
    SHL BH,1             ;Pula uma casa para a esquerda do valor que esta em BH
    INC BL               ;Soma 1 em BL
PT1:
    ROR CL,1             ;Rotaciona uma casa para a direita do valor que esta em CL
    JNC CAR0             ;Pula se nao tiver CARRY para o CAR0
    JC CAR1              ;Pula se tiver CARRY para o CAR1
CAR1:  
    ADD CH,BH            ;Soma os valores que esta em BH com os de CH
    CMP BL,3             ;Compara o valor que esta em Bl com 3
    JNZ TOPO             ;Se nao for igual ele pula para o TOPO para reiniciar
    MOV CL,CH            ;Move o valor que esta em CH para CL
    MOV BL,"+"           ;Move o sinal de '+' para ser printado depois
    pulalinha
    JMP RESUL            ;Pula para o procedimento de resultado
CAR0:
    OR CH,00H            ;No caso de CAR0 a soma vai ser com 0 por conta de ser zerado
    CMP BL,3             ;Compara o valor que esta em BL com 3
    JNZ TOPO             ;Se nao for igual ele pula para o TOPO para reiniciar
    MOV CL,CH            ;Move o valor que esta em CH para CL
    MOV BL,"+"           ;Move o sinal de '+' para ser printado depois
    pulalinha
    JMP RESUL            ;Pula para o procedimento de resultado
RET                 
MULTIPLICA   ENDP

DIVIDE PROC
    XCHG BH,BL          ;BH DIVIDENDO,BL DIVISOR
    MOV CX,9
    XOR AX,AX
    MOV AL,BL           ;BL -> AL
    CMP BH,0
    JZ ERRO             ;Jump para a mensagem de erro caso seja uma divisão por 0   
    XOR BL,BL           ;zera BL
    XOR DX,DX           ;Zera DX 
    LUP:
    SUB AX,BX           ;subtrai o divisor do dividendo, caso o sinal seja positivo o quociente recebe bit 1
    JNS SINAL           ;caso contrario bit 0 no quociente
    ADD AX,BX
    MOV DH,0            
    JMP TERMINA
SINAL:
    MOV DH,01
TERMINA:
    SHL DL,1            ;deslocamento para a esquerda do quociente
    OR DL,DH            ;coloca o bit 1 ou 0 em dl 
    SHR BX,1            
    LOOP LUP
    MOV CH,DL           ;move o quociente e o resto para cx, para nao perder o valor nos prints
    MOV CL,AL
    pulalinha
    mov ah,09
    lea dx,MSG4         ;print da mensagem de resultado
    int 21H

    mov ah,09
    lea dx,MSGQUOCIENTE
    int 21h             ;print da mensagem de quociente
    or ch,30h           ;transforma o resultado em caracter
    mov ah,02
    mov dl,ch
    int 21h             ;printa o valor do quocinte que estava em CH

    pulalinha
    mov ah,09
    LEA DX,MSGRESTO     ;print da mensagem de resto
    INT 21h
    OR Cl,30H           ;transforma em caracter
    MOV AH,02
    MOV DL,Cl
    INT 21H             ;Printa o valor do resto que esta em CL
    JMP FIM

ERRO:
    mov ah,02
    mov dl,10
    int 21h
    MOV AH,09
    LEA DX,MSGERRO      ;mensagem de erro caso tenha divisao por 0
    INT 21H
    jmp fim
RET
DIVIDE ENDP

END MAIN