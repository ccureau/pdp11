	.TITLE getconch: get a byte from the system console into r0 (blocking)
	.IDENT "V01.00"

	.GLOBAL _getconch

	CSR	= 0177560
	BUF	= 0177562

	.text

_getconch:
10$:
	tstb	@$CSR
	bpl	10$
	clrb	r2
	bisb	@$BUF,r0
	rts	pc

	.end _getconch

