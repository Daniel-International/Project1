# Descriptions: Project 1 for Computer Organization and Design (ECE 4680)
# Author: Michael Ulicny, Filip Jovanovski, Chris Donald
# Assembly Status: TODO
# Running Status: TODO
# Test results
# Run 1
#
#
#
# Run 2
#
#
#
# Run 3
#
#
#
# Run 4
#
#
#

#Initialization

.data

prompt1: .asciiz "Enter a positive integer: "
prompt2: .asciiz "Enter another positive integer: "
msgOut1: .asciiz "gcd("
msgOut2: .asciiz ","
msgOut3: .asciiz ") = "
msgDNE:  .asciiz "There exists no greatest common denominator\n"
msgError: .asciiz "Error: Positive nonzero integers are expected\n"

############################################################################
# 		Main: Prompts user for inputs and calls the GCD and printout
#           functions
############################################################################

.text
.globl Main

main:
    li  $v0, 4          # set syscall to print string
    la  $a0, prompt1    # set prompt1 to be printed
    syscall             # print "Enter a positive integer: "
    li  $v0, 5          # set syscall to read integer
    syscall             # read user input to $v0
    move $a1, $v0       # store input in memory (argument0)
    li  $v0, 4          # set syscall to print string
    la  $a0, prompt2    # set prompt2 to be printed
    syscall             # print "Enter another positive integer: "
    li  $v0, 5          # set syscall to read integer
    syscall             # read user input to $v0
    move $a2, $v0       # store input in memory
    jal gcd             # call gcd function
    move $a3,$v0        # move result to $s1
    beq $a3,0,main      # if error occurred re-prompt user
    jal printout        # call the printout function
    j main              # return to begenning of program
    li  $v0, 10         # exit()
    syscall             


################################################################
# GCD Function: find the greatest common denominator of the 
#   user inputs
# Arguments: a1 is the first user input (var x)
#            a2 is the second user input (var y)
# Errors: if either input is less than or equal to zero
# Results: the least common denominator of 'x' and 'y'
################################################################

.text
.globl gcd

gcd:
        ble $a1,$zero,Error     # if x <= 0 return false
        ble $a2,$zero,Error     # if y <= 0 return false
        bne $a1,a2,b1           # if x == y return x
        move $v0,$a1            # set $v0 to x and return
        jr  $ra
b1:     bgt $a2,$a1,b2          # else if x > y
        move $t0,$a2            # i = y;
L1:     addi $t0,$t0,-1         # i--; (decrease iter)
# Perform modulator 
# if (x%i && y%i) {return i}
        div $a1, $t0            # divide x by i
        mfhi $s0                # x % i = $s0
        sw $s0, 0($sp)          #remainder being saved
        bne $s0, $zero, L2      #if $s0 != 0, then recurse
        
        div $a2, $t0            #divide y by i
        mfhi $s1                #y % i = $s1
        sw $s1, 0($sp)          #remainder being saved
        bne $s0, $zero, L2      #if $s1 != 0, then recurse
        
        beq $s0, $s1, $zero     #if $s0 and $s1 == 0
        sw $v0, $t0             #i is being stored into $v0
        jr $ra                  #return
L2:
        add $a1, $a2, $zero     #set x and y equal to zero
        lw $s0, 0($sp)          #loading the remainder
        add $a2, $s0, $zero     #set y to the remainder
        jal gcd

#                               # else (if y > x by process of elim)
b2:     move $t0,$a1            # i = x;
# Perform modulator
# if (x%i && y%i) {return i}
#
# we return i by moving it into $v0 and performaing a jr $ra instruction.
# the main funciton will handle the rest




Error:  li  $v0, 4          # set syscall to print string
        la  $a0, msgError   # set msgError to be printed
        syscall             # print "Error: Positive nonzero 
                            #   integers are expected\n"
        li  $v0, 0          # set v0 to "false"
        jr  $ra



################################################################
# Printout Function: Prints the greatest common denominator
# Arguments: a1 first user input
#            a2 second user input
#            a3 is gcd returned from gcd function
# Results: output showing "gcd(x,y) = val "
################################################################

.text
.globl printout

printout:
        li  $v0, 4      # set syscall to print string
        la  $a0, msgOut1 # set msgOut1 to be printed
        syscall         # print "gcd("
        li  $v0, 1      # set syscall to print int
        move $a0,$a1    # set first input to be printed
        syscall         # print first input x
        li  $v0, 4      # set syscall to print string
        la  $a0, msgOut2 # set msgOut2 to be printed
        syscall         # print comma ","
        li  $v0, 1      # set syscall to print int
        move $a0,$a2    # set second input to be printed
        syscall         # print second input y
        li  $v0, 4      # set syscall to print string
        la  $a0, msgOut3 # set msgOut3 to be printed
        syscall         # print ") = "
        li  $v0, 1      # set syscall to print int
        move $a0,$a3    # set gcd integer to be printed
        syscall         # print gcd
        jr  $ra

        
