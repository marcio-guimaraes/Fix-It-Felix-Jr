
.data
CHAR_POS: .half 0,0       # Posição atual do personagem (X, Y)
OLD_CHAR_POS: .half 0,0   # Última posição do personagem (X, Y)

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

GAME_LOOP:
    call KEY2             # Chama a função KEY2 para verificar a tecla pressionada
    xori s0,s0,1          # Alterna o frame buffer (0 ou 1)
    
    la t0,CHAR_POS        # Carrega o endereço da posição atual do personagem

    # Alternar frame apenas para o personagem
    la a0,felix           # Carrega o endereço da imagem do personagem "felix" em a0
    lh a1,0(t0)           # Carrega a posição X atual
    lh a2,2(t0)           # Carrega a posição Y atual
    mv a3,s0              # Alterna o frame para o personagem
    call PRINT            # Chama a função PRINT para desenhar o personagem

    # Atualizar LED (opcional)
    li t0,0xFF200604      # Carrega o endereço do LED
    sw s0,0(t0)           # Atualiza o LED com o valor de s0
    
    la t0,OLD_CHAR_POS    # Carrega o endereço da última posição do personagem

    la a0,fundo            # Carrega o endereço da imagem do tile em a0
    li a1,0	           # Carrega a última posição X
    li a2,0		   # Carrega a última posição Y
    
    mv a3,s0              # Alterna o frame para o tile
    xori a3,a3,1          # Alterna o frame buffer
    call PRINT            # Chama a função PRINT para desenhar o tile
    
    j GAME_LOOP           # Volta para o início do loop do jogo

KEY2:   
    li t1,0xFF200000      # Carrega o endereço de controle do KDMMIO
    lw t0,0(t1)           # Lê bit de controle do teclado
    andi t0,t0,0x0001     # Máscara para o bit menos significativo
    beq t0,zero,FIM       # Se não há tecla pressionada, pula para FIM
    lw t2,4(t1)           # Lê o valor da tecla pressionada

    li t0,'w'             # Carrega o valor ASCII da tecla 'w'
    beq t2,t0,WALK_UP     # Se 'w' é pressionado, pula para WALK_UP
    
    li t0,'a'             # Carrega o valor ASCII da tecla 'a'
    beq t2,t0,WALK_LEFT   # Se 'a' é pressionado, pula para WALK_LEFT

    li t0,'s'             # Carrega o valor ASCII da tecla 's'
    beq t2,t0,WALK_DOWN   # Se 's' é pressionado, pula para WALK_DOWN

    li t0,'d'             # Carrega o valor ASCII da tecla 'd'
    beq t2,t0,WALK_RIGHT  # Se 'd' é pressionado, pula para WALK_RIGHT

FIM:    
    ret                   # Retorna da função

WALK_LEFT: 
    la t0,CHAR_POS        # Carrega o endereço da posição atual do personagem
    la t1,OLD_CHAR_POS    # Carrega o endereço da última posição do personagem
    lw t2,0(t0)           # Carrega a posição atual
    sw t2,0(t1)           # Salva a posição atual como a última posição
    
    lh t1,0(t0)           # Carrega a posição X atual
    addi t1,t1,-16        # Move 16 pixels à esquerda
    bge t1,zero,OK_LEFT   # Verifica se está dentro da borda esquerda (>= 0)
    li t1,0               # Se ultrapassar, força posição X = 0
OK_LEFT:
    sh t1,0(t0)           # Atualiza a posição X
    ret                   # Retorna da função

WALK_RIGHT: 
    la t0,CHAR_POS        # Carrega o endereço da posição atual do personagem
    la t1,OLD_CHAR_POS    # Carrega o endereço da última posição do personagem
    lw t2,0(t0)           # Carrega a posição atual
    sw t2,0(t1)           # Salva a posição atual como a última posição

    lh t1,0(t0)           # Carrega a posição X atual
    addi t1,t1,16         # Move 16 pixels à direita
    li t2,304             # Limite direito (320 - largura do personagem, 16px)
    blt t1,t2,OK_RIGHT    # Verifica se está dentro da borda direita (< 304)
    li t1,304             # Se ultrapassar, força posição X = 304
OK_RIGHT:
    sh t1,0(t0)           # Atualiza a posição X
    ret                   # Retorna da função

WALK_UP: 
    la t0,CHAR_POS        # Carrega o endereço da posição atual do personagem
    la t1,OLD_CHAR_POS    # Carrega o endereço da última posição do personagem
    lw t2,0(t0)           # Carrega a posição atual
    sw t2,0(t1)           # Salva a posição atual como a última posição
    
    lh t1,2(t0)           # Carrega a posição Y atual
    addi t1,t1,-16        # Move 16 pixels para cima
    bge t1,zero,OK_UP     # Verifica se está dentro da borda superior (>= 0)
    li t1,0               # Se ultrapassar, força posição Y = 0
OK_UP:
    sh t1,2(t0)           # Atualiza a posição Y
    ret                   # Retorna da função

WALK_DOWN: 
    la t0,CHAR_POS        # Carrega o endereço da posição atual do personagem
    la t1,OLD_CHAR_POS    # Carrega o endereço da última posição do personagem
    lw t2,0(t0)           # Carrega a posição atual
    sw t2,0(t1)           # Salva a posição atual como a última posição

    lh t1,2(t0)           # Carrega a posição Y atual
    addi t1,t1,16         # Move 16 pixels para baixo
    li t2,224             # Limite inferior (240 - altura do personagem, 16px)
    blt t1,t2,OK_DOWN     # Verifica se está dentro da borda inferior (< 224)
    li t1,224             # Se ultrapassar, força posição Y = 224
OK_DOWN:
    sh t1,2(t0)           # Atualiza a posição Y
    ret                   # Retorna da função

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

.data
.include "imagens/felix.data"        # Inclui dados da imagem do personagem
.include "imagens/fundo.data"        # Inclui dados da imagem do fundo
.include "imagens/tile.data"         # Inclui dados da imagem do tile
.include "imagens/telainicial.data"  # Inclui dados da imagem da tela inicial

#marcin o mais lindo