	.ORIG x3000
	LEA R0 INPUT
	PUTS
	AND R0, R0, #0
	AND R2, R2, #0		;Treat R2 as int, set to 0
	AND R4, R4, #0		;R4 is Flag

GETNX	GETC	;get input
	PUTC
	
	AND R5, R5, #0		;R5 =0, R6 = 3
	AND R6, R6, #0
	ADD R6, R6, #3

	ADD R5, R0, #-10	;Check for LF
	BRz NEWL
	
GETNUM	ADD R0, R0, #-15	;loop to reduce by 48	
	ADD R6, R6, #-1
	BRp GETNUM		;subtract 15 3 times (45)
	ADD R0, R0, #0
	BRnp	CONT
	
	ADD R4, R4, #1		; Set flag to 1 if R0-45 = 0
	BRp GETNX 

CONT	ADD R0, R0, #-3		;subtract 3 so input is 48 less
				;PUTC	

	AND R1, R1, #0
	ADD R1, R0, #0		;set R1 = R0 as to not manipulate R0
	AND R6, R6, #0
	ADD R6, R6, 4		;R6 = 4 for 4 loops

GETZ	ADD R1, R1, #-10		;Check for X
	ADD R6, R6, #-1
	BRp GETZ	
	ADD R1, R1, #0
	BRz EXIT

	AND R3, R3, #0
	ADD R3, R3, R2
	AND R6, R6, #0
	ADD R6, R6, #9

GETFULL	ADD R2, R2, R3	;Multiplies R2 by 10
	ADD R6, R6, #-1
	BRp GETFULL

	ADD R2, R2, R0	;Adds R0 to R2 
	BRnzp GETNX
	

NEWL	AND R0, R0, #0	;New line entered
	ADD R0, R2, #0
	ADD R4, R4, #0
	BRz CONT1	;if no flag continue else flip and add 1
	NOT R2, R2
	ADD R2, R2, #1
	

CONT1	AND R3, R3, #0
	AND R5, R5, #0
	ADD R3, R3, #1
	ADD R5, R5, #15
	AND R6, R6, #0
	
Bloop	ADD R5, R5, #0
	BRn EXIT
	
	AND R6, R3, R2
	BRz ZERO

	LEA R0, one
	PUTS
	BRnzp count

ZERO	LEA R0, zero
	PUTS
		
count	ADD R5, R5, #-1	;decrement counter
	ADD R3, R3, R3	;incrememnt pointer
	BRnzp Bloop

	


EXIT	TRAP x25
zero	.STRINGZ	"0"
one	.STRINGZ	"1"
INPUT	.STRINGZ	"Enter a decimal number or X to quit:\n"
DAWG	.STRINGZ	"DOGG"
	.END