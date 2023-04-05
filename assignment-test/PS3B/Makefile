ASMTARGETS=andtest ortest sumtest
# override default behaviour of removing .o's as intermediate file cleanup
.PRECIOUS: %.o %.I
.PHONEY: all

all: ${ASMTARGETS}

andtest: and.o andtest.o
	ld ${DEBUG} -Map=$@.map $^ -o $@

ortest: or.o ortest.o
	ld ${DEBUG} -Map=$@.map $^ -o $@

sumtest: sum.o sumtest.o
	ld ${DEBUG} -Map=$@.map $^ -o $@
# default rule for standalone assembly examples
# override standard defaults
%: %.s
%: %.c 
%: %.S
%: %.o
%: %.sh

%.o: %.I
	as ${DEBUG} -a=$@.lst $< -o $@

%.o: %.S
	as ${DEBUG} -a=$@.lst $< -o $@


clean:
	rm -f $(wildcard ${ASMTARGETS} ${CTARGETS}  *.o *~ *.lst *.map *.I *.resbin)
