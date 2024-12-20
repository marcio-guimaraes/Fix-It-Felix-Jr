.data
# Numero de Notas a tocar
NUM: .word 112
# lista de nota,dura��o,nota,dura��o,nota,dura��o,...
NOTAS: 60,125,60,125,72,125,60,125,67,125,60,250,66,125,60,125,65,125,60,125,64,250,60,125,64,125,65,125,59,125,59,125,72,125,60,125,67,125,60,250,66,125,60,125,65,125,60,125,64,250,60,125,64,125,65,125,58,125,58,125,72,125,60,125,67,125,60,250,66,125,60,125,65,125,60,125,64,250,60,125,64,125,65,125,57,125,57,125,72,125,60,125,67,125,60,250,66,125,60,125,65,125,60,125,64,250,60,125,64,125,65,125,60,125,60,125,72,125,60,125,67,125,60,250,66,125,60,125,65,125,60,125,64,250,60,125,64,125,65,125,59,125,59,125,72,125,60,125,67,125,60,250,66,125,60,125,65,125,60,125,64,250,60,125,64,125,65,125,58,125,58,125,72,125,60,125,67,125,60,250,66,125,60,125,65,125,60,125,64,250,60,125,64,125,65,125

.text

# Fun��o PLAYMUSIC
PLAYMUSIC:
    la s0,NUM             # define o endere�o do n�mero de notas
    lw s1,0(s0)           # le o numero de notas
    la s0,NOTAS           # define o endere�o das notas
    li t0, 0              # zera o contador de notas
    li a2, 81             # define o instrumento
    li a3,127             # define o volume

LOOP:  
    beq t0,s1, FIM        # contador chegou no final? ent�o  v� para FIM
    lw a0, 0(s0)          # le o valor da nota
    lw a1, 4(s0)          # le a dura��o da nota
    li a7, 31             # define a chamada de syscall
    ecall                 # toca a nota
    mv a0,a1              # passa a dura��o da nota para a pausa
    li a7,32              # define a chamada de syscall 
    ecall                 # realiza uma pausa de a0 ms
    addi s0,s0,8          # incrementa para o endere�o da pr�xima nota
    addi t0,t0,1          # incrementa o contador de notas
    j LOOP                # volta ao loop

FIM:    
    li a0,40              # define a nota
    li a1,1500            # define a dura��o da nota em ms
    li a2,127             # define o instrumento
    li a3,127             # define o volume
    li a7,33              # define o syscall
    ecall                 # toca a nota

    li a7,10              # define o syscall Exit
    ecall                 # exit
