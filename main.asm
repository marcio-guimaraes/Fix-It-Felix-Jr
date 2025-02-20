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
.include "imagens/FelixOutroLado.data"
.include "imagens/FelixOutroLadoRebaixado.data"
.include "imagens/FelixRebaixado.data"
.include "imagens/AndarSemMarteloPDireitaFelix.data"
.include "imagens/AndarSemMarteloPEsquerdaFelix.data"
.include "imagens/janelinhaPerfeita.data"
.include "imagens/janelaQuasePerfeita.data"
.include "imagens/janelaTotalmenteQuebrada.data"
.include "imagens/MartelandoPDireitaFelix.data"
.include "imagens/MartelandoPEsquerdaFelix.data"
.include "imagens/Martelando1PEsquerdaFelix.data"
.include "imagens/Martelando1PDireitaFelix.data"
.include "imagens/tijolo.data"            #inclui tijolinho
.include "imagens/ralphAtaque1.data"
.include "imagens/ralphAtaque2.data"
.include "imagens/healthIcon.data"
.include "imagens/fundo2.data"

FASE2: .byte 0
PONTOS: .byte 0
VIDAS: .byte 3


notas: .word 60, 0, 0,
55,234,0,
57,234,0,
60,351,0,
55,234,0,
55,234,0,
57,117,0,
60,234,0,
57,234,0,
64,117,0,
64,234,0,
64,351,0,
62,469,0,
64,234,0,
62,234,0,
64,234,0,
55,234,0,
57,234,0,
60,351,0,
55,234,0,
55,234,0,
57,117,0,
60,234,0,
57,234,0,
64,117,0,
64,234,0,
65,351,0,
62,938,0,  
62,117,0,  
64,117,0,  
64,938,0,  
57,234,0,  
64,234,0,  
64,234,0,  
62,234,0,  
64,351,0,  
60,117,0,  
67,117,0,  
64,117,0,  
60,117,0,  
64,117,0,  
60,117,0,  
64,117,0,  
60,117,0,  
67,117,0,  
60,117,0,  
64,117,0,  
60,117,0,  
62,117,0,  
64,117,0,  
64,234,0,  
62,351,0,  
57,351,0,  
64,234,0,  
64,117,0,  
62,234,0,  
64,234,0,  
65,351,0,  
65,351,0,  
67,234,0,  
69,938,0,  


CHAR_POS: .half 83, 191       # posição inicial do personagem (X, Y)
                    # A, x, y
ANIMACAO_FELIX: .half 0, 80, 189
            
RALPH_POS: .half 100
INTERVALO_MOVIMENTO_RALPH: .word 0
#                     Se esta em animacao,   x alvo da animacao, Lado que ta indo (0=direita. 1=esquerda), CONTADOR DE FRAMES
ANIMACAO_RALPH: .half 0,                     0,                  0,                                         0

windows: 
    #     x    y    janela, status
    .half 83 , 191, 1, 0   # janela 1
    .half 115, 191, 1, 0   # janela 2
    #.half 155, 202, 0, 2   # porta
    .half 182, 191, 1, 0  # janela 4
    .half 213, 191, 1, 0   # janela 5

    .half 83, 134 , 1, 0   # janela 6
    .half 115, 134, 1, 0   # janela 7
    #.half 155, 138, 0, 2   # sacada
    .half 182, 134, 1, 0   # janela 9
    .half 213, 134, 1, 0   # janela 10

    .half 83, 78, 1 , 0   # janela 11
    .half 115, 78, 1, 0    # janela 12
    .half 148, 78, 1, 0    # janela 13
    .half 182, 78, 1, 0    # janela 14
    .half 213, 78, 1, 0    # janela 15

FELIX_NO_JOB: .byte 0,              0   
# Posições X das quatro posições em cada linha
FELIX_FRAME: .byte 0
POINTS_X: .half 83, 115, 148, 182, 213  # Posições X das quatro posições em cada linha
POINTS_Y: .half 78, 134, 191       # Posições Y das três linhas 
                # Direita0/esquerda1, cima/baixo
FELIX_DIR: .byte 1,                 3 
                    #martelando ou não/ contador de frames



####################### FIM DOS DADOS #########################

######### PRINTA TELA INICIAL E ESPERA TECLAR ALGO ############

TIJOLOS: .half 5,
#S, X, Y
 0, 0, 0
 0, 0, 0
 0, 0, 0
 0, 0, 0
 0, 0, 0


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
    #la a0,fundo           # Carrega o endereço da imagem do fundo em a0
    #li a1,0               # Coordenada X inicial
    #li a2,0               # Coordenada Y inicial
    #li a3,0               # Framebuffer 0
    #call PRINT            # Chama a função PRINT para desenhar o fundo
    #li a3,1               # Framebuffer 1
    #call PRINT            # Chama a função PRINT para desenhar o fundo novamente
    
################### INICIO DO LOOP PRINCIPAL ################## 

GAME_LOOP:

        la t0,PONTOS #lendo a quantidade de pontos
        lb t1, 0(t0) 
        li t2,26
        bne t1,t2,FASE_1
        j PROXIMA_FASE
#
        FASE_1:        

#Configurando fps do jogo
    li a0, 30
    li a7, 32
    ecall

########### INÍCIO DO LOOP MÚSICA ############

    la t0, VIDAS
    lb t1, 0(t0)
    beqz t1, GAME_OVER
    
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
            li a3, 60  #definindo instrumento
            ecall

            li a7, 30
            ecall

            sw a0, 8(s1)

            addi s3, s3, 1
            sw s3, 4(s1)
        
    MF0:

############# FIM DO LOOP MÚSICA #############

########### RENDERIZAÇÃO DO FUNDO E DO FELIX ############

    call KEY2             # Chama a função KEY2 para verificar a tecla pressionada
    # Atualizar LED (opcional), pro personagem não piscar na tela
    li t0,0xFF200604       # Carrega o endereço do LED
    sw s0,0(t0)            # Atualiza o LED com o valor de s0
    xori s0,s0,1          # Alterna o frame buffer (0 ou 1)
    
    la t0,FASE2
    lb a1,0(t0)
    li a2,1

    la a0,fundo            # Carrega o endereço da imagem do tile em a0
    beq a1,a2,CHAMA_FASE2
    VOLTA:
    li a1,0	               # Carrega a última posição X
    li a2,0		           # Carrega a última posição Y
    mv a3, s0               # Alterna o fre para o tile
    call PRINT             # Chama a função PRINT para desenhar o tile


##########   Iniciando sistema de vidas     ############################

        la t0,VIDAS #lendo a quantidade de vidas
        lb t1, 0(t0)  #passando a quantidade de vidas pra t1
        li t2,3

        la a0,healthIcon       # Carrega o endereço da imagem do tile em a0
        li a1,295	               # Carrega a última posição X
        li a2,10		           # Carrega a última posição Y

    #Se tive 3 vidas
        blt t1,t2,VIDAS_2
        mv a3, s0              # Alterna o fre para o tile
        call PRINT             # Chama a função PRINT para desenhar o tile
VIDAS_2:
    li a1,275	               # Carrega a última posição X
    li a2,10		           # Carrega a última posição Y
    li t2,2
    blt t1,t2,VIDAS_1
    mv a3, s0              # Alterna o fre para o tile
    call PRINT             # Chama a função PRINT para desenhar o tile
VIDAS_1:
    li a1,255	           # Carrega a última posição X
    li a2,10	           # Carrega a última posição Y
    li t2,1
    blt t1,t2,GAME_OVER
    mv a3, s0              # Alterna o fre para o tile
    call PRINT             # Chama a função PRINT para desenhar o tile

        

    jal s8, IMPRIMINDO_JANELAS
    jal s8, IMPRIMIR_TIJOLOS 
    
    la t0,FELIX_NO_JOB
    lb t1,0(t0) # t1= se ta em animacao ou nao
    beqz t1, NAO_CHAMA_ANIMACAO_MARTELANDO 
    jal s8, ANIMACAO_MARTELANDO
    j  DEPOIS_NEW_PRINT_FELIX
    NAO_CHAMA_ANIMACAO_MARTELANDO:
		
    call SELECT_FELIX
    la t0,ANIMACAO_FELIX
    lh t1, 0(t0)
    bnez t1, CALL_MOVE_FELIX_ANIMACAO
    j DEPOIS_CALL_MOVE_FELIX_ANIMACAO
    CALL_MOVE_FELIX_ANIMACAO:
        call MOVE_FELIX_ANIMACAO
    DEPOIS_CALL_MOVE_FELIX_ANIMACAO:


    la t0,CHAR_POS        # Carrega o endereço da posição atual do personagem
    # Alternar frame apenas para o personagem
    lh a1,0(t0)           # Carrega a posição X atual
    lh a2,2(t0)           # Carrega a posição Y atual
    mv a3,s0              # Alterna o frame para o personagem
    call PRINT            # Chama a função PRINT para desenhar o personagem
 
    DEPOIS_NEW_PRINT_FELIX:

    ########### RENDERIZAÇÃO DO RALPH #############
    # Se primeira half de ANIMACAO_RALPH for 0, 
    # inicia movimento, caso contrário, PULA
    la t0, ANIMACAO_RALPH
    lh t1, 0(t0)
    
    bnez t1, PULA_INICIA_MOVIMENTO_RALPH    
    INICIA_MOVIMENTO_RALPH:
        call INICIA_MOVIMENTACAO_RALPH
        j DEPOIS_DA_MOVIMENTACAO_RALPH
    PULA_INICIA_MOVIMENTO_RALPH:
        li t3, 1
        beq t1, t3, CHAMA_ANIMACAO_RALPH
        li t3, 2
        beq t1, t3, CHAMA_ANIMACAO_ATAQUE_RALPH
        
        CHAMA_ANIMACAO_RALPH:
            call MOVIMENTACAO_RALPH
            j DEPOIS_DA_MOVIMENTACAO_RALPH
        CHAMA_ANIMACAO_ATAQUE_RALPH:
            jal s8, ATAQUE_RALPH
            j DEPOIS_DA_MOVIMENTACAO_RALPH
    # chamada de uma funcao pra fazer o movimento
    DEPOIS_DA_MOVIMENTACAO_RALPH:

    la t0, ANIMACAO_RALPH
    lh t1, 0(t0) # Qual animacao
    li t4, 2
    beq t1, t4, DEPOIS_IMPRIMIR_RALPH
    lh t4, 6(t0) # contador de frames
    beqz t1, CARREGA_RALPH_PARADO
    li t5, 5
    blt t4, t5, CARREGA_RALPH_ANDANDO_1
    li t5, 10 
    blt t4, t5, CARREGA_RALPH_ANDANDO_2
    sh zero, 6(t0)
    j CARREGA_RALPH_ANDANDO_2
    CARREGA_RALPH_PARADO:
        la a0, ralph3           # Endereço da imagem
        j POS_CARREGA_RALPH
    CARREGA_RALPH_ANDANDO_1:
        lh t1, 4(t0) # Se ta em direita
        bnez t1, CARREGA_ESQUERDA_1
        CARREGA_DIREITA_1:
            la a0, ralphpDireita           # Endereço da imagem
            j POS_CARREGA_RALPH
        CARREGA_ESQUERDA_1:
            la a0, ralphpEsquerda           # Endereço da imagem
            j POS_CARREGA_RALPH
    CARREGA_RALPH_ANDANDO_2:
        lh t1, 4(t0) # Se ta em direita
        bnez t1, CARREGA_ESQUERDA_2
        CARREGA_DIREITA_2:
            la a0, ralphpDireita2           # Endereço da imagem
            j POS_CARREGA_RALPH
        CARREGA_ESQUERDA_2:
            la a0, ralphpEsquerda2           # Endereço da imagem
            j POS_CARREGA_RALPH
    
    POS_CARREGA_RALPH:
    # Ralph 
    la t0, RALPH_POS
    lh a1, 0(t0)                  # Coordenada X (ajustar para centralizar)
    addi a1, a1, -10
    li a2, 5                   # Coordenada Y (no topo da tela)
    mv a3, s0                   # Framebuffer 0
    call PRINT

    DEPOIS_IMPRIMIR_RALPH:

    j GAME_LOOP            # Volta para o início do loop do jogo

################### FIM DO LOOP PRINCIPAL #####################

KEY2:   
    la t0,FELIX_NO_JOB
    lb t1,0(t0)
    bnez t1, FIM
    la t0,ANIMACAO_FELIX
    lh t1, 0(t0)
    bne t1,zero,FIM

    li t1,0xFF200000      # Carrega o endereço de controle do KDMMIO
    lw t0,0(t1)           # Lê bit de controle do teclado
    andi t0,t0,0x0001     # Máscara para o bit menos significativo
    beq t0,zero,FIM       # Se não há tecla pressionada, pula para FIM
    lw t2,4(t1)           # Lê o valor da tecla pressionada

    li t0,'m'             # Carrega o valor ASCII da tecla 'm'
    beq t2,t0,INICIANDO_JOB # Se 'm' é pressionado, pula para INICIANDO_JOB
    li t0,'a'             # Carrega o valor ASCII da tecla 'a'
    beq t2,t0,MOVE_LEFT   # Se 'a' é pressionado, pula para MOVE_LEFT
    li t0,'d'             # Carrega o valor ASCII da tecla 'd'
    beq t2,t0,MOVE_RIGHT  # Se 'd' é pressionado, pula para MOVE_RIGHT
    li t0,'w'             # Carrega o valor ASCII da tecla 'w'
    beq t2,t0,MOVE_UP     # Se 'w' é pressionado, pula para MOVE_UP
    li t0,'s'             # Carrega o valor ASCII da tecla 's'
    beq t2,t0,MOVE_DOWN   # Se 's' é pressionado, pula para MOVE_DOWN

    li t0,'A'             # Carrega o valor ASCII da tecla 'a'
    beq t2,t0,MOVE_LEFT   # Se 'a' é pressionado, pula para MOVE_LEFT
    li t0,'D'             # Carrega o valor ASCII da tecla 'd'
    beq t2,t0,MOVE_RIGHT  # Se 'd' é pressionado, pula para MOVE_RIGHT
    li t0,'M'             # Carrega o valor ASCII da tecla 'm'
    beq t2,t0,INICIANDO_JOB # Se 'm' é pressionado, pula para INICIANDO_JOB
    li t0,'W'             # Carrega o valor ASCII da tecla 'w'
    beq t2,t0,MOVE_UP     # Se 'w' é pressionado, pula para MOVE_UP
    li t0,'S'             # Carrega o valor ASCII da tecla 's'
    beq t2,t0,MOVE_DOWN   # Se 's' é pressionado, pula para MOVE_DOWN
    li t0,'p'             # Carrega o valor ASCII da tecla 's'
    beq t2,t0,PROXIMA_FASE   # Se 's' é pressionado, pula para PROXIMA_FASE
    li t0,'P'             # Carrega o valor ASCII da tecla 's'
    beq t2,t0,PROXIMA_FASE   # Se 's' é pressionado, pula para PROXIMA_FASE

FIM:    
    ret                   # Retorna da função

PROXIMA_FASE:

    la t0, windows
    sh zero, 6(t0)
    sh zero, 14(t0)
    sh zero, 22(t0)
    sh zero, 30(t0)
    sh zero, 38(t0)
    sh zero, 46(t0)
    sh zero, 54(t0)
    sh zero, 62(t0)
    sh zero, 70(t0)
    sh zero, 78(t0)
    sh zero, 86(t0)
    sh zero, 94(t0)
    sh zero, 102(t0)
    la t0,FASE2
    li t1,1
    sb t1,0(t0)
    la t0,PONTOS #lendo a quantidade de pontos
    li t2, 27
    sb t2, 0(t0)
    ret


IMPRIMIR_TIJOLOS:
    la s1, TIJOLOS
    lh s2, 0(s1)
    li s3, 0
    addi s1, s1, 2
    LOOP_IMPRIMINDO_TIJOLO:
        # LER E IMPRIMIR o TIJOLO
        beq s3, s2, FINAL_LOOP_IMPRIME_TIJOLO
        lh t3, 0(s1)
        beqz t3, DEPOIS_DE_IMPRIMIR_TIJOLO
        la a0, tijolo
        lh a1, 2(s1)
        addi a1, a1, 5
        lh a2, 4(s1)
        addi a2, a2, 2
        sh a2, 4(s1)

        li t3, 260
        bgt a2, t3, EXCLUIR_TIJOLO

        mv a3, s0
        call PRINT

        lh a1, 2(s1)
        la t1, CHAR_POS
        lh t2, 0(t1)  # x
        bne t2, a1, DEPOIS_DE_IMPRIMIR_TIJOLO
        lh t2, 2(t1) # y
        lh a1, 4(s1) # y do tijolo
        addi a1, a1, 25
        blt a1, t2, DEPOIS_DE_IMPRIMIR_TIJOLO
        addi a1, a1, -25
        addi t2, t2, 36
        bgt a1, t2, DEPOIS_DE_IMPRIMIR_TIJOLO 
        call EXCLUIR_TIJOLO
        la t0, VIDAS
        lb t1, 0(t0)
        addi t1, t1, -1
        sb t1, 0(t0)
        
         
        DEPOIS_DE_IMPRIMIR_TIJOLO:
        addi s1, s1, 6
        addi s3, s3, 1
        j LOOP_IMPRIMINDO_TIJOLO
    FINAL_LOOP_IMPRIME_TIJOLO:
    jalr t0, s8, 0

EXCLUIR_TIJOLO:
    sh zero, 0(s1)
    sh zero, 2(s1)
    sh zero, 4(s1)
    ret

ATAQUE_RALPH:
    la t1, ANIMACAO_RALPH
    lh t2, 6(t1)
    addi t2, t2, 1 
    sh t2, 6(t1)

    li t3, 5
    blt t2, t3, CARREGAR_ATQ1
    li t3, 10
    blt t2, t3, CARREGAR_ATQ2
    beq t3, t2, CRIAR_TIJOLO
    la t1, ANIMACAO_RALPH
    lh t2, 6(t1)
    addi t2, t2, 1 
    sh t2, 6(t1)
    li t3, 15
    blt t2, t3, CARREGAR_ATQ1
    li t3, 20
    blt t2, t3, CARREGAR_ATQ2
    li t3, 25
    blt t2, t3, CARREGAR_ATQ1
    li t3, 30
    blt t2, t3, CARREGAR_ATQ2

    sh zero, 0(t1)

    CARREGAR_ATQ1:
        la a0, RalphAtaque1
        j POS_CARREGA_ATAQUE
    CARREGAR_ATQ2:
        la a0, RalphAtaque2
        j POS_CARREGA_ATAQUE
    POS_CARREGA_ATAQUE:

    la t4, RALPH_POS
    lh a1, 0(t4)# x
    addi a1, a1, -18
    li a2, 5
    call PRINT

    jalr t0, s8, 0

CRIAR_TIJOLO:
    la t0, TIJOLOS
    lh t1, 0(t0)
    li t2, 0
    addi t0, t0, 2
    LOOP_PROCURA_LUGAR_PRA_TIJOLO:
        beq t2, t1, FINAL_LOOP_PROCURA_TIJOLO
        lh t3, 0(t0)
        bnez t3, NAO_CRIA_TIJOLO
        li t4, 2
        sh t4, 0(t0)
        li t4, 10
        la t5, RALPH_POS
        lh t6, 0(t5)
        sh t6, 2(t0)
        sh t4, 4(t0)
        j FINAL_LOOP_PROCURA_TIJOLO
        NAO_CRIA_TIJOLO:
        addi t0, t0, 6
        addi t2, t2, 1
        j LOOP_PROCURA_LUGAR_PRA_TIJOLO 
    FINAL_LOOP_PROCURA_TIJOLO:

    ret

########## LÓGICA DE MOVIMENTAÇÃO DO PERSONAGEM ########## 

MOVE_LEFT:
    la t0,FELIX_DIR
    li t1,1
    sb t1,0(t0)
    la t0, ANIMACAO_FELIX
    li t1, 1
    sh t1, 0(t0)
    la t2, CHAR_POS
    lh t3, 2(t2) # t3 = y do personagem
    sh t3, 4(t0) 
    lh t3, 0(t2) # t3 = x do personagem

    # X alvo:
    la t2,POINTS_X        # Carrega o endereço dos pontos X
    lh t6,0(t2)           # Carrega o ponto X 1
    lh t1,2(t2)           # Carrega o ponto X 2
    lh t4,4(t2)           # Carrega o ponto X 3
    lh t5,6(t2)           # Carrega o ponto X 4  
    lh s10,8(t2)          # Carrega o ponto X 5 

    beq t3,s10,SET_X4_LEFT # Se a posição atual é o ponto 1, move para o ponto 2
    beq t3,t5,SET_X3_LEFT # Se a posição atual é o ponto 2, move para o ponto 3
    beq t3, t4, SET_X2_LEFT
    beq t3, t1, SET_X1_LEFT
    j POS_SET_LEFT

    SET_X2_LEFT:
        la t0, ANIMACAO_FELIX
        sh t1,2(t0)           # Atualiza a posição X para o ponto 2
        j POS_SET_LEFT
    SET_X3_LEFT:
        la t0, ANIMACAO_FELIX
        sh t4,2(t0)           # Atualiza a posição X para o ponto 2
        j POS_SET_LEFT
    SET_X4_LEFT:
        la t0, ANIMACAO_FELIX
        sh t5,2(t0)           # Atualiza a posição X para o ponto 2
        j POS_SET_LEFT
    SET_X1_LEFT:
        la t0, ANIMACAO_FELIX
        sh t6,2(t0)           # Atualiza a posição X para o ponto 2
        j POS_SET_LEFT

    POS_SET_LEFT:
    ret

MOVE_RIGHT:
    la t0,FELIX_DIR
    li t1,0
    sb t1,0(t0)
    la t0, ANIMACAO_FELIX
    li t1, 1
    sh t1, 0(t0)
    la t2, CHAR_POS
    lh t3, 2(t2) # t3 = y do personagem
    sh t3, 4(t0)    # salva o y do personagem como alvo da animacao
    lh t3, 0(t2) # t3 = x do personagem

    # X alvo:
    la t2,POINTS_X        # Carrega o endereço dos pontos X
    lh t0,0(t2)           # Carrega o ponto X 1
    lh t1,2(t2)           # Carrega o ponto X 2
    lh t4,4(t2)           # Carrega o ponto X 3
    lh t5,6(t2)           # Carrega o ponto X 4
    lh t6,8(t2)           # Carrega o ponto X 5

    beq t3,t0,SET_X2_RIGHT # Se a posição atual é o ponto 1, move para o ponto 2
    beq t3,t1,SET_X3_RIGHT # Se a posição atual é o ponto 2, move para o ponto 3
    beq t3, t4, SET_X4_RIGHT
    beq t3, t5, SET_X5_RIGHT
    j POS_SET_RIGHT

    SET_X2_RIGHT:
        la t0, ANIMACAO_FELIX
        sh t1,2(t0)           # Atualiza a posição X para o ponto 2
        j POS_SET_RIGHT
    SET_X3_RIGHT:
        la t0, ANIMACAO_FELIX
        sh t4,2(t0)           # Atualiza a posição X para o ponto 2
        j POS_SET_RIGHT
    SET_X4_RIGHT:
        la t0, ANIMACAO_FELIX
        sh t5,2(t0)           # Atualiza a posição X para o ponto 2
        j POS_SET_RIGHT
    SET_X5_RIGHT:
        la t0, ANIMACAO_FELIX
        sh t6,2(t0)           # Atualiza a posição X para o ponto 2
        j POS_SET_RIGHT

    POS_SET_RIGHT:
    ret

MOVE_UP: 
    la t0,FELIX_DIR
    li t1,0
    sb t1,1(t0)
    la t0, ANIMACAO_FELIX
    li t1, 1
    sh t1, 0(t0)
    la t2, CHAR_POS
    lh t3, 0(t2) # t3 = x do personagem
    sh t3, 2(t0)    # salva o x do personagem como alvo da animacao

    lh t1,2(t2)           # Carrega a posição Y atual
    la t2,POINTS_Y        # Carrega o endereço dos pontos Y
    lh t3,0(t2)           # Carrega o ponto Y 1
    lh t4,2(t2)           # Carrega o ponto Y 2
    lh t5,4(t2)           # Carrega o ponto Y 3

    beq t1,t4,SET_Y1      # Se a posição atual é o ponto 2, move para o ponto 1
    beq t1,t5,SET_Y2      # Se a posição atual é o ponto 3, move para o ponto 2
    ret
SET_Y1:
    sh t3,4(t0)           # Atualiza a posição Y para o ponto 1
    ret                   # Retorna da função

MOVE_DOWN: 
    la t0,FELIX_DIR
    li t1,1
    sb t1,1(t0)
    la t0, ANIMACAO_FELIX
    li t1, 1
    sh t1, 0(t0)
    la t2, CHAR_POS
    lh t3, 0(t2) # t3 = x do personagem
    sh t3, 2(t0)    # salva o x do personagem como alvo da animacao

    lh t1,2(t2)           # Carrega a posição Y atual
    la t2,POINTS_Y        # Carrega o endereço dos pontos Y
    lh t3,0(t2)           # Carrega o ponto Y 1
    lh t4,2(t2)           # Carrega o ponto Y 2
    lh t5,4(t2)           # Carrega o ponto Y 3

    beq t1,t3,SET_Y2      # Se a posição atual é o ponto 1, move para o ponto 2
    beq t1,t4,SET_Y3      # Se a posição atual é o ponto 3, move para o ponto 2
    ret

SET_Y2:
    sh t4,4(t0)           
    ret                   

SET_Y3:
    sh t5,4(t0)           # Atualiza a posição Y para o ponto 3
    ret                   # Retorna da função

SELECT_FELIX:
    la t0, FELIX_DIR
    lb t0, 0(t0)
    beq t0, zero, FELIX_RIGHT
    li t1, 1
    beq t0, t1, FELIX_LEFT
    FELIX_RIGHT:
        la t0, ANIMACAO_FELIX
        lh t3, 0(t0)
        la t2, FELIX_FRAME
        lb t0,0(t2)
        beqz t3,NOT_PULANDO
        la a0,AndarSemMarteloPDireitaFelix
        ret
        NOT_PULANDO:  
            li t1,20
            blt t0,t1,NOT_ZERA_ANIMACAO
                li t0,0
                sb t0,0(t2)
                la a0, felix
                ret
            NOT_ZERA_ANIMACAO:
            li t1,10
            bge t0,t1,NOT_REBAIXADO
                addi t0,t0,1
                sb t0,0(t2)
                la a0, FelixRebaixado
                ret
            NOT_REBAIXADO:
                addi t0,t0,1
                sb t0,0(t2)
                la a0, felix
                ret
    FELIX_LEFT:
        la t0, ANIMACAO_FELIX
        lh t3, 0(t0)
        la t2, FELIX_FRAME
        lb t0,0(t2)
        beqz t3,NOT_PULANDO_LEFT
        la a0,AndarSemMarteloPEsquerdaFelix
        ret
        NOT_PULANDO_LEFT:
            li t1,20
            blt t0,t1,NOT_ZERA_ANIMACAO_LEFT
                li t0,0
                sb t0,0(t2)
                la a0, FelixOutroLado
                ret
            NOT_ZERA_ANIMACAO_LEFT:
            li t1,10
            bge t0,t1,NOT_REBAIXADO_LEFT
                addi t0,t0,1
                andi t0,t0,255
                sb t0,0(t2)
                la a0, FelixOutroLadoRebaixado
                ret
            NOT_REBAIXADO_LEFT:
                addi t0,t0,1
                andi t0,t0,255
                sb t0,0(t2)
                la a0, FelixOutroLado
                ret
            
ANIMACAO_MARTELANDO:
    la t0,FELIX_NO_JOB
    lb t1,1(t0)
    addi t1,t1,1
    sb t1,1(t0)

    la t6,CHAR_POS        # Carrega o endereço da posição atual do personagem
    # Alternar frame apenas para o personagem
    lh a1,0(t6)           # Carrega a posição X atual
    lh a2,2(t6)           # Carrega a posição Y atual
    mv a3,s0              # Alterna o frame para o personagem 

    li t2, 5
    blt t1,t2,CARREGA_MARTELANDO_1
    li t2,10
    blt t1,t2,CARREGA_MARTELANDO_2
    sb zero,0(t0)
    sb zero,1(t0)

	la t0,windows
	li t1,-1 #contador 
	li t2,13
	la t3,CHAR_POS
	lh t4,0(t3) #lendo o x atual
	lh t5,2(t3) #lendo o y atual
	addi t0,t0,-8
	PROCURANDO_JANELINHA:
		addi t0,t0,8
		addi t1,t1,1
		beq t1,t2,FIM_PROCURANDO_JANELINHA
		lh t6,0(t0)
		bne t6,t4,PROCURANDO_JANELINHA
		lh t6,2(t0)
		bne t6,t5,PROCURANDO_JANELINHA

		lh t1,6(t0) #lendo o status da janelinha que eu achei
		li t2,2
		beq t1,t2,FIM_PROCURANDO_JANELINHA
		addi t1,t1,1
		sh t1,6(t0)  #salvando novo status da janelinha

        la t0,PONTOS #lendo a quantidade de pontos
        lb a0, 0(t0) 
        addi a0,a0,1
        sb a0,0(t0) #alterando para a nova quantidade de pontos

	FIM_PROCURANDO_JANELINHA:
		jalr t0, s8, 0

    CARREGA_MARTELANDO_2:
        la t0,FELIX_DIR
        lb t1,0(t0)
        li t2,1
        beq t1,t2,CARREGA_MARTELANDO_ESQUERDA
        la a0, MartelandoPDireitaFelix
        j DEPOIS_CARREGA_MARTELANDO
        CARREGA_MARTELANDO_ESQUERDA:
            addi a1, a1,-10 
            la a0,MartelandoPEsquerdaFelix
            j DEPOIS_CARREGA_MARTELANDO
    CARREGA_MARTELANDO_1:
        la t0,FELIX_DIR
        lb t1,0(t0)
        li t2,1
        beq t1,t2,CARREGA_MARTELANDO_ESQUERDA_1
        la a0, Martelando1PDireitaFelix
        j DEPOIS_CARREGA_MARTELANDO
        CARREGA_MARTELANDO_ESQUERDA_1:
            addi a1, a1,-10 
            la a0,Martelando1PEsquerdaFelix
            j DEPOIS_CARREGA_MARTELANDO

    DEPOIS_CARREGA_MARTELANDO:
    call PRINT            # Chama a função PRINT para desenhar o personagem
    jalr t0, s8, 0
#################### FUNÇÃO DE PRINT ####################

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

MOVE_FELIX_ANIMACAO:
    la t0, ANIMACAO_FELIX 
    la t3, CHAR_POS
    la t2, FELIX_DIR
    lb t2, 0(t2)
    lh t1, 4(t0) # t1 = y alvo
    lh t4, 2(t3) # t4 = y atual do personagem

    la t6, FELIX_DIR # t6 = endereço da direção do personagem
    lb t5, 1(t6) # t5 = direção do personagem
    beqz t5,MOVE_CIMA # se o personagem está acima do alvo, move para baixo
    li s10, 1
    beq t5, s10, MOVE_BAIXO # se o personagem está abaixo do alvo, move para cima
    j POS_MOVE_DIAGONAL
    MOVE_CIMA:
        blt t4,t1,FIM_ANIMACAO_FELIX # se o personagem já chegou no alvo, termina a animação
        addi t4, t4,-6 # se o personagem ainda não chegou no alvo, move para cima
        sh t4, 2(t3) # atualiza a posição do personagem
        j DEPOIS_FIM_ANIMACAO_FELIX
    MOVE_BAIXO:

        bge t4,t1,FIM_ANIMACAO_FELIX # se o personagem já chegou no alvo, termina a animação
        addi t4,t4,6 # se o personagem ainda não chegou no alvo, move para baixo
        sh t4, 2(t3) # atualiza a posição do personagem
        j DEPOIS_FIM_ANIMACAO_FELIX
    POS_MOVE_DIAGONAL:

    lh t1, 2(t0) # t1 = x alvo
    lh t4, 0(t3) # t4 = x atual do personagem

    la t2, FELIX_DIR
    lb t2, 0(t2)
    beq t2, zero, MOVE_DIREITA
    MOVE_ESQUERDA:
        ble t4, t1, FIM_ANIMACAO_FELIX # se o personagem já chegou no alvo, termina a animação
        addi t4, t4, -4 # se o personagem ainda não chegou no alvo, move para esquerda
        sh t4, 0(t3) # atualiza a posição do personagem
        j DEPOIS_FIM_ANIMACAO_FELIX

    MOVE_DIREITA:
        bge t4, t1, FIM_ANIMACAO_FELIX # se o personagem já chegou no alvo, termina a animação
        addi t4, t4, 4 # se o personagem ainda não chegou no alvo, move para direita
        sh t4, 0(t3) # atualiza a posição do personagem
        j DEPOIS_FIM_ANIMACAO_FELIX
    FIM_ANIMACAO_FELIX:
        la t0,FELIX_DIR
        li t1,3
        sb t1,1(t0)
        la t0, ANIMACAO_FELIX
        li t1, 0
        sh t1, 0(t0)    #salvando o status da animacao pra 0
        la t2, CHAR_POS #carregando a posicao do personagem
        lh t3, 2(t0)   #carregando o x alvo da animacao
        sh t3, 0(t2)  #atualizando a posicao do personagem
        lh t3, 4(t0)   #carregando o y alvo da animacao
        sh t3, 2(t2)  #atualizando a posicao do personagem
    DEPOIS_FIM_ANIMACAO_FELIX:
        ret 

INICIA_MOVIMENTACAO_RALPH:

    li a7, 30 # codigo da ecall de tempo
    ecall # a0 = momento atual

    la t4, INTERVALO_MOVIMENTO_RALPH
    lw t5, 0(t4)
    sub t0, a0, t5
    li t6, 3000

    bltu t0, t6, DEPOIS_MOVIMENTACAO
    
    SORTEAR:
    li a0, 0 # menor numero gerado  
    li a1, 5 # maior numero gerado 
    li a7, 42 # codigo de geral numero aleatorio 
    ecall  # a0 = numero aleatorio

    li t0, 2
    mul t1, t0, a0 # Quantos bytes a partir da primeira half
    la t0, POINTS_X
    add t0, t0, t1

    lh t2, 0(t0) # x pra onde ele vai
    la t3, RALPH_POS
    lh t4, 0(t3) # x atual
    beq t2, t4, SORTEAR

    # sh t2, 0(t3) 

    li a7, 30 # codigo da ecall de tempo
    ecall # a0 , = momento atual
    la t0, INTERVALO_MOVIMENTO_RALPH
    sw a0, 0(t0)

    bgt t4, t2, SALVA_MOVIMENTO_RALPH_ESQUERDA
    SALVA_MOVIMENTO_RALPH_DIREITA:
        li t6, 0
        j DEPOIS_ESQUERDA_DIREITA
    SALVA_MOVIMENTO_RALPH_ESQUERDA:
        li t6, 1
    DEPOIS_ESQUERDA_DIREITA:

    la t0, ANIMACAO_RALPH
    li t1, 1
    sh t1, 0(t0)
    sh t2, 2(t0)
    sh t6, 4(t0)

    DEPOIS_MOVIMENTACAO:
    ret

MOVIMENTACAO_RALPH:
    # Vai somar ou subtrair enquanto nao chegou no alvo

    la t0, RALPH_POS
    lh t1, 0(t0) # posicao atual 
    la t3, ANIMACAO_RALPH 
    lh t2, 2(t3) # posicao alvo 
    lh t4, 4(t3)
    lh t5, 6(t3)
    addi t5, t5, 1
    sh t5, 6(t3)

    bnez t4, MOVE_ESQUERDA_RALPH 
    MOVE_DIREITA_RALPH:
        bge t1, t2, FIM_ANIMACAO_RALPH
        addi t1, t1, 2
        sh t1, 0(t0)
        ret
    MOVE_ESQUERDA_RALPH:
        ble t1, t2, FIM_ANIMACAO_RALPH
        addi t1, t1,-2
        sh t1, 0(t0)
        ret

    FIM_ANIMACAO_RALPH: 
    
    li t6, 2
    sh t6, 0(t3) 
    sh zero, 6(t3)
    sh t2, 0(t0)

    
    ret

IMPRIMINDO_JANELAS:
    la s11,windows
    li s10,0
    li s9,13
    LOOP_IMPRIMIR_JANELAS:
        lh t0, 6(s11) # status da janela
        li t1,0
        li t2,1
        li t3,2
        beq t0, t3, CARREGA_WINDOW_PERFECT
        beq t0, t2, CARREGA_WINDOW_QUASE_PERFEITA
        #beq t0, t1, CARREGA_WINDOW_QUEBRADA
        CARREGA_WINDOW_QUEBRADA:
            la a0,janelaTotalmenteQuebrada
            j POS_CARREGA_JANELA
        CARREGA_WINDOW_QUASE_PERFEITA:
            la a0,janelaQuasePerfeita
            j POS_CARREGA_JANELA
        CARREGA_WINDOW_PERFECT:
            la a0,janelinhaPerfeita
        POS_CARREGA_JANELA:

        lh a1,0(s11)             # Coordenada X inicial
        lh a2,2(s11)            # Coordenada Y inicial
        mv a3, s0               # Framebuffer 0
        call PRINT            # Chama a função PRINT para desenhar o fundo
        addi s10,s10,1      # Incrementa o contador de janelas
        addi s11,s11,8    # Próxima janelinha
        blt s10,s9,LOOP_IMPRIMIR_JANELAS # Continua até imprimir todas as janelinhas
    
    jalr t0, s8, 0

INICIANDO_JOB:

    li a0, 75                # Lê o valor da nota
    li a1, 234               # Lê a duração da nota
    li a2, 81                # Define o instrumento
    li a3, 127               # Define o volume
    li a7, 31                # Define a syscall para tocar a nota
    ecall                    # Toca a nota

    la t0, FELIX_NO_JOB
    li t1, 1
    sb t1, 0(t0)
    ret

GAME_OVER:
li a7,10
ecall

CHAMA_FASE2:


li a0, fundo2
j VOLTA
