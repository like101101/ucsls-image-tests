ASFLAGS=-a=$@.lst
LDFLAGS=-Map=$@.map
DEBUG=-g

.PHONY: all clean scp

all: empty

empty: empty.o
	ld --omagic empty.o -o empty

empty.o: empty.s
	as empty.s -o empty.o

clean:
	rm -f $(wildcard *.o *~ *.lst *.map *.resbin empty q3 *.json)
