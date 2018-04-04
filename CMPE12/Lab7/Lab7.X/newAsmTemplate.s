#include <xc.h>
.text
.global main
.global milliseconds
.set noreorder
.ent main
/*LED5 = RF0*/
main:
    la $t0, TRISE
    li $t1, 0
    sw $t1, 0($t0)

    la $t0, TRISD
    li $t1, 0
    sw $t1, 0($t0)
    
    la $t0, TRISF
    li $t1, 0
    sw $t1, 0($t0)
    
    la $t0, PORTE
    li $t1, 0
    sw $t1, 0($t0)
    
    lw $t6, BUT_MASK
loop:
    lw $t1, PORTD
    lw $t5, PORTD
    and $t1, $t1, $t6
    and $t5, $t5, $t6
    srl $t2, $t1, 8
    lw $t3, PORTF
    andi $t3, $t3, 0x2
    sll $t4, $t3, 3
    or $t2, $t2, $t5
    or $t2, $t2, $t4
    sw $t2, 0($t0)
    
    j  loop
    
    
.end main    
.data
BUT_MASK: .word 0xFFFFFFEF