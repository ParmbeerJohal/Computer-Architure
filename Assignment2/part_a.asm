#Parm Johal
#V00787710
#CSC 350 Assignment 2
#part_a.asm

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

START:
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

	la $a0, BUFFER_A
	la $a1, BUFFER_B
	jal FUNCTION_STRCMP

	add $a0, $zero, $v0
	li $v0, 1
	syscall

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
# Solution for FUNCTION_STRCMP must appear below.
#
# $a0 contains the address of the first string
# $a1 contains the address of the second string
# $v0 will contain the result of the function.
#

FUNCTION_STRCMP:

#	while contents of p1 not equal to null:
#        if contents of p2 equal to null:
#            return 1
#
#        if contents of p2 greater than contents of p1:
#            return -1
#
#        if contents of p1 greater than contents of p2:
#            return 1
#
#        advance p1
#        advance p2
#
#    if contents of p2 not equal to null:
#        return -1
#
#    return 0

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
