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
    MOV AX,@DATA
    MOV DS,AX
    MOV AH,09
    LEA DX,msg
    INT 21H
    CALL entrada
    CALL SAIDA
SAIR:
    MOV AH,4CH
    INT 21H
main endp
entrada proc

INICIO:
    PUSH BX
    PUSH CX
    PUSH DX
    XOR BX,BX
    XOR CX,CX

    MOV AH,01
    INT 21H

    CMP AL,'-'
    JE NEGATIVO
    CMP AL,'+'
    JE POSITIVO 
    JMP VOLTA

    NEGATIVO:
    MOV CX,1

    POSITIVO:
    INT 21H

    VOLTA:
    CMP AL,'0'
    JNGE INVALIDO
    CMP AL,'9'
    JNLE INVALIDO

    AND AX,0FH
    PUSH AX

    MOV AX,10
    MUL BX
    POP BX
    ADD BX,AX

    MOV AH,01
    INT 21H
    CMP AL,13


    JNE VOLTA

    MOV AX,BX
    OR CX,CX
    JE SAI

    NEG AX
    SAI:
    POP DX   
    POP CX
    POP BX
    RET

    INVALIDO:
    PULALINHA
    JMP INICIO
entrada endp
SAIDA proc
PUSH AX
MOV AH,09
LEA DX,msg2
INT 21H
POP AX

OR AX,AX
JGE FIM
PUSH AX
MOV AH,02
MOV DL,'-'
INT 21H
POP AX
NEG AX
FIM:
XOR CX,CX
MOV BX,10

LUP:
XOR DX,DX
DIV BX
PUSH DX
INC CX

OR AX,AX
JNE LUP

IMPRIME:
 POP DX
 OR DL,30H
 MOV AH,02
 INT 21H
 LOOP IMPRIME

RET
SAIDA ENDP

END MAIN



