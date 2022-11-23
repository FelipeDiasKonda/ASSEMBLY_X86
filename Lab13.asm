.model small
.stack 100h
.data
    msg DB 'Digite os numeros->$'
    msg2 DB 'Numero lido->$'
    MSGINVALIDO DB 'APENAS NUMEROS DE 0 A 9$'
.code
PULALINHA MACRO 
    MOV AH,02
    MOV DL,10
    INT 21H
ENDM

main proc
    MOV AX,@DATA        ;inicializa o segmento de dados
    MOV DS,AX
    MOV AH,09
    LEA DX,msg  
    INT 21H             ;printa a msg
    CALL entrada        ;chama a fução de entrada do numero
    CALL SAIDA          ;chama a função de saida do numero lido
SAIR:   
    MOV AH,4CH          ;fim do programa
    INT 21H
main endp
entrada proc

INICIO:
    PUSH BX             ;salva o conteudo dos registradores na pilha
    PUSH CX
    PUSH DX
    XOR BX,BX           ;zera bx
    XOR CX,CX           ;zera cx

    MOV AH,01           ;lê o sinal caso exista
    INT 21H

    CMP AL,'-'          ;comparações para verificar se é positivo ou negativo
    JE NEGATIVO
    CMP AL,'+'
    JE POSITIVO         ;jump caso seja positivo
    JMP VOLTA

    NEGATIVO:
    MOV CX,1            ;se for negativo, cx recebe 1

    POSITIVO:
    INT 21H

    VOLTA:
    CMP AL,'0'          ;verifica se é realmente um numero, caso o usuario tenha digitado uma letra ele nao aceita, por exemplo
    JNGE INVALIDO
    CMP AL,'9'
    JNLE INVALIDO

    AND AX,0FH          ;transforma em numero
    PUSH AX             ;push ax na pilha

    MOV AX,10           ;ax recebe 10
    MUL BX              ;multiplica BX
    POP BX              ;Desempilha em bx 
    ADD BX,AX           ;soma bx com ax

    MOV AH,01
    INT 21H             ;lê o numero 
    CMP AL,13           ;compara com o enter, caso seja igual ele para de ler 

    JNE VOLTA

    MOV AX,BX           ;AX<-BX
    OR CX,CX            ;sinal
    JE SAI              

    NEG AX
    SAI:
    POP DX              ;volta o valor dos registradores original antes do procedimento
    POP CX
    POP BX
    RET

    INVALIDO:           ;leu algo que nao era um numero portanto pula para o inicio novamente
    PULALINHA
    JMP INICIO
entrada endp
SAIDA proc              ;procedimento de saida
PUSH AX                 ;salva o que esta em AX na pilha, pois como eu vou printar a string e nao quero perder o que esta em AX eu empilho e desempilho depois de printar
MOV AH,09   
LEA DX,msg2             ;printa MSG2
INT 21H
POP AX                  ;desempilha em AX

OR AX,AX                ;sinal
JGE FIM
PUSH AX                 ;se for negativo printa o sinal de menos
MOV AH,02
MOV DL,'-'
INT 21H
POP AX
NEG AX
FIM:
XOR CX,CX               ;zera cx
MOV BX,10

LUP:            
XOR DX,DX               ;zera DX
DIV BX
PUSH DX                 ;empilha o que esta em DX
INC CX                  ;incrementa CX

OR AX,AX
JNE LUP

IMPRIME:
 POP DX                 ;desempilha em DX
 OR DL,30H              ;transforma em caracterpara printar
 MOV AH,02
 INT 21H
 LOOP IMPRIME

RET                     ;fim do procedimento
SAIDA ENDP

END MAIN
