.data
# Dados da imagem e das m�sicas
.include "imagens/telainicial.data"  # Inclui o arquivo da imagem
# Dados para a m�sica
NUM: .word 60
NOTAS: 55,234,57,234,60,351,55,234,55,234,57,117,60,234,57,234,64,117,64,234,64,351,62,469,64,234,62,234,64,234,55,234,57,234,60,351,55,234,55,234,57,117,60,234,57,234,64,117,64,234,65,351,62,938,62,117,64,117,64,938,57,234,64,234,64,234,62,234,64,351,60,117,67,117,64,117,60,117,64,117,60,117,64,117,60,117,67,117,60,117,64,117,60,117,62,117,64,117,64,234,62,351,57,351,64,234,64,117,62,234,64,234,65,351,65,351,67,234,69,938

.text

# Fun��o principal
.globl TELAINICIAL
TELAINICIAL:
    jal RENDERBACKGROUND    # Renderiza a imagem na tela
    jal PLAYMUSIC           # Toca a m�sica at� o usu�rio pressionar uma tecla
    li a7, 10               # Finaliza o programa
    ecall

# Fun��o para renderizar o fundo
.globl RENDERBACKGROUND
RENDERBACKGROUND:
    # Preenche a tela de vermelho
    li t1, 0xFF000000          # Endere�o inicial da Mem�ria VGA - Frame 0
    li t2, 0xFF012C00          # Endere�o final 
    li t3, 0x07070707          # Cor vermelha (RGB)
BACKGROUND_LOOP:  
    beq t1, t2, BACKGROUND_FORA        # Se for o �ltimo endere�o, sai do loop
    sw t3, 0(t1)               # Escreve a word na mem�ria VGA
    addi t1, t1, 4             # Soma 4 ao endere�o
    j BACKGROUND_LOOP          # Volta a verificar

# Carrega a imagem (background)
BACKGROUND_FORA:    
    li t1, 0xFF000000          # Endere�o inicial da Mem�ria VGA - Frame 0
    li t2, 0xFF012C00          # Endere�o final 
    la s1, telainicial         # Endere�o dos dados da tela na mem�ria
    addi s1, s1, 8             # Ajusta o ponteiro para pular os dados de nlin e ncol
BACKGROUND_LOOP1:  
    beq t1, t2, BACKGROUND_FIM          # Se for o �ltimo endere�o, sai do loop
    lw t3, 0(s1)               # L� um conjunto de 4 pixels (word)
    sw t3, 0(t1)               # Escreve a word na mem�ria VGA
    addi t1, t1, 4             # Soma 4 ao endere�o
    addi s1, s1, 4             # Avan�a para o pr�ximo pixel
    j BACKGROUND_LOOP1         # Volta a verificar

# Finaliza a fun��o de renderiza��o
BACKGROUND_FIM:
    jr ra                      # Retorna para a fun��o chamadora

# Fun��o para tocar m�sica
.globl PLAYMUSIC
PLAYMUSIC:
    la s0, NUM                 # Define o endere�o do n�mero de notas
    lw s1, 0(s0)               # L� o n�mero de notas
    la s0, NOTAS               # Define o endere�o das notas
    li a2, 81                  # Define o instrumento
    li a3, 127                 # Define o volume

PLAYMUSIC_LOOP:
    li t0, 0                   # Reinicia o contador de notas

MUSIC_LOOP:
    beq t0, s1, CHECK_KEY      # Se todas as notas foram tocadas, verifica se o usu�rio pressionou uma tecla
    lw a0, 0(s0)               # L� o valor da nota
    lw a1, 4(s0)               # L� a dura��o da nota
    li a7, 31                  # Define a chamada de syscall
    ecall                      # Toca a nota
    mv a0, a1                  # Passa a dura��o da nota para a pausa
    li a7, 32                  # Define a chamada de syscall para pausa
    ecall                      # Realiza uma pausa de a0 ms
    addi s0, s0, 8             # Incrementa para o endere�o da pr�xima nota
    addi t0, t0, 1             # Incrementa o contador de notas
    j MUSIC_LOOP               # Volta ao loop de m�sica

CHECK_KEY:
    jal KEY2                   # Verifica se h� tecla pressionada (n�o bloqueia)
    bnez t2, PLAYMUSIC_FIM     # Se o valor lido de t2 n�o for zero, sai do loop
    la s0, NOTAS               # Reseta o endere�o das notas
    j PLAYMUSIC_LOOP           # Reinicia a m�sica

PLAYMUSIC_FIM:
    jr ra                      # Retorna para a fun��o chamadora

# Fun��o para verificar tecla pressionada (n�o bloqueante)
.globl KEY2
KEY2:
    li t1, 0xFF200000          # Endere�o de controle do KDMMIO
    lw t0, 0(t1)               # L� o bit de controle do teclado
    andi t0, t0, 0x0001        # Mascara o bit menos significativo
    beq t0, zero, NO_KEY       # Se n�o h� tecla pressionada, vai para NO_KEY
    lw t2, 4(t1)               # L� o valor da tecla pressionada
    sw t2, 12(t1)              # Mostra a tecla pressionada no display
    ret                        # Retorna

NO_KEY:
    li t2, 0                   # Define t2 como 0 (nenhuma tecla pressionada)
    ret                        # Retorna