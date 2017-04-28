	.TITLE Circular buffer
	.IDENT "V01.00"
# interrupts = circular buffer
# send strings while doing some computation

	# This bit is the nascent operating system
	ttyaddr=64 # interrupt entry point for tty - set to address of handler routine
	ttysw=66 # holds status word to load when start handling tty input
	tpsw=200 # value to put in status word
	tps=177564 # control register for console output
	tpb=177566 # data register for console output
	psw=177776

	STACK = 0x1000

	.text

osstart:
	mov iput,@ttyaddr
	mov tpsw,ttysw
	
	# now enable interrupts from tty
	#  need to set bit-6 & 7 in its control register
	mov 300,@tps
	jsr pc,application
	halt

	# last character has been sent
	# increment get index modulo length of buffer
	iput:
	inc getndx
	bic 177760,getndx
	# if getndx has caught up with putndx, then there are no more
	# characters to send
	cmp getndx,putndx
	beq idone
	mov r0,-(sp)
	mov getndx,r0
	movb buff(r0),@tpb
	mov (sp)+,r0
	rti
idone:
	clr active
	rti

# writeline - copy characters into buffer and send them off
# of course, if buffer cannot hold all characters will have to 
# wait
# this version of writeline takes address of string as 
# argument in r0
# uses register r1 (doesn't save and restore!
writeline:
	tstb (r0)
	beq endmessage
	# if printer isn't active - send this byte
	bis 240,@psw
	tst active
	bne usebuf
	# simply send the byte - and set getndx one less than putndx modulo buffer length
	# and mark printer active
	movb (r0),@tpb
	inc r0
	mov putndx,getndx
	dec getndx
	bic 177760,getndx
	inc active
	bic 240,@psw
	br writeline

# usebuf - put character into buffer if we can
usebuf:
	bic 240,@psw
	cmp putndx,getndx
	bne canput
	wait
	br usebuf
canput: 
	mov putndx,r1
	movb (r0),buff(r1)
	inc r0
	inc putndx
	bic 177760,putndx
	br writeline
	# all characters of message sent to buffer, can rts
endmessage: 
	rts pc

application:
	mov msg1,r0
	jsr pc, writeline
	mov newline,r0
	jsr pc, writeline
	# compute a bit
busy1:
	inc r2
	cmp r2,377
	blt busy1
	# another message
	mov msg2,r0
	jsr pc, writeline
	mov newline,r0
	jsr pc, writeline
	# compute a bit more
	clr r2
busy2:
	inc r2
	cmp r2,377
	blt busy2
	# another message
	mov msg3,r0
	jsr pc, writeline
	mov newline,r0
	jsr pc, writeline
	clr r2
busy3:
	inc r2
	cmp r2,377
	blt busy3
	mov msg4,r0
	jsr pc, writeline
	clr r2
busy4: 
	inc r2
	cmp r2,177
	blt busy4
	rts pc

.data

# circular buffer data structure
# 10 (i.e. eight) words 16-characters
	buff: .word 0
	.word 0
	.word 0
	.word 0
	.word 0
	.word 0
	.word 0
	.word 0
	.word 0
	.word 0
# two index values put and get - appropriately initialized
	putndx:.word 0
	getndx:.word 17
# active flag
	active:.word 0

	msg1: .string "Hi mom"
# acts as a newline string
	newline: .word 15 
#
	msg2: .string "It works - and about time too"
	msg3: .string "Hand, hand, fingers, thumb, one thumb, one thumb, drumming on a drum, rings on fingers, rings on thumb"
	msg4: .string "dum, dity, dum, ditty, dum, dum, dum"
.end osstart
