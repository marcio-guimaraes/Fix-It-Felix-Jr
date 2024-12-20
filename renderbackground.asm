.data
.include "imagens/background.data"   # Inclui o arquivo de imagem background.data

.text

# Função para renderizar o fundo
.globl RENDERBACKGROUND
RENDERBACKGROUND:
    # Preenche a tela de vermelho
    li t1,0xFF000000          # endereço inicial da Memoria VGA - Frame 0
    li t2,0xFF012C00          # endereço final 
    li t3,0x07070707          # cor vermelha (RGB)
BACKGROUND_LOOP:  
    beq t1,t2,BACKGROUND_FORA            # Se for o último endereço então sai do loop
    sw t3,0(t1)               # escreve a word na memória VGA
    addi t1,t1,4              # soma 4 ao endereço
    j BACKGROUND_LOOP                    # volta a verificar

# Carrega a imagem1 (background)
BACKGROUND_FORA:    
    li t1,0xFF000000          # endereço inicial da Memória VGA - Frame 0
    li t2,0xFF012C00          # endereço final 
    la s1,background          # endereço dos dados da tela na memória
    addi s1,s1,8              # ajusta o ponteiro para pular os dados de nlin e ncol
BACKGROUND_LOOP1:  
    beq t1,t2,BACKGROUND_FIM             # Se for o último endereço então sai do loop
    lw t3,0(s1)               # lê um conjunto de 4 pixels (word)
    sw t3,0(t1)               # escreve a word na memória VGA
    addi t1,t1,4              # soma 4 ao endereço
    addi s1,s1,4              # avança para o próximo pixel
    j BACKGROUND_LOOP1                   # volta a verificar

# Finaliza a função
BACKGROUND_FIM:  
    jr ra                     # Retorna para a função chamadora

