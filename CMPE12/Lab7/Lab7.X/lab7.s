
#include <WProgram.h>

/* define all global symbols here */
.global MyFunc
.global milliseconds

.text
.set noreorder


/*********************************************************************
 * Setup MyFunc
 ********************************************************************/
.ent MyFunc
MyFunc:
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
   
   leds:    lw	$t1, PORTD
	    lw	$t5, PORTD
	    and	$t1, $t1, $t6
	    and	$t5, $t5, $t6
	    srl	$t2, $t1, 8
	    lw	$t3, PORTF
	    andi $t3, $t3, 0x2
	    sll	$t4, $t3, 3
	    or	$t2, $t2, $t5
	    or	$t2, $t2, $t5
	    sw	$t2, 0($t0)
	    
	    J	leds
	    
.end MyFunc
.data
BUT_MASK:    .word 0xFFFFFFEF

/*********************************************************************
 * This is your ISR implementation. It is called from the vector table jump.
 ********************************************************************/
Lab8_ISR:


	
/*********************************************************************
 * This is the actual interrupt handler that gets installed
 * in the interrupt vector table. It jumps to the Lab5
 * interrupt handler function.
 ********************************************************************/
.section .vector_4, code
	j Lab8_ISR
	nop


