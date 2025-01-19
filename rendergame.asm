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

CHAR_POS: .half 145, 205       # posição inicial do personagem (X, Y)
OLD_CHAR_POS: .half 0, 0       # última posição do personagem (X, Y)

POINTS_X: .half 80, 110, 180, 210  # Posições X das quatro posições em cada linha
POINTS_Y: .half 75, 132, 189       # Posições Y das três linhas


###############################################################
###############################################################
####################### FIM DOS DADOS #########################
###############################################################
###############################################################


###############################################################
######### PRINTA TELA INICIAL E ESPERA TECLAR ALGO ############
###############################################################

.text
SETUP:
   
    la a0,telainicial     # Carrega o endereço da imagem da tela inicial em a0
    li a1,0               # Coordenada X inicial
    li a2,0               # Coordenada Y inicial
    li a3,0               # Framebuffer 0
    call PRINT            # Chama a função PRINT para desenhar a tela inicial
    
    ### Espera o usuário pressionar uma tecla
KEY1:  
    li t1,0xFF200000      # Carrega o endereço de controle do KDMMIO
LOOP:  
    lw t0,0(t1)           # Lê bit de Controle do Teclado
    andi t0,t0,0x0001     # Mascarar o bit menos significativo
    beq t0,zero,LOOP      # Se não tem tecla pressionada, volta ao loop
    lw t2,4(t1)           # Lê o valor da tecla pressionada
    sw t2,12(t1)          # Escreve a tecla pressionada no display

    # Desenha o fundo uma vez no início
    la a0,fundo           # Carrega o endereço da imagem do fundo em a0
    li a1,0               # Coordenada X inicial
    li a2,0               # Coordenada Y inicial
    li a3,0               # Framebuffer 0
    call PRINT            # Chama a função PRINT para desenhar o fundo
    li a3,1               # Framebuffer 1
    call PRINT            # Chama a função PRINT para desenhar o fundo novamente


    

###############################################################
###############################################################
################### INICIO DO LOOP PRINCIPAL ##################
###############################################################
###############################################################

GAME_LOOP:

##############################################
########### INÍCIO DO LOOP MÚSICA ############
##############################################
    
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


##############################################
########### INÍCIO DO LOOP MÚSICA ############
##############################################


#########################################################
########### RENDERIZAÇÃO DO FUNDO E DO FELIX ############
#########################################################

    call KEY2             # Chama a função KEY2 para verificar a tecla pressionada
    xori s0,s0,1          # Alterna o frame buffer (0 ou 1)
    
    la t0,CHAR_POS        # Carrega o endereço da posição atual do personagem

    # Alternar frame apenas para o personagem
    la a0,felix           # Carrega o endereço da imagem do personagem "felix" em a0
    lh a1,0(t0)           # Carrega a posição X atual
    lh a2,2(t0)           # Carrega a posição Y atual
    mv a3,s0              # Alterna o frame para o personagem
    call PRINT            # Chama a função PRINT para desenhar o personagem

    # Atualizar LED (opcional), pro personagem não piscar na tela
    li t0,0xFF200604       # Carrega o endereço do LED
    sw s0,0(t0)            # Atualiza o LED com o valor de s0
    
    la t0,OLD_CHAR_POS     # Carrega o endereço da última posição do personagem

    la a0,fundo            # Carrega o endereço da imagem do tile em a0
    li a1,0	               # Carrega a última posição X
    li a2,0		           # Carrega a última posição Y
    
    mv a3,s0               # Alterna o frame para o tile
    xori a3,a3,1           # Alterna o frame buffer
    call PRINT             # Chama a função PRINT para desenhar o tile

    #########################################################
    ########### RENDERIZAÇÃO DO RALPH #######################
    #########################################################

    # Ralph 
    la a0, ralph3              # Endereço da imagem
    li a1, 80                  # Coordenada X (ajustar para centralizar)
    li a2, 5                   # Coordenada Y (no topo da tela)
    li a3, 0                   # Framebuffer 0
    call PRINT
    li a3, 1                   # Framebuffer 1
    call PRINT

    j GAME_LOOP            # Volta para o início do loop do jogo


###############################################################
###############################################################
################### FIM DO LOOP PRINCIPAL #####################
###############################################################
###############################################################



######################################################################
########## ESPERA ENTRADA PARA A MOVIMENTAÇÃO DO PERSONAGEM ##########
######################################################################

KEY2:   
    li t1,0xFF200000      # Carrega o endereço de controle do KDMMIO
    lw t0,0(t1)           # Lê bit de controle do teclado
    andi t0,t0,0x0001     # Máscara para o bit menos significativo
    beq t0,zero,FIM       # Se não há tecla pressionada, pula para FIM
    lw t2,4(t1)           # Lê o valor da tecla pressionada

    li t0,'a'             # Carrega o valor ASCII da tecla 'a'
    beq t2,t0,MOVE_LEFT   # Se 'a' é pressionado, pula para MOVE_LEFT

    li t0,'d'             # Carrega o valor ASCII da tecla 'd'
    beq t2,t0,MOVE_RIGHT  # Se 'd' é pressionado, pula para MOVE_RIGHT

    li t0,'w'             # Carrega o valor ASCII da tecla 'w'
    beq t2,t0,MOVE_UP     # Se 'w' é pressionado, pula para MOVE_UP

    li t0,'s'             # Carrega o valor ASCII da tecla 's'
    beq t2,t0,MOVE_DOWN   # Se 's' é pressionado, pula para MOVE_DOWN

FIM:    
    ret                   # Retorna da função


##########################################################
########## LÓGICA DE MOVIMENTAÇÃO DO PERSONAGEM ########## 
##########################################################

MOVE_LEFT: 
    la t0,CHAR_POS        # Carrega o endereço da posição atual do personagem
    la t1,OLD_CHAR_POS    # Carrega o endereço da última posição do personagem
    lw t2,0(t0)           # Carrega a posição atual
    sw t2,0(t1)           # Salva a posição atual como a última posição
    
    lh t1,0(t0)           # Carrega a posição X atual
    la t2,POINTS_X        # Carrega o endereço dos pontos X
    lh t3,0(t2)           # Carrega o ponto X 1
    lh t4,2(t2)           # Carrega o ponto X 2
    lh t5,4(t2)           # Carrega o ponto X 3
    lh t6,6(t2)           # Carrega o ponto X 4

    beq t1,t4,SET_X1      # Se a posição atual é o ponto 2, move para o ponto 1
    beq t1,t5,SET_X2      # Se a posição atual é o ponto 3, move para o ponto 2
    beq t1,t6,SET_X3      # Se a posição atual é o ponto 4, move para o ponto 3

SET_X1:
    sh t3,0(t0)           # Atualiza a posição X para o ponto 1
    ret                   # Retorna da função

SET_X2:
    sh t4,0(t0)           # Atualiza a posição X para o ponto 2
    ret                   # Retorna da função

SET_X3:
    sh t5,0(t0)           # Atualiza a posição X para o ponto 3
    ret                   # Retorna da função

MOVE_RIGHT: 
    la t0,CHAR_POS        # Carrega o endereço da posição atual do personagem
    la t1,OLD_CHAR_POS    # Carrega o endereço da última posição do personagem
    lw t2,0(t0)           # Carrega a posição atual
    sw t2,0(t1)           # Salva a posição atual como a última posição

    lh t1,0(t0)           # Carrega a posição X atual
    la t2,POINTS_X        # Carrega o endereço dos pontos X
    lh t3,0(t2)           # Carrega o ponto X 1
    lh t4,2(t2)           # Carrega o ponto X 2
    lh t5,4(t2)           # Carrega o ponto X 3
    lh t6,6(t2)           # Carrega o ponto X 4

    beq t1,t3,SET_X2_RIGHT # Se a posição atual é o ponto 1, move para o ponto 2
    beq t1,t4,SET_X3_RIGHT # Se a posição atual é o ponto 2, move para o ponto 3
    beq t1,t5,SET_X4      # Se a posição atual é o ponto 3, move para o ponto 4
    ret

SET_X2_RIGHT:
    sh t4,0(t0)           # Atualiza a posição X para o ponto 2
    ret                   # Retorna da função

SET_X3_RIGHT:
    sh t5,0(t0)           # Atualiza a posição X para o ponto 3
    ret                   # Retorna da função

SET_X4:
    sh t6,0(t0)           # Atualiza a posição X para o ponto 4
    ret                   # Retorna da função

MOVE_UP: 
    la t0,CHAR_POS        # Carrega o endereço da posição atual do personagem
    la t1,OLD_CHAR_POS    # Carrega o endereço da última posição do personagem
    lw t2,0(t0)           # Carrega a posição atual
    sw t2,0(t1)           # Salva a posição atual como a última posição

    lh t1,2(t0)           # Carrega a posição Y atual
    la t2,POINTS_Y        # Carrega o endereço dos pontos Y
    lh t3,0(t2)           # Carrega o ponto Y 1
    lh t4,2(t2)           # Carrega o ponto Y 2
    lh t5,4(t2)           # Carrega o ponto Y 3

    beq t1,t4,SET_Y1      # Se a posição atual é o ponto 2, move para o ponto 1
    beq t1,t5,SET_Y2      # Se a posição atual é o ponto 3, move para o ponto 2

SET_Y1:
    sh t3,2(t0)           # Atualiza a posição Y para o ponto 1
    ret                   # Retorna da função

MOVE_DOWN: 
    la t0,CHAR_POS        # Carrega o endereço da posição atual do personagem
    la t1,OLD_CHAR_POS    # Carrega o endereço da última posição do personagem
    lw t2,0(t0)           # Carrega a posição atual
    sw t2,0(t1)           # Salva a posição atual como a última posição

    lh t1,2(t0)           # Carrega a posição Y atual
    la t2,POINTS_Y        # Carrega o endereço dos pontos Y
    lh t3,0(t2)           # Carrega o ponto Y 1
    lh t4,2(t2)           # Carrega o ponto Y 2
    lh t5,4(t2)           # Carrega o ponto Y 3

    beq t1,t3,SET_Y2      # Se a posição atual para o ponto 1, move para o ponto 2
    beq t1,t4,SET_Y3      # Se a posição atual para o ponto 2, move para o ponto 3
    ret

SET_Y2:
    sh t4,2(t0)           
    ret                   

SET_Y3:
    sh t5,2(t0)           # Atualiza a posição Y para o ponto 3
    ret                   # Retorna da função


#########################################################
#################### FUNÇÃO DE PRINT ####################
#########################################################

PRINT:
    li t0,0xFF0           # Base do framebuffer
    add t0,t0,a3          # Escolhe o framebuffer com base em a3
    slli t0,t0,20         # Desloca para o endereço do framebuffer

    add t0,t0,a1          # Offset X

    li t1,320             # Largura da tela
    mul t1,t1,a2          # Offset Y
    add t0,t0,t1          # Calcula a posição final no framebuffer

    addi t1,a0,8          # Endereço inicial dos dados da imagem

    mv t2,zero            # Contador de linha
    mv t3,zero            # Contador de coluna

    lw t4,0(a0)           # Largura da imagem
    lw t5,4(a0)           # Altura da imagem

PRINT_LINHA:
    lw t6,0(t1)           # Lê pixel da imagem
    sw t6,0(t0)           # Escreve no framebuffer

    addi t0,t0,4          # Próximo pixel no framebuffer
    addi t1,t1,4          # Próximo pixel da imagem

    addi t3,t3,4          # Atualiza contador de coluna
    blt t3,t4,PRINT_LINHA # Continua até o final da linha

    addi t0,t0,320        # Próxima linha no framebuffer
    sub t0,t0,t4          # Ajusta para o início da linha

    mv t3,zero            # Reseta contador de coluna
    addi t2,t2,1          # Incrementa contador de linha
    blt t2,t5,PRINT_LINHA # Continua até o final da imagem
    ret                   # Retorna da função



################################
########## MAIS DADOS ##########
################################
# Quando esses dados são movidos pra cima o código buga
.data
.include "imagens/felix.data"            # Inclui dados da imagem do personagem
.include "imagens/fundo.data"            # Inclui dados da imagem do fundo
.include "imagens/tile.data"             # Inclui dados da imagem do tile
.include "imagens/telainicial.data"      # Inclui dados da imagem da tela inicial
.include "imagens/ralph3.data"           # Inclui dados da imagem do ralph
.include "imagens/ralphpDireita.data"    # Inclui o ralph 
.include "imagens/ralphpDireita2.data"   # Inclui o ralph 
.include "imagens/ralphpEsquerda.data"   # Inclui o ralph 
.include "imagens/ralphpEsquerda2.data"  # Inclui o ralph 
.include "MACROSv24.s"
.include "SYSTEMv24.s"

#comentarioqualquer

