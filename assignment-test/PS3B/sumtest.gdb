set pagination off
source kex.gdb

killKex

setup
startKex
continue

delete 1

echo loading binary\n
file sumtest.elf
load sumtest.elf
display /x { $rax, $rbx }
display /2dg 0x100

echo RUNNING TEST 1\n
set $pc = test1
c
echo SAVING: rax rbx and data at 0x100 and 0x108 \n
dump binary value sum.resbin { $rax, $rbx, *((long long *)0x100), *((long long *)0x108) }

echo RUNNING TEST 1\n
set $pc = test2
c
echo SAVING: rax rbx and data at 0x100 and 0x108 \n
append binary value sum.resbin { $rax, $rbx, *((long long *)0x100), *((long long *)0x108) }

echo RUNNING TEST 3\n
set $pc = test3
c
echo SAVING: rax rbx and data at 0x100 and 0x108 \n
append binary value sum.resbin { $rax, $rbx, *((long long *)0x100), *((long long *)0x108) }

echo RUNNING TEST 4\n
set $pc = test4
c
echo SAVING: rax rbx and data at 0x100 and 0x108 \n
append binary value sum.resbin { $rax, $rbx, *((long long *)0x100), *((long long *)0x108) }

quit

