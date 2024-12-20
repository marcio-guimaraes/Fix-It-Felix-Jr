.data
.include "imagens/background.data"   # Inclui o arquivo de imagem background.data

.text

# Fun��o para renderizar o fundo
.globl RENDERBACKGROUND
RENDERBACKGROUND:
    # Preenche a tela de vermelho
    li t1,0xFF000000          # endere�o inicial da Memoria VGA - Frame 0
    li t2,0xFF012C00          # endere�o final 
    li t3,0x07070707          # cor vermelha (RGB)
BACKGROUND_LOOP:  
    beq t1,t2,BACKGROUND_FORA            # Se for o �ltimo endere�o ent�o sai do loop
    sw t3,0(t1)               # escreve a word na mem�ria VGA
    addi t1,t1,4              # soma 4 ao endere�o
    j BACKGROUND_LOOP                    # volta a verificar

# Carrega a imagem1 (background)
BACKGROUND_FORA:    
    li t1,0xFF000000          # endere�o inicial da Mem�ria VGA - Frame 0
    li t2,0xFF012C00          # endere�o final 
    la s1,background          # endere�o dos dados da tela na mem�ria
    addi s1,s1,8              # ajusta o ponteiro para pular os dados de nlin e ncol
BACKGROUND_LOOP1:  
    beq t1,t2,BACKGROUND_FIM             # Se for o �ltimo endere�o ent�o sai do loop
    lw t3,0(s1)               # l� um conjunto de 4 pixels (word)
    sw t3,0(t1)               # escreve a word na mem�ria VGA
    addi t1,t1,4              # soma 4 ao endere�o
    addi s1,s1,4              # avan�a para o pr�ximo pixel
    j BACKGROUND_LOOP1                   # volta a verificar

# Finaliza a fun��o
BACKGROUND_FIM:  
    jr ra                     # Retorna para a fun��o chamadora

