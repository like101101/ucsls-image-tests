DEBUG=-g
REQUIRED=calc_simpleone calc_basic calc_upperonly calc_easy calc_basicwithupper calc_simplerandom
BONUS1=calc_arraysum calc_listsum
BONUS2=calc_atoq calc_array calc_list 


PGMS=${REQUIRED} ${BONUS1} ${BONUS2}
REFPREBIN=$(PGMS:%=data/reference_%.prebin)
REFRESBIN=$(PGMS:%=data/reference_%.resbin)

# override default behaviour of removing .o's as intermediate file cleanup
.PRECIOUS: %.o %.I
.PHONEY: all 
calcobjs=and.o or.o sum.o upper.o arraysum.o listsum.o array.o list.o atoq.o calc.o
all: ${PGMS} ${REFRESBIN}

calc_simpleone: ${calcobjs} data/simpleone_cmds.o
	ld ${DEBUG} $^ -o $@

calc_basic: ${calcobjs} data/basic_cmds.o
	ld ${DEBUG}  $^ -o $@

calc_upperonly: ${calcobjs} data/upperonly_cmds.o
	ld ${DEBUG} $^ -o $@

calc_easy: ${calcobjs} data/easy_cmds.o
	ld ${DEBUG} $^ -o $@

calc_basicwithupper: ${calcobjs} data/basicwithupper_cmds.o
	ld ${DEBUG} $^ -o $@

calc_simplerandom: ${calcobjs} data/simplerandom_cmds.o
	ld ${DEBUG} $^ -o $@

calc_arraysum: ${calcobjs} data/arraysum_cmds.o
	ld ${DEBUG} $^ -o $@

calc_listsum: ${calcobjs} data/listsum_cmds.o
	ld ${DEBUG} $^ -o $@

calc_atoq: ${calcobjs} data/atoq_cmds.o
	ld ${DEBUG} $^ -o $@

calc_array: ${calcobjs} data/array_cmds.o
	ld ${DEBUG} $^ -o $@

calc_list: ${calcobjs} data/list_cmds.o
	ld ${DEBUG} $^ -o $@

# default rule for standalone assembly examples
# override standard defaults
%: %.s
%: %.c 
%: %.S
%: %.o
%: %.sh

data/reference_%.resbin: % testcalc.sh
	./testcalc.sh $<
	mv $<.prebin data/reference_$<.prebin
	mv $<.resbin data/reference_$<.resbin

%.o: %.s
	as ${DEBUG} $< -o $@

clean:
	rm -f $(wildcard ${PGMS} ${CTARGETS}  *.o *~ *.lst *.map *.I *.resbin data/*.o data/*.lst data/*~ data/*.output *.output *.prebin  *.stderr data/*.resbin data/*.prebin)
