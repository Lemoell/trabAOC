#Lemoel da Silva Costa
#trab foi sobre o sorteador para simular o globo do bingo(numeros de 1 a 25 sem repetir valores)
#caso o usuario desejar finalizar, o espaço restante do vetor sera preenchido com "0"
#porem nao ira imprimir os "zeros" que completaram o vetor
.data
    vetor: .space 100
    msg1: .asciiz "Deseja gerar um número?(qualquer para sim, 0 para sair): "
    msg2: .asciiz "\nObrigado por jogar!\n"
    msg3: .asciiz "Começar jogo?(qualquer para jogar, 0 para sair):"
    msg4: .asciiz "\nNúmeros sorteados na partida:\n"
    linha: .asciiz "\n" 

.text
main:
#carrega o ed do vetor
la $t5, vetor 

#usar como base para o loop
li $t0, 25
  
#contador 
li $t1, 0 
    
#perguntar se quer começar o sorteador
la $a0, msg3
li $v0, 4
syscall
    
#verificar se é 0 para sair ou continuar
li $v0, 5
syscall
beqz $v0, fim
gerar_num:
#perguntar ao usuario se deseja gerar um numero
li $v0, 4 
la $a0, msg1
syscall

#ler a resposta do usuário e verifica se quer finalizar
li $v0, 5  
syscall 
move $t2, $v0  
beqz $t2, finalizar 

#gerar um numero aleatorio
gerar_novo_num:
#gerar um numero aleatorio
li $v0, 42 
li $a1, 25
syscall 
addi $t3, $a0, 1 

#verificar se o numero ja foi sorteado
la $t6, vetor 
li $t4, 0  

verificar_repeticao:
bge $t4, $t1, armazenar_num #$t3 >= $t1, pula
lw $t7, 0($t6)         
beq $t7, $t3, gerar_novo_num 
addi $t6, $t6, 4 
addi $t4, $t4, 1 
j verificar_repeticao   

armazenar_num:
#armazenar o numero no vetor
sw $t3, 0($t5)
addi $t5, $t5, 4 

#imprimir o número gerado
move $a0, $t3 
li $v0, 1 
syscall 

#imprimir nova linha
li $v0, 4  
la $a0, linha 
syscall

#incrementar contador
addi $t1, $t1, 1            

#verificar se ja gerou 20 números
blt $t1, $t0, gerar_num  #$t1 < $t0, pula

#finalizar o programa
finalizar:
jal imprimir

#imprimir msg
li $v0, 4  
la $a0, msg2 
syscall 

#finalizar o programa
fim:
li $v0, 10
syscall
    

#subrotina
imprimir:

#imprimir msg 
li $v0, 4
la $a0, msg4
syscall

#carrega o end do vetor
la $t5, vetor
#reinicializa o contador 
li $t1, 0  

imprimir_loop:
bge $t1, 25, exit  #$t2 <= 25, pula

#carregar o número do vetor
lw $a0, 0($t5)   

#verificar se é 0, se for nao ira imprimir 
beqz $a0, zero

#imprimir o número
li $v0, 1  
syscall

#imprimir nova linha
li $v0, 4 
la $a0, linha 
syscall  
zero:
#incrementar o contador e apontar para prox posiçao
addi $t1, $t1, 1  
addi $t5, $t5, 4  

j imprimir_loop   
exit:
jr $ra
