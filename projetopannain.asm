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

    JNE N_SOMA
    CALL SOMA

    pulalinha

N_SOMA:
    CMP CH,"-"
    ; JNE N_SUB
    CALL SUBTRACAO

; N_SUB:
;     CMP CH,"/"
;     JNE DIVISAO
;     CALL MULTIPLICACAO

SOMA:
    ADD BH,BL
    OR BH,30H
   
    pulalinha

    MOV AH,09h
    LEA DX,MSG4
    INT 21h
    
    MOV AH,02
    MOV DL,BH
    INT 21H
    JMP FIM

SUBTRACAO:


    SUB BH,BL
    OR BH,30H
    
    pulalinha

    MOV AH,09h
    LEA DX,MSG4
    INT 21h
    
    MOV AH,02
    MOV DL,BH
    INT 21H

; MULTIPLICACAO:
;     MUL BL
;     OR BH,30H
   
;     pulalinha

;     MOV AH,09h
;     LEA DX,MSG4
;     INT 21h
    
;     MOV AH,02
;     MOV DL,BH
;     INT 21H

; DIVISAO:
;     DIV BL
;     OR BH,30H
   
;     pulalinha

;     MOV AH,09h
;     LEA DX,MSG4
;     INT 21h
    
;     MOV AH,02
;     MOV DL,BH
;     INT 21H
FIM:
    MOV AH,4ch
    MAIN ENDP 
    END MAIN