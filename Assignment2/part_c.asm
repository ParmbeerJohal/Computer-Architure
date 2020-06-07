#Parm Johal
#V00787710
#CSC 350 Assignment 2
#part_c.asm

# Constants, strings, to be used in all part of the
# CSC 350 (Spring 2019) A#2 submissions

# These are similar to #define statements in a C program.
# However, the .eqv directions *cannot* include arithmetic.

.eqv  MAX_WORD_LEN 32
.eqv  MAX_WORD_LEN_SHIFT 5
.eqv  MAX_NUM_WORDS 100
.eqv  WORD_ARRAY_SIZE 3200  # MAX_WORD_LEN * MAX_NUM_WORDS
.eqv NEW_LINE_ASCII 10


# Global data

.data
WORD_ARRAY: 	.space WORD_ARRAY_SIZE
NUM_WORDS: 	.space 4
MESSAGE1:	.asciiz "Number of words in string array: "
MESSAGE2:	.asciiz "Contents of string arrayr:\n"
MESSAGE3:	.asciiz "Enter strings (blank string indicates end):\n"
SPACE:		.asciiz " "
NEW_LINE:	.asciiz "\n"
EMPTY_LINE:	.asciiz ""

# For strcmp testing...
MESSAGE_A:	.asciiz "Enter first word: "
MESSAGE_B:	.asciiz "Enter second word: "
BUFFER_A:	.space MAX_WORD_LEN
BUFFER_B:	.space MAX_WORD_LEN

	.text
#####
#####
INIT:
	# Save $s0, $s1 and $s2 on stack.
	addi $t0, $sp, 12
	sub $sp, $sp, $t0
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)


	la $a0, MESSAGE3
	li $v0, 4
	syscall

	# Initialize NUM_WORDS to zero.
	#
	# Load start of word array into $s0; we'll directly read
	# input words into this array/buffer.
	la $t0, NUM_WORDS
	sw $zero, 0($t0)
	la $s0, WORD_ARRAY

READ_WORD:
	add $a0, $s0, $zero
	li $a1, MAX_WORD_LEN
	li $v0, 8
	syscall

	# Empty string? If so, finish. An emtpy string
	# consists of the single newline character.
	lbu $t0, 0($s0)
	li $t1, NEW_LINE_ASCII
	beq $t0, $t1, CALL_QUICKSORT

	# Increment # of words; at the maximum??
	la $t0, NUM_WORDS
	lw $t1, 0($t0)
	addi $t1, $t1, 1
	sw $t1, 0($t0)
	addi $t2, $zero, MAX_NUM_WORDS
	beq $t1, $t2, CALL_QUICKSORT

	# Otherwise proceed to the next work
	addi $s0, $s0, MAX_WORD_LEN
	j READ_WORD



CALL_QUICKSORT:
	# Before call to quicksort
	jal FUNCTION_PRINT_WORDS

	# Assemble arguments
	la $a0, WORD_ARRAY
	li $a1, 0
	la $t0, NUM_WORDS
	lw $a2, 0($t0)
	addi $a2, $a2, -1
	jal FUNCTION_HOARE_QUICKSORT

	# Restore from stack the callee-save registers used in this code
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	addi $sp, $sp, 12

	# After call to quicksort
	jal FUNCTION_PRINT_WORDS

EXiT:
	li $v0, 10
	syscall



#####
#####
FUNCTION_PRINT_WORDS:
	la $a0, MESSAGE1
	li $v0, 4
	syscall

	la $t0, NUM_WORDS
	lw $a0, 0($t0)
	li $v0, 1
	syscall

	la $a0, NEW_LINE
	li $v0, 4
	syscall

	la $a0, MESSAGE2
	li $v0, 4
	syscall

	li $t0, 0
	la $t1, WORD_ARRAY
	la $t2, NUM_WORDS
	lw $t2, 0($t2)

LOOP_FPW:
	beq $t0, $t2, EXIT_FPW
	add $a0, $t1, $zero
	li $v0, 4
	syscall
	addi $t0, $t0, 1
	addi $t1, $t1, MAX_WORD_LEN
	j LOOP_FPW

EXIT_FPW:
	jr $ra




##########################################################
#
# YOUR SOLUTION MAY NOT ADD MORE GLOBAL DATA OR CONSTANTS.
# ALL OF THE CODE FOR YOUR FUNCTION(S) MUST APPEAR AFTER
# THIS POINT. SUBMISSIONS THAT IGNORE THIS REQUIREMENT
# MAY NOT BE ACCEPTED FOR EVALUATION.
#
##########################################################


#
# $a0 contains the starting address of the array of strings,
#    where each string occupies up to MAX_WORD_LEN chars.
# $a1 contains the starting index for the partition
# $a2 contains the ending index for the partition
# $v0 contains the index that is to be returned by the
#    partition algorithm
#

FUNCTION_PARTITION:
    jal FUNCTION_SWAP
    jr $ra


#
# $a0 contains the starting address of the array of strings,
#    where each string occupies up to MAX_WORD_LEN chars.
# $a1 contains the starting index for the quicksort
# $a2 contains the ending index for the quicksort
#
# THIS FUNCTION MUST BE WRITTEN IN A RECURSIVE STYLE.
#

FUNCTION_HOARE_QUICKSORT:
    jal FUNCTION_STRCMP
    jr $ra


FUNCTION_STRCMP:
	lb $t0, 0($a0)
	lb $t1, 0($a1)
	bne $t0, $t1, NOT_EQUAL
	#At this point, the first letter of each message is equal

	bne $t0, $zero, CONTINUE
	#At this point both messages are the same
	move $v0, $zero
	jr $ra

CONTINUE:
	addi $a0, $a0, 1
	addi $a1, $a1, 1
	j FUNCTION_STRCMP

NOT_EQUAL:
	#sub $v0, $t0, $t1
	#sub $t2, $t0, $t1
	bgt $t0, $t1, RETURN_POS
	#blt $t0, $t1, RETURN_NEG
	li $v0, -1
	jr $ra

RETURN_POS:
	li $v0, 1
	jr $ra

FUNCTION_SWAP:
# The function receives the starting address of each string.
# It copies the characters corresponding to the first string into a temporary area.
# It then copies the characters corresponding to the second string into the memory of the first string.
# Finally it copies the characters in the temporary area into the second string.
	#Setting up the stack pointer
	addi $sp, $sp, -12

	sw $s0, 8($sp)
	sw $s1, 4($sp)
	sw $s2, 0($sp)
	add $s0, $zero, $zero #pointer for the first array
	add $s1, $zero, $zero #pointer for the second array
	add $s2, $zero, $zero #pointer for the max length array

#MESSAGE 1 INTO MAX_WORD_LENGTH
FIRST_SWAP:
	add $t1, $s0, $a0 #address of BUFFER_A[i] in $t1
	lbu $t2, 0($t1) #$t2 = BUFFER_A[i]

	add $t3, $s0, $a2 #address of MAX_WORD_LENGTH[i] in $t3
	sb $t2, 0($t3) #MAX_WORD_LENGTH[i] = BUFFER_A[i]
	beq $t2, $zero, SECOND_SWAP #null terminator found
	addi $s0, $s0, 1 #i = i + 1
	j FIRST_SWAP

#MESSAGE 2 INTO MESSAGE 1
SECOND_SWAP:
	add $t1, $s1, $a1 #address of BUFFER_B[i] in $t1
	lbu $t2, 0($t1) #$t2 = BUFFER_B[i]

	add $t3, $s1, $a0 #address of BUFFER_A[i] in $t3
	sb $t2, 0($t3) #BUFER_A[i] = BUFFER_B[i]
	beq $t2, $zero, FINAL_SWAP #null terminator found
	addi $s1, $s1, 1 #i = i + 1
	j SECOND_SWAP

#MESSAGE 1 FROM MAX_WORD_LENGTH INTO MESSAGE 2
FINAL_SWAP:
	add $t1, $s2, $a2 #address of MAX_WORD_LENGTH[i] in $t1
	lbu $t2, 0($t1) #$t2 = MAX_WORD_LENGTH[i]

	add $t3, $s2, $a1 #address of BUFFER_B[i] in $t3
	sb $t2, 0($t3) #BUFER_B[i] = MAX_WORD_LENGTH[i]
	beq $t2, $zero, END_SWAP #null terminator found
	addi $s2, $s2, 1 #i = i + 1
	j FINAL_SWAP

END_SWAP:
	lw $s2, 0($sp)
	lw $s1, 4($sp)
	lw $s0, 8($s0)
	addi $sp, $sp, 12

	jr $ra
