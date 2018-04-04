#Adam Paz, apa10@ucsc.edu
#Section 2, mon/wed 11-1
#partner = Anthony Awaida, aawaida@ucsc.edu
.text
.global main
.global milliseconds
.set noreorder
.ent main
/*LED5 = RF0*/
main:
    la $t0, TRISE
    li $t1, 0xFF
    sw $t1, 4($t0)

    la $t0, TRISD
    li $t1, 0xE0
    sw $t1, 8($t0)
    
    la $t0, TRISF
    li $t1, 0
    sw $t1, 0($t0)
    
    la $t0, PORTE
    li $t1, 0
    #sw $t1, 0($t0)
   
loop:
    la $t1, PORTD #load address of portd
    lw $t0, 0($t1) #set t0 to portd
    li $t2, 0xE0 
    and $t2, $t2, $t0 #or with t2, t2 will hold the info to print
    la $t1, PORTF #loads address of portf for the single button
    lw $t0, 0($t1)
    li $t3, 0x2 
    and $t0, $t0, $t3 
    sll $t0, 3 #shift right 3 
    or $t2, $t2, $t0 #or with t2 to be printed
    la $t1, PORTD   #load addrss of D for switches
    lw $t0, 0($t1) 
    li $t3, 0xF00
    and $t0, $t0, $t3
    srl $t0, 8 #right sift 8
    or $t2, $t2, $t0
    la $t1, PORTE 
    sw $t2, 0($t1) #print t2
    
    j  loop
      
.end main    
.data

    