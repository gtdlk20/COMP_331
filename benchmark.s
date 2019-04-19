#Garrett Kaufmann and Shiv Khanna
#HW6 COMP331
#Krizanc
#
#f(12,8,1) = 12



.data

prompt:     .asciiz "\n Enter integer n > 0: \n"    #input prompt
commaSpace:  .asciiz ", \n"                         #separate returned items with a comma and space


.text

.globl main
.ent main



main:

    li $v0, 4               #prompt for fist input
    la $a0, prompt
    syscall
    li $v0, 5               #load data
    syscall
    nop

    bltz $v0, exit          #if n <= 0 then quit

    addi $s4, $v0, 1           #store n+1 in $s4 so that we can keep using $v0,
                               #compare equality of t0-2 against n+1
    add $t0, $zero, $zero      #counter variables for the loops

                                                #for each loop, we check equality of
                                                #$t0, $t1, $t2
                                                #
    loop0:
    add $t1, $zero, $zero
    add $t2, $zero, $zero                       #each time a counter variable changes we update that
    move $a0, $t0                               #value to $a0, $a1, $a2 respectively

        loop1:
        add $t2, $zero $zero
        move $a1, $t1

            loop2:
            move $a2, $t2

                jal bench                       #call bench(t0, t1, t2), list values
                                                # in order from f(0, 0, 0), ...,
                                                #f(0, 0, n) ..., f(0, n, n), ..., f(n, n, n)
                move $a0, $v0
                li $v0, 1
                syscall                         #Print v0 followed by ", "
                li $v0, 4                   
                la $a0, commaSpace
                syscall
                move $a0, $t0

            addi $t2, $t2, 1
            bne $t2, $s4, loop2
        addi $t1, $t1, 1
        bne $t1, $s4, loop1
    addi $t0, $t0, 1
    bne $t0, $s4, loop0
    beq $t0, $s4, exit


    exit:                   #terminate program
        li $v0, 10
        syscall

.end main

    bench:

        addi $sp, $sp, -28                #push $ra, $a0-$a2, $s0-$s2 onto stack
        sw $ra, 24($sp)
        sw $a0, 20($sp)
        sw $a1, 16($sp)
        sw $a1, 12($sp)
        sw $s0, 8($sp)
        sw $s1, 4($sp)
        sw $s2, 0($sp)

        sge $t3, $a1, $a0               #check base case
        beq $t3, $zero, fx

        move $v0, $a1                   #set $v0 = y
        addi $sp, $sp, 28               #pop stack
        jr $ra                          #return y


                                            #compute f(x-1, y, z), f(y-1, z, x),
                                            #f(z-1, x, y) and restore stack after
                                            #each iteration

        fx:
            addi $a0, $a0, -1
            jal bench
            lw $ra, 24($sp)
            lw $a0, 20($sp)
            lw $a1, 16($sp)
            lw $a1, 12($sp)
            lw $s0, 8($sp)
            lw $s1, 4($sp)
            lw $s2, 0($sp)
            addi $sp, $sp, 28
            move $s0, $v0                   #store f(x-1, y, z) in $s0
            jr $ra

        fy:
            move $t4, $a0                   #temp ($t4) = x ($a0)
            addi $a0, $a1, -1               #$x ($a0) = y-1  ($a1-1)
            move $a1, $a2                   #y ($a1) = z ($a2)
            move $a2, $t4                   #x ($a2) = temp ($a0)
            jal bench
            lw $ra, 24($sp)
            lw $a0, 20($sp)
            lw $a1, 16($sp)
            lw $a1, 12($sp)
            lw $s0, 8($sp)
            lw $s1, 4($sp)
            lw $s2, 0($sp)
            addi $sp, $sp, 28
            move $s1, $v0                   #store f(y-1, z, x) in $s1
            jr $ra

        fz:
            move $t4, $a0                   #temp = x
            addi $a0, $a2, -1               #x = z-1
            move $a2, $a1                   #z = y
            move $a1, $t4                   #y = temp
            jal bench
            lw $ra, 24($sp)
            lw $a0, 20($sp)
            lw $a1, 16($sp)
            lw $a1, 12($sp)
            lw $s0, 8($sp)
            lw $s1, 4($sp)
            lw $s2, 0($sp)
            addi $sp, $sp, 28
            move $s2, $v0                   #store f(z-1, x, y) in $s2
            jr $ra

        move $a0, $s0                       #pass values of f(x-1, y, z), f(y-1, z, x),
        move $a1, $s1                       #f(z-1, x, y) back to f
        move $a2, $s2
        jal bench


                                            #pop $ra, $a0-$a2, $s0-$s2 off stack
        lw $ra, 24($sp)
        lw $a0, 20($sp)
        lw $a1, 16($sp)
        lw $a1, 12($sp)
        lw $s0, 8($sp)
        lw $s1, 4($sp)
        lw $s2, 0($sp)
        addi $sp, $sp, 28
        jr $ra
.end bench
