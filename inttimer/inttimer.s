	.TITLE Interrupt counter
	.IDENT "V01.00"

	.GLOBAL start
	.GLOBAL _putconch
	.GLOBAL _timerint

	LKS = 777546
	STACK = 0x1000
	
	.text
start:

	mov	$STACK, sp
	mov	$timerint, @0100	/ 100 octal
	mov	0300, @0102		/ 102 octal
	mov	01750, $count
	clr	r3

timerint:
	mov	01000, $LKS		/ clear bit 7
	dec	$count
	beq	time
	jmp	$done

time:
	inc	r3
	mov	r3, r0
	jsr	pc, _putconch
	mov	01750, $count

done:
	rti

	.bss
count:	.word 0
