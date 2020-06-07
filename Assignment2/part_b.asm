#Parm Johal
#V00787710
#CSC 350 Assignment 2
#part_b.asm

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


#
# Driver code.
#

	.text
	# Read in the first word...
	la $a0, MESSAGE_A
	li $v0, 4
	syscall
	la $a0, BUFFER_A
	li $a1, MAX_WORD_LEN
	li $v0, 8
	syscall

	# Read in the second word...
	la $a0, MESSAGE_B
	li $v0, 4
	syscall
	la $a0, BUFFER_B
	li $a1, MAX_WORD_LEN
	li $v0, 8
	syscall


	# Perform the swap
	la $a0, BUFFER_A
	la $a1, BUFFER_B
	li $a2, MAX_WORD_LEN
	jal FUNCTION_SWAP

	# Print string in BUFFER_A, BUFFER_B
	la $a0, BUFFER_A
	li $v0, 4
	syscall
	la $a0, NEW_LINE
	li $v0, 4
	syscall
	la $a0, BUFFER_B
	li $v0, 4
	syscall
	la $a0, NEW_LINE
	li $v0, 4
	syscall

	# Get outta here!
EXIT:
	li $v0, 10
	syscall


##########################################################
#
# YOUR SOLUTION MAY NOT ADD MORE GLOBAL DATA OR CONSTANTS.
# ALL OF THE CODE FOR YOUR FUNCTION(S) MUST APPEAR AFTER
# THIS POINT. SUBMISSIONS THAT IGNORE THIS REQUIREMENT
# MAY NOT BE ACCEPTED FOR EVALUATION.
#
##########################################################


#
# $a0 contains the address of the first string array
# $a1 contains the address of the second string array
# $a2 contains the maximum length of the arrays
#

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
