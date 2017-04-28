CC=pdp11-aout-gcc
AS=pdp11-aout-as
LD=pdp11-aout-ld
LINKSCRIPT=../linkscript

OBJ = inttimer.o putconch.o

%.o: %.s
	$(AS) -o $@ $<

hellopdp: $(OBJ)
	$(LD) -T $(LINKSCRIPT) -o $@ $^

.PHONY: clean

clean:
	rm -f *.o hellopdp
