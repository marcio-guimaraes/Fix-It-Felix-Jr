.data
CHAR_POS: .half 0,0       # Posi��o atual do personagem (X, Y)
OLD_CHAR_POS: .half 0,0   # �ltima posi��o do personagem (X, Y)

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
    call KEY2             # Chama a fun��o KEY2 para verificar a tecla pressionada
    xori s0,s0,1          # Alterna o frame buffer (0 ou 1)
    
    la t0,CHAR_POS        # Carrega o endere�o da posi��o atual do personagem

    # Alternar frame apenas para o personagem
    la a0,felix           # Carrega o endere�o da imagem do personagem "felix" em a0
    lh a1,0(t0)           # Carrega a posi��o X atual
    lh a2,2(t0)           # Carrega a posi��o Y atual
    mv a3,s0              # Alterna o frame para o personagem
    call PRINT            # Chama a fun��o PRINT para desenhar o personagem

    # Atualizar LED (opcional)
    li t0,0xFF200604      # Carrega o endere�o do LED
    sw s0,0(t0)           # Atualiza o LED com o valor de s0
    
    la t0,OLD_CHAR_POS    # Carrega o endere�o da �ltima posi��o do personagem
    
    # Desenha o fundo uma vez no in�cio
    la a0,fundo           # Carrega o endere�o da imagem do fundo em a0
    li a1,0               # Coordenada X inicial
    li a2,0               # Coordenada Y inicial
    li a3,0               # Framebuffer 0
    call PRINT            # Chama a fun��o PRINT para desenhar o fundo
    li a3,1               # Framebuffer 1
    call PRINT            # Chama a fun��o PRINT para desenhar o fundo novamente
    
    xori s0,s0,1          # Alterna o frame buffer (0 ou 1)
    la a0,felix           # Carrega o endere�o da imagem do personagem "felix" em a0
    lh a1,0(t0)           # Carrega a posi��o X atual
    lh a2,2(t0)           # Carrega a posi��o Y atual
    mv a3,s0              # Alterna o frame para o personagem
    call PRINT            # Chama a fun��o PRINT para desenhar o personagem
    
    j GAME_LOOP           # Volta para o in�cio do loop do jogo

KEY2:   
    li t1,0xFF200000      # Carrega o endere�o de controle do KDMMIO
    lw t0,0(t1)           # L� bit de controle do teclado
    andi t0,t0,0x0001     # M�scara para o bit menos significativo
    beq t0,zero,FIM       # Se n�o h� tecla pressionada, pula para FIM
    lw t2,4(t1)           # L� o valor da tecla pressionada

    li t0,'w'             # Carrega o valor ASCII da tecla 'w'
    beq t2,t0,WALK_UP     # Se 'w' � pressionado, pula para WALK_UP
    
    li t0,'a'             # Carrega o valor ASCII da tecla 'a'
    beq t2,t0,WALK_LEFT   # Se 'a' � pressionado, pula para WALK_LEFT

    li t0,'s'             # Carrega o valor ASCII da tecla 's'
    beq t2,t0,WALK_DOWN   # Se 's' � pressionado, pula para WALK_DOWN

    li t0,'d'             # Carrega o valor ASCII da tecla 'd'
    beq t2,t0,WALK_RIGHT  # Se 'd' � pressionado, pula para WALK_RIGHT

FIM:    
    ret                   # Retorna da fun��o

WALK_LEFT: 
    la t0,CHAR_POS        # Carrega o endere�o da posi��o atual do personagem
    la t1,OLD_CHAR_POS    # Carrega o endere�o da �ltima posi��o do personagem
    lw t2,0(t0)           # Carrega a posi��o atual
    sw t2,0(t1)           # Salva a posi��o atual como a �ltima posi��o
    
    lh t1,0(t0)           # Carrega a posi��o X atual
    addi t1,t1,-16        # Move 16 pixels � esquerda
    bge t1,zero,OK_LEFT   # Verifica se est� dentro da borda esquerda (>= 0)
    li t1,0               # Se ultrapassar, for�a posi��o X = 0
OK_LEFT:
    sh t1,0(t0)           # Atualiza a posi��o X
    ret                   # Retorna da fun��o

WALK_RIGHT: 
    la t0,CHAR_POS        # Carrega o endere�o da posi��o atual do personagem
    la t1,OLD_CHAR_POS    # Carrega o endere�o da �ltima posi��o do personagem
    lw t2,0(t0)           # Carrega a posi��o atual
    sw t2,0(t1)           # Salva a posi��o atual como a �ltima posi��o

    lh t1,0(t0)           # Carrega a posi��o X atual
    addi t1,t1,16         # Move 16 pixels � direita
    li t2,304             # Limite direito (320 - largura do personagem, 16px)
    blt t1,t2,OK_RIGHT    # Verifica se est� dentro da borda direita (< 304)
    li t1,304             # Se ultrapassar, for�a posi��o X = 304
OK_RIGHT:
    sh t1,0(t0)           # Atualiza a posi��o X
    ret                   # Retorna da fun��o

WALK_UP: 
    la t0,CHAR_POS        # Carrega o endere�o da posi��o atual do personagem
    la t1,OLD_CHAR_POS    # Carrega o endere�o da �ltima posi��o do personagem
    lw t2,0(t0)           # Carrega a posi��o atual
    sw t2,0(t1)           # Salva a posi��o atual como a �ltima posi��o
    
    lh t1,2(t0)           # Carrega a posi��o Y atual
    addi t1,t1,-16        # Move 16 pixels para cima
    bge t1,zero,OK_UP     # Verifica se est� dentro da borda superior (>= 0)
    li t1,0               # Se ultrapassar, for�a posi��o Y = 0
OK_UP:
    sh t1,2(t0)           # Atualiza a posi��o Y
    ret                   # Retorna da fun��o

WALK_DOWN: 
    la t0,CHAR_POS        # Carrega o endere�o da posi��o atual do personagem
    la t1,OLD_CHAR_POS    # Carrega o endere�o da �ltima posi��o do personagem
    lw t2,0(t0)           # Carrega a posi��o atual
    sw t2,0(t1)           # Salva a posi��o atual como a �ltima posi��o

    lh t1,2(t0)           # Carrega a posi��o Y atual
    addi t1,t1,16         # Move 16 pixels para baixo
    li t2,224             # Limite inferior (240 - altura do personagem, 16px)
    blt t1,t2,OK_DOWN     # Verifica se est� dentro da borda inferior (< 224)
    li t1,224             # Se ultrapassar, for�a posi��o Y = 224
OK_DOWN:
    sh t1,2(t0)           # Atualiza a posi��o Y
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