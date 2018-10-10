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
        move $t0,$a2            # (i = y;
L1:     addi $t0,$t0,-1         # i--;
        blt  $t0,$zero,Return   # 



b2:                             # else (if y > x by process of elim)




Error:  li  $v0, 4          # set syscall to print string
        la  $a0, msgError   # set msgError to be printed
        syscall             # print "Error: Positive nonzero 
                            #   integers are expected\n"
        li  $v0, 0          # set v0 to "false"
        jr  $ra

Return: li  $v0, 4          # set syscall to print string
        la  $a0, msgDNE     # set msgDNE to be printed
        syscall             # print "There exists no gcd"
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

        