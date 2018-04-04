	.ORIG x3000		;ADAM PAZ, SECTION 2
	LEA R0 Msg2
	PUTS
	
BEGIN	LEA R0 Msg1
	PUTS
	GETC
	PUTC
	AND R7, R7 ,#0
	ADD R7, R7, R0

	AND R6, R6, #0
	ADD R6, R6, #6			
	AND R1, R1, #0
	ADD R1, R1, R7		;R1 is now the input char
	AND R7, R7 ,#0
GetIn	ADD R1, R1, #-10		
	ADD R6, R6, #-1		; R7 will now store the flag for E or D
	BRp GetIn
	ADD R1, R1, #-8		;Check for D
	BRz Dec	
	ADD R1, R1, #-1		;Check for E
	BRz Enc
	ADD R1, R1, #-10
	ADD R1, R1, #-9
	BRz Exit		; check for X
;--------------------------------------------------------------------------------
;sets encrypt/decrypt flag
Enc	LEA R0 Msg3			Encrypt
	PUTS
	AND R4, R4, #0
	BRz nxt

Dec	LEA R0 Msg3			;DECRYPT
	PUTS
	AND R4, R4, #0
	ADD R4, R4, #1

nxt	JSR GetNum
cont1	AND R5, R5, #0
	ADD R5, R5, R2			;R5 is now the cipher
Dloop	JSR write
	
;--------------------------------------------------------------------
;get the cipher
GetNum				;Loop to get the cipher
	AND R0, R0, #0
	AND R2, R2, #0		;Treat R2 as int, set to 0

GETNX	GETC	;get input
	PUTC
	
	AND R5, R5, #0		;R5 =0, R6 = 3
	ADD R5, R0, #-10	;Check for LF
	BRz goback		;call RET

	AND R5, R5, #0
	JSR load5		;Loading R5 with forte but was our of range
backup	ADD R0, R0, R5
	AND R1, R1, #0
	ADD R1, R0, #0		;set R1 = R0 as to not manipulate R0

	AND R3, R3, #0
	ADD R3, R3, R2
	AND R6, R6, #0
	ADD R6, R6, #9

GETFULL	ADD R2, R2, R3	;Multiplies R2 by 10
	ADD R6, R6, #-1
	BRp GETFULL
	ADD R2, R2, R0	;Adds R0 to R2 
	BRnzp GETNX	

goback	LEA R0, Msg4
	PUTS
	AND R6, R6, #0
	BRz cont1
;-----------------------------------------------------------
;writes input to 1st half of array
write	AND R3, R3, #0		;had to move closer to bottom
	BR J1			;R3 is pointer for 1st half
				; R2 is pointer for 2nd half
Loop	GETC
	PUTC			;echo
	AND R1, R1, #0
	AND R6, R6, #0		;R6 = 0 then
	ADD R6, R0, #-10	;Checks for LF
	BRz print
	
	STR R0,R3,#0       ; STORE IT
   	ADD R3,R3,#1      ; increments the pointer by 1 
	BRnzp checkin

;--------------------------------------------------------------
;Checks input for if it's a character
checkin	LD R6, letter	;R2 = 65
	ADD R1, R0, R6	;subtract 65, checking if under cap A
	BRn loadd

	LD R6, Uhalf
	AND R1, R1, #0	;Subtract 90 to see if Uppercase
	ADD R1, R0, R6		
	BRnz Upper
	
	LD R6, Lhalf
	AND R1, R1, #0	;Subtract 97 to see if not a letter
	ADD R1, R0, R6	
	BRn loadd
	
	LD R6, Lcase
	AND R1, R1, #0	;Subtract 122 to see if lowercase
	ADD R1, R0, R6	
	BRnz Lower
	BR loadd
;------------------------------------------------
Upper	ADD R4, R4, #0
	BRz UpperE
	BR UpperD

Lower	ADD R4, R4, #0
	BRz LowerE
	BR LowerD 
;---------------------------------------------------
flipcyl	ADD R5, R5, #0
	BRn contl
	NOT R5, R5	;not cipher to subtract
	ADD R5, R5, #1	; add 1 because 2's complement
	BRnzp contl

flipcy	ADD R5, R5, #0
	BRn contu
	NOT R5, R5	;not cipher to subtract
	ADD R5, R5, #1	; add 1 because 2's complement
	BRnzp contu
;----------------------load directly-------------------------------
loadd	STR R0, R2, #0
	ADD R2, R2, #1
	BR Loop
;------------------move1------------------------
;;;Things that need to be closer to the bottom

J1	JSR refarr	;sets my array pointer moved even lower
	AND R1, R1, #0
	LD R2, hunna		;R3 is pointer for 1st half
	ADD R2, R3, R2		; R2 is pointer for 2nd half
	BR Loop

load5	LD R5, forte	;code above could not read from bottom
	BR backup

Exit	BR EXIT

print	BR Print

loop	BR Loop
Begin	BR BEGIN
;------------------------Declarations-------------------------------------
Uhalf	.FILL		#-90
Lhalf	.FILL		#-97
Lcase	.FILL		#-122
letter	.FILL		#-65
forte	.FILL		#-48
hunna	.FILL		#200
Msg2	.STRINGZ	"Hello, welcome to my Caesar Cipher program \n"
Msg1	.STRINGZ	"Do you want to (E)ncrypt or (D)ecrypt or e(X)it? \n"
Msg3	.STRINGZ	"\nWhat is the cipher (1-25)? \n"
Msg4	.STRINGZ	"What is the string (up to 200 characters)? \n"
;----------------------Encryption----------------------------
;encryption for upper and lower case, R5 = cipher
	
UpperE	ADD R4, R4, #-1
	BRz UpperD	;if flag = 1 then go to decryption
	ADD R0, R5, R0	;ADD input with cipher
	LD R6, 	Uhalf1	
	AND R1, R1, #0		
	ADD R1, R0, R6		;Check to see if needs to loop back to A
	BRp backA
	STR R0, R2, #0
	ADD R2, R2, #1
	BR Loop

backA	LD R6, alpha
	ADD R0, R0, R6
	STR R0, R2, #0
	ADD R2, R2, #1
	BR loop

LowerE	ADD R4, R4, #-1
	BRz LowerD	;if flag = 1 then go to decryption
	ADD R0, R5, R0	;ADD input with cipher

	LD R6, 	Lcase1		;R6 = -122
	AND R1, R1, #0		
	ADD R1, R0, R6		;Check to see if needs to loop back to A
	BRp backA
	STR R0, R2, #0
	ADD R2, R2, #1
	BR loop
;-------------------Decryption--------------------------------
UpperD	BR flipcy
contu	ADD R0, R5, R0	;ADD input with cipher
	LD R6, 	letter1	;R6= -65 = A
	AND R1, R1, #0	                                             	
	ADD R1, R0, R6		;Check to see if needs to loop back to A
	BRn forwA
	STR R0, R2, #0
	ADD R2, R2, #1
	BR loop

forwA	LD R6, alphano
	ADD R0, R0, R6
	STR R0, R2, #0
	ADD R2, R2, #1
	BR loop

LowerD	BR flipcyl
contl	ADD R0, R5, R0	;ADD input with cipher
	LD R6, 	Lhalf1	;R6= -97 = A
	AND R1, R1, #0	                                             	
	ADD R1, R0, R6		;Check to see if needs to loop back to A
	BRn forwA
	STR R0, R2, #0
	ADD R2, R2, #1
	BR loop
;----------------------move2------------------
refarr	LEA R3, Array
	RET
;-------------------print------------------------------
;printing the output
;R6 is now a counter
Print	LEA R3, Array	
	AND R2, R2, #0
	ADD R2, R2, #1
ploop1	ADD R2, R2, #-1
	LD R6, hunna1	;acts as a counter	
ploop	LDR R0,R3,#0       ; load IT
	PUTC
	ADD R3, R3, #1
	ADD R6, R6, #-1
	BRp ploop
	LEA R0, NEWL
	PUTS
	ADD R2 R2, #0
	BRz ploop1
	BRnzp Begin

;-------------------------------------
EXIT	LEA R0, piece
	PUTS
	TRAP x25
NEWL	.STRINGZ	"\n"
piece	.STRINGZ	"\nPEACE OUT"
letter1	.FILL		#-65
alpha	.FILL		#-26
alphano	.FILL		#26
Uhalf1	.FILL		#-90
Lhalf1	.FILL		#-97
Lcase1	.FILL		#-122
forte1	.FILL		#-48
hunna1	.FILL		#200
min199	.FILL		#-199
Array	.BLKW		400
	.END