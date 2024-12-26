.data
.include "imagens/telainicial.data"   # Inclui o arquivo de imagem background.data

.text

# Fun��o para renderizar o fundo
.globl BACKGROUND_RENDER
BACKGROUND_RENDER:
    # Inicializa os registradores necess�rios
    li t1, 0xFF000000          # Endere�o inicial da mem�ria VGA - Frame 0
    li t2, 0xFF012C00          # Endere�o final da mem�ria VGA
    la s1, telainicial         # Endere�o dos dados da tela na mem�ria
    addi s1, s1, 8             # Ajusta o ponteiro para pular os dados de nlin e ncol

BACKGROUND_LOOP:  
    beq t1, t2, BACKGROUND_FIM # Se `t1` atingir o endere�o final, sai do loop
    lw t3, 0(s1)               # L� uma word (4 bytes) da imagem
    sw t3, 0(t1)               # Escreve a word na mem�ria VGA
    addi t1, t1, 4             # Incrementa o endere�o de mem�ria VGA
    addi s1, s1, 4             # Incrementa o ponteiro para os dados da imagem
    j BACKGROUND_LOOP          # Volta para o in�cio do loop

BACKGROUND_FIM:
    jr ra                      # Retorna para a fun��o chamadora
