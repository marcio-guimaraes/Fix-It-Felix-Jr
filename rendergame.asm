.data
CHAR_POS: .half 0,0
OLD_CHAR_POS: .half 0,0

.text
SETUP:
	la a0,telainicial
	li a1,0
	li a2,0
	li a3,0
	call PRINT
	
	### Espera o usu�rio pressionar uma tecla
KEY1: 	li t1,0xFF200000		# carrega o endere�o de controle do KDMMIO
LOOP: 	lw t0,0(t1)			# Le bit de Controle Teclado
   	andi t0,t0,0x0001		# mascara o bit menos significativo
   	beq t0,zero,LOOP		# n�o tem tecla pressionada ent�o volta ao loop
   	lw t2,4(t1)			# le o valor da tecla
  	sw t2,12(t1)  			# escreve a tecla pressionada no display

	
	
        # Desenha o fundo uma vez no in�cio
        la a0,fundo
        li a1,0
        li a2,0
        li a3,0         # Mapa sempre desenhado no framebuffer 0
        call PRINT
        li a3,1
        call PRINT

GAME_LOOP:
        call KEY2        
        xori s0,s0,1   

        la t0,CHAR_POS

        # Alternar frame apenas para o personagem
        
        la a0,felix
        lh a1,0(t0)
        lh a2,2(t0)
        mv a3,s0        # Alternar frame para o personagem
        call PRINT

        # Atualizar LED (opcional)
        li t0,0xFF200604
        sw s0,0(t0)
        
        la t0,OLD_CHAR_POS

        la a0,tile
        lh a1,0(t0)
        lh a2,2(t0)
        
        mv a3,s0
        xori a3,a3,1      
        call PRINT
        
        j GAME_LOOP

KEY2:   li t1,0xFF200000    # Carrega o endere�o de controle do KDMMIO
        lw t0,0(t1)         # L� bit de controle do teclado
        andi t0,t0,0x0001  # M�scara para o bit menos significativo
        beq t0,zero,FIM    # Se n�o h� tecla pressionada, pula para FIM
        lw t2,4(t1)         # L� o valor da tecla pressionada

        li t0,'w'
        beq t2,t0,WALK_UP
        
        li t0,'a'
        beq t2,t0,WALK_LEFT

        li t0,'s'
        beq t2,t0,WALK_DOWN

        li t0,'d'
        beq t2,t0,WALK_RIGHT

FIM:    ret

WALK_LEFT: 
    la t0,CHAR_POS
    la t1,OLD_CHAR_POS
    lw t2,0(t0)
    sw t2,0(t1)
    
    lh t1,0(t0)            # Carrega a posi��o X atual
    addi t1,t1,-16         # Move 16 pixels � esquerda
    bge t1,zero,OK_LEFT    # Verifica se est� dentro da borda esquerda (>= 0)
    li t1,0                # Se ultrapassar, for�a posi��o X = 0
OK_LEFT:
    sh t1,0(t0)            # Atualiza a posi��o X
    ret

WALK_RIGHT: 
    la t0,CHAR_POS
    la t1,OLD_CHAR_POS
    lw t2,0(t0)
    sw t2,0(t1)

    lh t1,0(t0)            # Carrega a posi��o X atual
    addi t1,t1,16          # Move 16 pixels � direita
    li t2,304              # Limite direito (320 - largura do personagem, 16px)
    blt t1,t2,OK_RIGHT     # Verifica se est� dentro da borda direita (< 304)
    li t1,304              # Se ultrapassar, for�a posi��o X = 304
OK_RIGHT:
    sh t1,0(t0)            # Atualiza a posi��o X
    ret

WALK_UP: 
    la t0,CHAR_POS
    la t1,OLD_CHAR_POS
    lw t2,0(t0)
    sw t2,0(t1)
    
    lh t1,2(t0)            # Carrega a posi��o Y atual
    addi t1,t1,-16         # Move 16 pixels para cima
    bge t1,zero,OK_UP      # Verifica se est� dentro da borda superior (>= 0)
    li t1,0                # Se ultrapassar, for�a posi��o Y = 0
OK_UP:
    sh t1,2(t0)            # Atualiza a posi��o Y
    ret

WALK_DOWN: 
    la t0,CHAR_POS
    la t1,OLD_CHAR_POS
    lw t2,0(t0)
    sw t2,0(t1)

    lh t1,2(t0)            # Carrega a posi��o Y atual
    addi t1,t1,16          # Move 16 pixels para baixo
    li t2,224              # Limite inferior (240 - altura do personagem, 16px)
    blt t1,t2,OK_DOWN      # Verifica se est� dentro da borda inferior (< 224)
    li t1,224              # Se ultrapassar, for�a posi��o Y = 224
OK_DOWN:
    sh t1,2(t0)            # Atualiza a posi��o Y
    ret


PRINT:
        li t0,0xFF0
        add t0,t0,a3       # Escolhe o framebuffer com base em a3
        slli t0,t0,20

        add t0,t0,a1       # Offset X

        li t1,320
        mul t1,t1,a2       # Offset Y
        add t0,t0,t1

        addi t1,a0,8       # Endere�o inicial dos dados da imagem

        mv t2,zero          # Contador de linha
        mv t3,zero          # Contador de coluna

        lw t4,0(a0)         # Largura da imagem
        lw t5,4(a0)         # Altura da imagem

PRINT_LINHA:
        lw t6,0(t1)         # L� pixel da imagem
        sw t6,0(t0)         # Escreve no framebuffer

        addi t0,t0,4       # Pr�ximo pixel no framebuffer
        addi t1,t1,4       # Pr�ximo pixel da imagem

        addi t3,t3,4       # Atualiza contador de coluna
        blt t3,t4,PRINT_LINHA

        addi t0,t0,320     # Pr�xima linha no framebuffer
        sub t0,t0,t4       # Ajusta para o in�cio da linha

        mv t3,zero          # Reseta contador de coluna
        addi t2,t2,1       # Incrementa contador de linha
        blt t2,t5,PRINT_LINHA
        ret

.data
.include "imagens/felix.data"
.include "imagens/fundo.data"
.include "imagens/tile.data"
.include "imagens/telainicial.data"
