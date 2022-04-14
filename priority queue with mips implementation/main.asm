.data
unorderedList: .word 13, 26, 44, 8, 16, 37, 23, 67, 90, 87, 29, 41, 14, 74, 39, -1

array: .space 110 

insertValues: .word 46, 85, 24, 25, 3, 33, 45, 52, 62, 17

space: .asciiz " "
newLine: .asciiz "\n"

dash: .asciiz "----------------------------------------------------------------------------------------------"


####################################
#   4 Bytes - Value
#   4 Bytes - Address of Left Node
#   4 Bytes - Address of Right Node
#   4 Bytes - Address of Root Node
####################################

.text 
main:

la $a0, unorderedList


jal build
move $s3, $v0

move $a0, $s3
jal print

li $s0, 8
li $s2, 0
la $s1, insertValues
insertLoopMain: 
beq $s2, $s0, insertLoopMainDone

lw $a0, ($s1)
move $a1, $s3
jal insert

addi $s1, $s1, 4
addi $s2, $s2, 1 
b insertLoopMain
insertLoopMainDone:

move $a0, $s3
jal print


move $a0, $s3
#jal remove


move $a0, $s3
jal print


li $v0, 10
syscall 


########################################################################
# Write your code after this line
########################################################################


####################################
# Build Procedure
####################################
build:
addi $sp, $sp, -40
sw $a0, 0($sp)			# a0 = list adress to the stack
sw $ra, 4($sp)
sw $s0, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)				
sw $s3, 20($sp)
sw $s4, 24($sp)
sw $s5, 28($sp)
sw $s6, 32($sp)
sw $s7, 36($sp)


move $s0,$a0			# s0 = list address
lw $s1, 0($s0)			# s1 = first value from unordered list

la $t9,array 			# s2 = array address   

li $v0, 9
li $a0, 16				# first node
syscall

sw $v0, 0($t9)			# storing nodes into an array. To determine array end, it puts zero at the end of array 
sw $zero, 4($t9)		# and next slide this zero always to the end
addi $t9, $t9, 4

li $t0, 0  				# counter

move $s5,$v0			# s5 = root adress

sw $v0, 8($sp)

sw $s1, 0($v0)			# value assign
sw $zero, 12($v0)		# parent node = 0 (first node)

li $s4, -1				# end of list
buildLoop:
addi $s0, $s0, 4 		# next value adress
lw $s1, 0($s0)			# next value from list

beq $s1, $s4, buildLoopDone  # if end of list, done



move $a0,$s1			# parameters for insert $a0 = value
move $a1,$s5			# $a1 = root node

jal insert

j buildLoop

buildLoopDone:

lw $s7, 36($sp)
lw $s5, 32($sp)
lw $s4, 28($sp)				# loading previous values of registers from stack
lw $s3, 24($sp)
lw $s2, 20($sp)
lw $s1, 16($sp)
lw $s0, 12($sp)
lw $v0, 8($sp)			# build returns root address to the $v0
lw $ra, 4($sp)
addi $sp, $sp, 40
jr $ra

####################################
# Insert Procedure
####################################

insert:
addi $sp, $sp, -32
sw $ra, 0($sp)			# storing register values that will use later to the stack
sw $s0, 4($sp)
sw $s1, 8($sp)
sw $s2, 12($sp)				
sw $s3, 16($sp)
sw $s4, 20($sp)
sw $s5, 24($sp)
sw $s7, 28($sp)

move $s0,$a0		# s0 = value
move $s1,$a1		# s1 = root address

li $v0, 9
li $a0, 16 			# create new node
syscall

sw $v0, 0($t9)
sw $zero, 4($t9)
addi $t9, $t9, 4

addi $t0, $t0, 16	# increase counter


parent:
	move $t7,$t0		# calcualtes parent node with index at [(i-1)/2]
	srl $t7, $t7, 4
	addi $t7, $t7, -1

	srl $t7, $t7, 1
	sll $t7, $t7, 4

	add $s7, $t7, $s1	# adding base adress + index

	sw $s7, 12($v0)

	sw $s0, 0($v0)		# assigning value

left:

	move $t1, $t0
	
	li $s6, 32			# determines left or right child w.r.t remainder. If zero then then its right
	div $t1, $s6
	mfhi $s6

	beq $s6, $zero, right

	sw $v0, 4($s7)				# storing which child of the parent

	move $a2,$v0		# current node adress
	move $a3,$s0		# current value
	move $a0,$t0		# counter


	jal heapify

	j leftdone

right:

	sw $v0, 8($s7)

	move $a2,$v0		# current node adress
	move $a3,$s0		# current value
	move $a0,$t0		# counter

	jal heapify
	
	j rightdone

leftdone:
rightdone:

lw $s7, 28($sp)
lw $s5, 24($sp)
lw $s4, 20($sp)				# loading previous values of registers from stack
lw $s3, 16($sp)
lw $s2, 12($sp)
lw $s1, 8($sp)
lw $s0, 4($sp)
lw $ra, 0($sp)
addi $sp, $sp, 32
jr $ra

####################################
# Remove Procedure
####################################
remove:

addi $sp, $sp, -52
sw $ra, 0($sp)
sw $s0, 4($sp)				# storing previous values of registers to the stack
sw $s1, 8($sp)
sw $s2, 12($sp)
sw $s3, 16($sp)
sw $s4, 20($sp)
sw $s5, 24($sp)
sw $s6, 28($sp)
sw $s7, 32($sp)
sw $t0, 36($sp)
sw $t1, 40($sp)
sw $t2, 44($sp)
sw $t3, 48($sp)


move $s0,$a0			

la $s1,array
findLastElement:

	lw $s2, 0($s1)
	move $s4,$s1							# last element adreess (array) in $s4
	move $s3,$s2							# store last element address in $s3
	addi $s1, $s1, 4
	bne $s2, $zero, findLastElement			# it loops till reach the end 

	
lw $t0, 0($s3)					# last element value = t0
la $s1,array
lw $t1, 0($s1)					# root node address = t1
lw $t2, 0($t1)					# root node value   = t2

move $v0,$t2					# moving removed elemnt to the v0

sw $t0, 0($t1)					# setting new value to the root node

sw $zero, 0($s4)				# set zero to the removed element (in array)

sw $zero, 0($s3)				# set zero to the removed element (structure)

move $a0,$t1	# root adress parameter

lw $t3, 4($t1)
lw $s5, 8($t1)

move $a1,$t3	# left child address
move $a2,$s5	# right child address

jal removeHeapify


lw $t3, 48($sp)
lw $t2, 44($sp)
lw $t1, 40($sp)
lw $t0, 36($sp)
lw $s7, 32($sp)
lw $s6, 28($sp)
lw $s5, 24($sp)
lw $s4, 20($sp)
lw $s3, 16($sp)				# loading previous values of registers from the stack
lw $s2, 12($sp)
lw $s1, 8($sp)
lw $s0, 4($sp)
lw $ra, 0($sp)
addi $sp, $sp, 52

jr $ra

####################################
# Print Procedure
####################################
print:
addi $sp, $sp, -28
sw $ra, 0($sp)			# storing register values that will use later to the stack
sw $s1, 4($sp)
sw $s2, 8($sp)		
sw $s3, 12($sp)
sw $s4, 16($sp)
sw $s5, 20($sp)
sw $s6, 24($sp)


move $s2,$a0 			# root address to the $s2

la $s1, array
la $s5, space
la $s6, newLine
	printBFT:

		lw $s3, 0($s1)		# node address
		
		beq $zero, $s3, exitBFT

		lw $s4, 0($s3)		# value


		li $v0 ,1
		move $a0,$s4		# print value
		syscall

		li $v0 ,4
		move $a0,$s5		# print sapce
		syscall

		addi $s1, $s1, 4 	# increase address of array for reach next node base address

		j printBFT

	exitBFT:


la $s5, dash

li $v0,4
move $a0,$s6			# print new line
syscall

li $v0,4
move $a0,$s5			# print dashes
syscall


li $v0,4
move $a0,$s6			# print new line
syscall



move $a0,$s2			# restore previous a0 value 
	
lw $s6, 24($sp)
lw $s5, 20($sp)
lw $s4, 16($sp)			# loading back previous register values from stack
lw $s3, 12($sp)
lw $s2, 8($sp)
lw $s1, 4($sp)
lw $ra, 0($sp)
addi $sp, $sp, 28
jr $ra

####################################
# Extra Procedures
####################################
extraProcedures:





heapify:
addi $sp, $sp, -4		# storing values to the stack
sw $ra, 0($sp)

	innerLoop:
	lw $t6, 12($a2)
	beq $zero, $t6, innerloopDone			# if parent value = zero than we re at the root node, exit loop
	move $t3,$a0 							# counter in t3

	srl $a0, $a0, 4
	addi $a0, $a0, -1		# parent index with [(i-1)/2]
	srl $a0, $a0, 1
	sll $a0, $a0, 4  	

	move $t4,$a0			# parent index

	add $a0, $a0, $a1 		# parent adress

	move $t5,$a0

	lw $t2, 0($a0)			# t2 = parent value


	bgt $a3,$t2,swap  		# if current value > parent value than goto swap

		swapDone:	

		move $a0,$t4			# swapping current and parent node values
		move $a2,$t5

		j innerLoop


	innerloopDone:
lw $ra, 0($sp)
addi $sp, $sp, 4  			# loading back values to the register from stack
jr $ra
# END OF HEAPIFY


# swap Label

swap:

sw $a3, 0($a0)			# this label swaps the values for heapify
sw $t2, 0($a2)

j swapDone



removeHeapify:

addi $sp, $sp, -36
sw $ra, 0($sp)			# storing register values that will use later to the stack
sw $s1, 4($sp)
sw $s2, 8($sp)		
sw $s3, 12($sp)
sw $s4, 16($sp)
sw $s5, 20($sp)
sw $a0, 24($sp)
sw $a1, 28($sp)
sw $a2, 32($sp)

startprocess:

lw $s1, 0($a0)			# root value

lw $s2, 0($a1)			# left value

lw $s3, 0($a2)			# right value


bgt $s2,$s3,leftchild	# id s2>s3 then go left else right

j rightchild

leftchild:

move $s5,$s2		# if left child selected

move $t8,$a1

rightchild:

move $s5,$s3		# if right child selected
move $t8,$a2

bgt $s5,$s1,swapRemove

j exitSwapRemove
	swapRemove:

		sw $s5, 0($a0)		# if child value > parent then swap
		sw $s1, 0($t2)

move $a0,$t2
lw $a1, 4($t2)
lw $a2, 8($t2)

j startprocess

exitSwapRemove:

lw $a2, 32($sp)
lw $a1, 28($sp)
lw $a0, 24($sp)
lw $s5, 20($sp)
lw $s4, 16($sp)			# loading back previous register values from stack
lw $s3, 12($sp)
lw $s2, 8($sp)
lw $s1, 4($sp)
lw $ra, 0($sp)
addi $sp, $sp, 36

jr $ra