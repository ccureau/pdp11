     .TITLE Say hello on console
        .IDENT "V00.00"

        .GLOBAL start
        .GLOBAL _putconch

        STACK = 0x1000

        .text
start:
        mov     $STACK, sp
        mov     $hellom, r1
        mov     $helloc, r2
10$:    movb    (r1), r0
        jsr     pc, _putconch
        dec     r2
        beq     20$
        inc     r1
        jmp     10$

20$:	jsr	pc, _getconch
	jsr	pc, _putconch

99$:    nop
        halt

        .data
hellom: .ascii  "Hello world!"
        helloc = . - hellom

        .end                      

