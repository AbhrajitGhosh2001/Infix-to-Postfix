.data
	infix: .space 256
	postfix: .space 256
	prefix: .space 256
	stack: .space 256
	beginMsg: .asciiz "Enter infix expression\nonly allowed to use + - ()\nNumber from 0-9 \nAlso must be closed under()\n"
	infixExpression: .asciiz "Infix expression: "
	postfixExpression: .asciiz "Postfix expression: "
	prefixExpression: .asciiz "Prefix expression: "
	result:  .asciiz "\nEvaluation: "
.globl main 
	.text 
	
main:
################################################################ input
begin:

# Get the infix expression

	#InputDialogString
	
	#print beginning
	li $v0, 4
	#$a0 = string
	la $a0, beginMsg
	syscall
	
	li $v0, 8
	#$a0 = buffer
	la $a0, infix
	#$a1 = maximum number of characters to read
 	la $a1, 256
 	syscall
	
######################################################################	

# Print infix 
	# print string
	li $v0, 4
	#$a0 = address of null-terminated string to print
	la $a0, infixExpression
	syscall
	
	# print string
	li $v0, 4
	# print infix
	la $a0, infix
	syscall
	
	#print character for a newline
	li $v0, 11
	li $a0, '\n'
	syscall

######################################################################	
	
	la $t1, infix		
	li $s0,0 #$s0 = length
	findlength:
	lb $t2,($t1)
	addi $t1,$t1,1
	addi $s0,$s0,1
	bne $t2, 0, findlength
	
	addi $s0, -2 #because offset by 2 more actual is 2 less
######################################################################		
	
	li $t5,-1		# Postfix top offset
	la $t2, postfix
	la $t1, infix
	addi $t1,$t1,-1	#Set initial address of infix to -1 because we add one at start of scan
	li,$s1,0 #counter
	
	addi $sp,$sp,1
	
	scanInfix:
	addi $s1,$s1,1	
	addi $t1,$t1,1
	lb $t4,($t1)
	#checks
	beq $t4,'0',number
	beq $t4,'1',number
	beq $t4,'2',number
	beq $t4,'3',number
	beq $t4,'4',number
	beq $t4,'5',number
	beq $t4,'6',number
	beq $t4,'7',number
	beq $t4,'8',number
	beq $t4,'9',number
	beq $t4, '+', addsub
	beq $t4, '-', addsub
	beq $t4, '(', openp
	beq $t4, ')', closep
	
	go:
	bne $s1,$s0,scanInfix
	######################################################################
# Print postfixfix 
	# print string
	li $v0, 4
	#$a0 = address of null-terminated string to print
	la $a0, postfixExpression
	syscall
	
	# print string
	li $v0, 4
	# print postfix
	la $a0, postfix
	syscall
	
	#print character for a newline
	li $v0, 11
	li $a0, '\n'
	syscall
	
	######################################################################
	#finding length of postfix
	
	li $s0,0 #$s0 = length
	la $t2, postfix
	polenfth:
	lb $t1,($t2)
	addi $t2,$t2,1
	addi $s0,$s0,1
	bne $t1, 0, polenfth
	
	addi $s0, -1 #because offset by 1 more actual is 1 less
	li,$s1,0 #counter
	
	
######################################################################
#reset postfix
	la $t2, postfix
	
	addi $sp,$sp,1
	addi $t2,$t2,-1	#Set initial address of infix to -1 because we add one at start of evaluation
	
	
	evaluation:
	addi $s1,$s1,1
	addi $t2,$t2,1
	lb $t4,($t2)
	
	
	#print character for a newline
	li $v0, 11
	move $a0, $t4
	syscall
	
	
	
	beq $t4,'0',operand
	beq $t4,'1',operand
	beq $t4,'2',operand
	beq $t4,'3',operand
	beq $t4,'4',operand
	beq $t4,'5',operand
	beq $t4,'6',operand
	beq $t4,'7',operand
	beq $t4,'8',operand
	beq $t4,'9',operand
	beq $t4, '+', adding
	beq $t4, '-', subtract
	goe:
	
	bne $s1,$s0,evaluation
	
	
	
	
# Print result 
	# print string
	li $v0, 4
	#$a0 = address of null-terminated string to print
	la $a0, result
	syscall
	
	# print string
	li $v0, 1
	# print actual number
	move $a0, $s4
	syscall
	
	#print character for a newline
	li $v0, 11
	li $a0, '\n'
	syscall

	
	
# Exit program
	exit:
 	li $v0, 10
 	syscall
	
	######################################################################
	
	openp:
	sub $sp,$sp,1
	sb $t4,0($sp)
	j go
	
	closep:
	loopy:
	lb $t4, 0($sp)
	beq $t4, '-', append
	beq $t4, '+', append
	beq $t4, '(',notloopy
	notloopy:
	addi $sp,$sp,1

	j go
	
	addsub:
	sub $sp,$sp,1	
	sb $t4,0($sp)
	j go
	
	number:
	addi $t5,$t5,1
	add $t8,$t5,$t2			
	sb $t4,($t8)
	j go
	
	append:
	addi $t5,$t5,1
	add $t8,$t5,$t2			
	sb $t4,($t8)
	addi $sp,$sp,1
	j loopy
	
	
	
	######################################################################
	adding:
	lb $s4,0($sp)
	addi $sp,$sp,1
	lb $s5,0($sp)
	add $s4,$s4,$s5
	sb $s4,0($sp)
	
	j goe
	
	
	subtract:
	lb $s4,($sp)
	addi $sp,$sp,1
	lb $s5,($sp)
	sub $s4,$s5,$s4
	sb $s4,0($sp)
	j goe
	
	operand:
	addi $t4,-48
	sub $sp,$sp,1
	sb $t4,0($sp)
	j goe
	
	