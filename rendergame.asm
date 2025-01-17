.data

notas: .word 9, 0, 0,
67, 1000, 0,
74, 1000, 0,
70, 1500, 0,
69, 500, 0,
67, 500, 0,
70, 500, 0,
69, 500, 0,
67, 500, 0,
66, 500, 0,

CHAR_POS: .half 145, 205       # Posi��o inicial do personagem (X, Y)
OLD_CHAR_POS: .half 0, 0      # �ltima posi��o do personagem (X, Y)

POINTS_X: .half 80, 110, 180, 210 # Posi��es X das quatro posi��es em cada linha
POINTS_Y: .half 85, 145, 205       # Posi��es Y das tr�s linhas

.text
SETUP:
    la a0,telainicial     # Carrega o endere�o da imagem da tela inicial em a0
    li a1,0               # Coordenada X inicial
    li a2,0               # Coordenada Y inicial
    li a3,0               # Framebuffer 0
    call PRINT            # Chama a fun��o PRINT para desenhar a tela inicial
    
    ### Espera o usu�rio pressionar uma tecla
KEY1:  
    li t1,0xFF200000      # Carrega o endere�o de controle do KDMMIO
LOOP:  
    lw t0,0(t1)           # L� bit de Controle do Teclado
    andi t0,t0,0x0001     # Mascarar o bit menos significativo
    beq t0,zero,LOOP      # Se n�o tem tecla pressionada, volta ao loop
    lw t2,4(t1)           # L� o valor da tecla pressionada
    sw t2,12(t1)          # Escreve a tecla pressionada no display

    # Desenha o fundo uma vez no in�cio
    la a0,fundo           # Carrega o endere�o da imagem do fundo em a0
    li a1,0               # Coordenada X inicial
    li a2,0               # Coordenada Y inicial
    li a3,0               # Framebuffer 0
    call PRINT            # Chama a fun��o PRINT para desenhar o fundo
    li a3,1               # Framebuffer 1
    call PRINT            # Chama a fun��o PRINT para desenhar o fundo novamente

GAME_LOOP:
    
    la s1, notas
    lw s2, 0(s1) #quantas notas existem
    lw s3, 4(s1) #em que nota eu estou
    lw s4, 8(s1) #quand a ultima nota foi tocada do 6

    li t0, 12
    mul s5, t0, s3
    add s5, s5, s1  #endereço da nota atual do 6

    li a7, 30
    ecall

    sub s6, a0, s4 # quanto tempo já se passou desde que a última nota foi tocada

    lw t1, 4(s5)
    bgtu t1, s6, MF0 
            #se já for pra tocar a próxima nota do, 6
	
    	bne s3, s2, MF1
    		li s3, 0
    		mv s5, s1
    	MF1:
            addi s5, s5, 12

            li a7, 31
            lw a0, 0(s5)
            lw a1, 4(s5)
            li a2, 0
            li a3, 60
            ecall

            li a7, 30
            ecall

            sw a0, 8(s1)

            addi s3, s3, 1
            sw s3, 4(s1)
        
    MF0:


    call KEY2             # Chama a fun��o KEY2 para verificar a tecla pressionada
    xori s0,s0,1          # Alterna o frame buffer (0 ou 1)
    
    la t0,CHAR_POS        # Carrega o endere�o da posi��o atual do personagem

    # Alternar frame apenas para o personagem
    la a0,felix           # Carrega o endere�o da imagem do personagem "felix" em a0
    lh a1,0(t0)           # Carrega a posi��o X atual
    lh a2,2(t0)           # Carrega a posi��o Y atual
    mv a3,s0              # Alterna o frame para o personagem
    call PRINT            # Chama a fun��o PRINT para desenhar o personagem

    # Atualizar LED (opcional), pro personagem n�o piscar na tela
    li t0,0xFF200604      # Carrega o endere�o do LED
    sw s0,0(t0)           # Atualiza o LED com o valor de s0
    
    la t0,OLD_CHAR_POS    # Carrega o endere�o da �ltima posi��o do personagem

    la a0,fundo            # Carrega o endere�o da imagem do tile em a0
    li a1,0	           # Carrega a �ltima posi��o X
    li a2,0		   # Carrega a �ltima posi��o Y
    
    mv a3,s0              # Alterna o frame para o tile
    xori a3,a3,1          # Alterna o frame buffer
    call PRINT            # Chama a fun��o PRINT para desenhar o tile
    
    j GAME_LOOP           # Volta para o in�cio do loop do jogo

KEY2:   
    li t1,0xFF200000      # Carrega o endere�o de controle do KDMMIO
    lw t0,0(t1)           # L� bit de controle do teclado
    andi t0,t0,0x0001     # M�scara para o bit menos significativo
    beq t0,zero,FIM       # Se n�o h� tecla pressionada, pula para FIM
    lw t2,4(t1)           # L� o valor da tecla pressionada

    li t0,'a'             # Carrega o valor ASCII da tecla 'a'
    beq t2,t0,MOVE_LEFT   # Se 'a' � pressionado, pula para MOVE_LEFT

    li t0,'d'             # Carrega o valor ASCII da tecla 'd'
    beq t2,t0,MOVE_RIGHT  # Se 'd' � pressionado, pula para MOVE_RIGHT

    li t0,'w'             # Carrega o valor ASCII da tecla 'w'
    beq t2,t0,MOVE_UP     # Se 'w' � pressionado, pula para MOVE_UP

    li t0,'s'             # Carrega o valor ASCII da tecla 's'
    beq t2,t0,MOVE_DOWN   # Se 's' � pressionado, pula para MOVE_DOWN

FIM:    
    ret                   # Retorna da fun��o

MOVE_LEFT: 
    la t0,CHAR_POS        # Carrega o endere�o da posi��o atual do personagem
    la t1,OLD_CHAR_POS    # Carrega o endere�o da �ltima posi��o do personagem
    lw t2,0(t0)           # Carrega a posi��o atual
    sw t2,0(t1)           # Salva a posi��o atual como a �ltima posi��o
    
    lh t1,0(t0)           # Carrega a posi��o X atual
    la t2,POINTS_X        # Carrega o endere�o dos pontos X
    lh t3,0(t2)           # Carrega o ponto X 1
    lh t4,2(t2)           # Carrega o ponto X 2
    lh t5,4(t2)           # Carrega o ponto X 3
    lh t6,6(t2)           # Carrega o ponto X 4

    beq t1,t4,SET_X1      # Se a posi��o atual � o ponto 2, move para o ponto 1
    beq t1,t5,SET_X2      # Se a posi��o atual � o ponto 3, move para o ponto 2
    beq t1,t6,SET_X3      # Se a posi��o atual � o ponto 4, move para o ponto 3

SET_X1:
    sh t3,0(t0)           # Atualiza a posi��o X para o ponto 1
    ret                   # Retorna da fun��o

SET_X2:
    sh t4,0(t0)           # Atualiza a posi��o X para o ponto 2
    ret                   # Retorna da fun��o

SET_X3:
    sh t5,0(t0)           # Atualiza a posi��o X para o ponto 3
    ret                   # Retorna da fun��o

MOVE_RIGHT: 
    la t0,CHAR_POS        # Carrega o endere�o da posi��o atual do personagem
    la t1,OLD_CHAR_POS    # Carrega o endere�o da �ltima posi��o do personagem
    lw t2,0(t0)           # Carrega a posi��o atual
    sw t2,0(t1)           # Salva a posi��o atual como a �ltima posi��o

    lh t1,0(t0)           # Carrega a posi��o X atual
    la t2,POINTS_X        # Carrega o endere�o dos pontos X
    lh t3,0(t2)           # Carrega o ponto X 1
    lh t4,2(t2)           # Carrega o ponto X 2
    lh t5,4(t2)           # Carrega o ponto X 3
    lh t6,6(t2)           # Carrega o ponto X 4

    beq t1,t3,SET_X2_RIGHT # Se a posi��o atual � o ponto 1, move para o ponto 2
    beq t1,t4,SET_X3_RIGHT # Se a posi��o atual � o ponto 2, move para o ponto 3
    beq t1,t5,SET_X4      # Se a posi��o atual � o ponto 3, move para o ponto 4
    ret

SET_X2_RIGHT:
    sh t4,0(t0)           # Atualiza a posi��o X para o ponto 2
    ret                   # Retorna da fun��o

SET_X3_RIGHT:
    sh t5,0(t0)           # Atualiza a posi��o X para o ponto 3
    ret                   # Retorna da fun��o

SET_X4:
    sh t6,0(t0)           # Atualiza a posi��o X para o ponto 4
    ret                   # Retorna da fun��o

MOVE_UP: 
    la t0,CHAR_POS        # Carrega o endere�o da posi��o atual do personagem
    la t1,OLD_CHAR_POS    # Carrega o endere�o da �ltima posi��o do personagem
    lw t2,0(t0)           # Carrega a posi��o atual
    sw t2,0(t1)           # Salva a posi��o atual como a �ltima posi��o

    lh t1,2(t0)           # Carrega a posi��o Y atual
    la t2,POINTS_Y        # Carrega o endere�o dos pontos Y
    lh t3,0(t2)           # Carrega o ponto Y 1
    lh t4,2(t2)           # Carrega o ponto Y 2
    lh t5,4(t2)           # Carrega o ponto Y 3

    beq t1,t4,SET_Y1      # Se a posi��o atual � o ponto 2, move para o ponto 1
    beq t1,t5,SET_Y2      # Se a posi��o atual � o ponto 3, move para o ponto 2

SET_Y1:
    sh t3,2(t0)           # Atualiza a posi��o Y para o ponto 1
    ret                   # Retorna da fun��o

MOVE_DOWN: 
    la t0,CHAR_POS        # Carrega o endere�o da posi��o atual do personagem
    la t1,OLD_CHAR_POS    # Carrega o endere�o da �ltima posi��o do personagem
    lw t2,0(t0)           # Carrega a posi��o atual
    sw t2,0(t1)           # Salva a posi��o atual como a �ltima posi��o

    lh t1,2(t0)           # Carrega a posi��o Y atual
    la t2,POINTS_Y        # Carrega o endere�o dos pontos Y
    lh t3,0(t2)           # Carrega o ponto Y 1
    lh t4,2(t2)           # Carrega o ponto Y 2
    lh t5,4(t2)           # Carrega o ponto Y 3

    beq t1,t3,SET_Y2      # Se a posi��o atual � o ponto 1, move para o ponto 2
    beq t1,t4,SET_Y3      # Se a posi��o atual � o ponto 2, move para o ponto 3
    ret

SET_Y2:
    sh t4,2(t0)           
    ret                   

SET_Y3:
    sh t5,2(t0)           # Atualiza a posi��o Y para o ponto 3
    ret                   # Retorna da fun��o

PRINT:
    li t0,0xFF0           # Base do framebuffer
    add t0,t0,a3          # Escolhe o framebuffer com base em a3
    slli t0,t0,20         # Desloca para o endere�o do framebuffer

    add t0,t0,a1          # Offset X

    li t1,320             # Largura da tela
    mul t1,t1,a2          # Offset Y
    add t0,t0,t1          # Calcula a posi��o final no framebuffer

    addi t1,a0,8          # Endere�o inicial dos dados da imagem

    mv t2,zero            # Contador de linha
    mv t3,zero            # Contador de coluna

    lw t4,0(a0)           # Largura da imagem
    lw t5,4(a0)           # Altura da imagem

PRINT_LINHA:
    lw t6,0(t1)           # L� pixel da imagem
    sw t6,0(t0)           # Escreve no framebuffer

    addi t0,t0,4          # Pr�ximo pixel no framebuffer
    addi t1,t1,4          # Pr�ximo pixel da imagem

    addi t3,t3,4          # Atualiza contador de coluna
    blt t3,t4,PRINT_LINHA # Continua at� o final da linha

    addi t0,t0,320        # Pr�xima linha no framebuffer
    sub t0,t0,t4          # Ajusta para o in�cio da linha

    mv t3,zero            # Reseta contador de coluna
    addi t2,t2,1          # Incrementa contador de linha
    blt t2,t5,PRINT_LINHA # Continua at� o final da imagem
    ret                   # Retorna da fun��o

.data
.include "imagens/felix.data"        # Inclui dados da imagem do personagem
.include "imagens/fundo.data"        # Inclui dados da imagem do fundo
.include "imagens/tile.data"         # Inclui dados da imagem do tile
.include "imagens/telainicial.data"  # Inclui dados da imagem da tela inicial
.include "MACROSv24.s"
.include "SYSTEMv24.s"

