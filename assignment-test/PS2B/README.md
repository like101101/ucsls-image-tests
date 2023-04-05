# Assembly Intro Problem Set

This is a very simple assignment to get you bootstrapped using the tools.

## Intro
Purpose of this Problem Set.

<!-- Add Make File -->
1. Explore the X86 General purpose Registers and get familiar with using Gdb (GNU debugger)
2. Learn how to express and interpret binary values in hex and unsigned decimal.
3. Use some basic bit and byte opcodes to have the cpu do some work for you.

## How to work on this problem set

- clone this repository and then add all your answer files to it.
  - don't forget to add each new file you make to the repo
  - test your solutions prior to submission
- You will then submit a copy of your repo to the gradescope submission site for this assignment
- Read each question in full for the first time before starting to solve.

### References

Beyond the textbook and lecture notes don't forget the manuals:
- https://www.gnu.org/software/gdb/documentation/

See the brief Makefile tutorial below.

## Step 1: `empty.s`

Use the textbook to create an `empty.s` program that you will use with the debugger. We need this assembly file to create a simple program that we can inspect with `gdb`.

To know more about how to write a simple assembly file, check the textbook sections `14.5.3. Creating and using our first executable`.

After creating the `empty.s` file, we can use the following minimal commands to assemble and link your code:

`as -g empty.s -o empty.o`

`ld -g empty.o -o empty`

### make and Makefiles



You will want to add a Makefile so that when you run `make empty` the `empty` binary will be created from your `empty.s` source file.

You may find the following brief tutorial helpful.  In general, the Makefiles
we will create in this class can be very simple.  A simple makefile to automate
the tasks for this question might look like the following:


```
empty: empty.o
       ld -g empty.o -o empty
       
empty.o: empty.s
       as -g empty.s -o empty.o
```

If you put this into a file called `Makefile` then when you run `make empty` make will look at the time
stamps on the files to determine if something has changed and then run the specified commands to update
the things that depend on the changes.  Eg. The above make file says that the **target** file `empty` depends on the `empty.o`.
If `empty.o` is newer than `empty` then the rule will be executed to create a new version of `empty`.  Similarly if the second
stanza says that the target `empty.o` depends on `empty.s`.  If `empty.s` is newer than `empty.o` it will run the rule to
update `empty.o`.  In this way, `make` will automte the task of running complex series of command depending on what files have changed.

To know more about writing `Makefile`, check the textbook. Also, it can be found in the lecture notes section `4.13. Make`. 

## GDB commands, command files and this assignment 

`gdb` is a very powerfull machine level debugger.  We will be using it to start and control a new process.  Generally, we use a debugger like `gdb` as in interactive program -- like the shell.  We start it and then use various `gdb` specific commands.  In this assignment we will be exploring several of these commands.

Like most powerful UNIX tools `gdb` has programmers in mind. As such, it supports two features that we will exploit in the assignment.
1. `gdb` allows us to define our own "user" functions.     
2. `gdb` allows us to read in commands from a file (command files).

We will combine the use of these two features.  For each question, after exploring `gdb`
commands to accomplish a task, we will write a `gdb` command file.   This file will define a user function
that automates the task we are doing.  The test script, provided for each question, will test if the `gdb` command file you  write, defines the correct `gdb` function that performs the task. 

This is a powerful way of using `gdb` and in future assignments you might want find it useful to write your own `gdb` functions and command files to improve your work flow.


### gdb script example

Assume the following file called `print.gdb`. This file is only defining one command called `myPrintRax`.

```
# The hash symbol can be used to add comment lines
# Please add some to explain what your 'gdb' commands do
define myPrintRax
   p /x $rax
end
```

We can then import and use the functions defined in the above file `print.gdb` (which specifically means the function `myPrintRax`) by running the below commands inside gdb.

```
$ gdb empty          # From your terminal, start the gdb program
(gdb) source print.gdb      # Inside gdb, execute our gdb script
(gdb) myPrintRax     # Execute function defined in the script
```

You can find more information about defining gdb user commands here:

https://sourceware.org/gdb/current/onlinedocs/gdb.html/Define.html#Define

## Question 1: `q1.gdb`

Start gdb and issue the commands shown bellow, to explore how to set and print the contents of registers. You should use the help command to understand what is happening eg. `help p` and `help x`).

Here is a brief description of what is going on:

Line 0: starts gdb and opens the empty ELF file

Line 1: sets a breakpoint to ensure that when we start a process from the ELF file it stops immediately

Line 2: starts a process from the ELF file so that we can start exploring the CPU and registers of the process

Remaining lines (3-10) demonstrate using set and print to modify and examine registers

The commands to try

```
00:$ gdb empty
01:(gdb) b _start
02:(gdb) run
03:(gdb) set $rax = 0b00000001
04:(gdb) p /x $rax 
05:(gdb) p /u $rax
06:(gdb) set $rbx = 0b00000010
07:(gdb) p /x $rbx 
08:(gdb) p /u $rbx
09:(gdb) set $rcx = 0b00001100
10:(gdb) p /x $rcx
11:(gdb) p /u $rcx
12:(gdb) set $rdx = 0b01100001
13:(gdb) p /x $rdx
14:(gdb) p /u $rdx
15:(gdb) p /c $rdx
16:(gdb) set $r8 = 0b01100010
17:(gdb) p /x $r8
18:(gdb) p /u $r8
19:(gdb) p /c $r8
```

After having explored the above use an editor to create a file called `q1.gdb`.

In this file, you will write the definition for a user defined Gdb function called `q1` (similar to the example above where we defined a `myPrintRax` inside `print.gdb`).  

### q1 gdb command

When run, your new `q1` gdb command should set the values of the registers so that the following is true

- `rax` = `0b1`
- `rbx` = `0b10`
- `rcx` = `0b1100`
- `rdx` = `0b01100001`
- `r8` = `0b01100010`

So your q1 gdb user defined function should be composed of the gdb commands that will set the registers to match the above.

If correct you should be able to do the following with similar output

```
$ gdb empty
(gdb) source q1.gdb
(gdb) b _start
(gdb) run
(gdb) q1
(gdb) p/t { $rax, $rbx, $rcx, $rdx, $r8 }  
$1 = {1, 10, 1100, 1100001, 1100010}
(gdb) quit
```

You will find a bash script named `q1test.sh` that you can use to test your solution.
You are encouraged to examine it to see how it works.

To know more about registers, check the textbook sections `13.2.3. Registers` and `17.2.1. Registers`.  You can find details for working with registers in gdb here:

https://jappavoo.github.io/UndertheCovers/textbook/assembly/InfoRepI.html#gdb-display-and-set-registers

## Question 2: `q2.gdb`

Your next task is to execute an operation. In particular, you will have your computer count the number of bits that are set to 1 in the value of the RAX register and place the result in RBX.
In this task, you will no longer use Gdb functionality to set the values of registers. Instead, you will "program" the computer to perform this operation. You will do that by writing an
assembly instruction to the memory of your computerr and then have your computer execute that instruction.

To do this you will need to write the bytes that correspond to the IA64 opcode for the popcnt instruction:
``` gas
  popcnt rbx, rax     
```

The opcode for this instruction is:
```
        0xf3, 0x48, 0x0f, 0xb8, 0xd8
```

You will need to have the CPU execute this instruction and then examine the register values to see if things look right.  You are encouraged to play around with this
by hand and then when you are convinced you know how things work write your `q2.gdb` file to automate things with a `q2` command.
Again there is a testing script, `q2test.sh`, that you should use to test your solution.  


### Hints


#### 1. Syntax for setting values in memory

There is two forms of syntax we can use to write a single byte value to a location in memory.  You are free to use which ever you prefer.  The following are the generic form of the two syntax that we can use:

1. `set ((char *)<address>)[0]=<value>`
2. `set {char}<address>=<value>`

Where `<address>` is the memory location you want to update and `value` is the single byte value you want to write.    The address can either by a number or your can have gdb calculate it from a symbol like `_start`.

Using a number, for the address, is somewhat easier.  So lets first look a such an example

```
(gdb) p /x & _start
$1 = 0x401000
(gdb) x /1xb & _start
0x401000 <_start>:      0x00
(gdb) set ((char *)0x401000)[0]=0xaa
(gdb) x /1xb & _start
0x401000 <_start>:      0xaa
(gdb) set {char}0x401000=0xbb
(gdb) x /1xb & _start
0x401000 <_start>:      0xbb
```

1. First we print the address of the symbol `_start`
2. Then we examine the value at that address in memory
3. Then we replace the value at that address using the first syntax
4. Then we exmaine the value to be sure our set worked
5. Then we repeat using the other syntax

If we want to set the next byte in memory we would simple add one to the memory address Eg.

```
(gdb) set {char}(0x401000+1)=0xcc
```

of if we are using the first syntax we can do the same by changing the 0 to a 1 in the square brackets.  Eg.

```
(gdb) set ((char *)0x401000)[1]=0xaa
```

The other approach to doing this is to directly have gdb substitute the address using the symbol name.  However this syntax can be a little trick as we need to tell gdb more about they symbol.  Eg

```
(gdb) set (((char *)&_start))[0] = 0x00
(gdb) set (((char *)&_start))[2] = 0x11
```

of using the other syntax

```
(gdb) set {char} (((char *)&_start)) = 0x00
(gdb) set {char} (((char *)&_start+1)) = 0x11
```

For more information on the first form see:

https://jappavoo.github.io/UndertheCovers/textbook/assembly/InfoRepI.html#gdb-and-memory

#### 2. Executing a single instruction (single stepping)

One of the cpu registers is the `rip` register. The current value of `rip` tells the processor what is the location in memory of the opcode bytes that you want the CPU to execute. 

Gdb has a function called `stepi`. This Gdb command directs Gdb to allow the processor to execute the instruction encoded at the memory location pointed to by the instruction pointer register
`rip`.  After writing your opcode values into memory, you will need to set the 'rip' value to the location of the opcodes and then use the `stepi` Gdb command to execute your instruction.

We suggest that you place your opcode bytes starting at address of your `_start` symbol in your empty program.  Remember you will need to make sure tha your `empty` binary has set aside enough space for the number of bytes you will need to write'


#### 3. Examining Memory and Disassembling 

One of the most common task that we will do in gdb is to explore memory.  The command to do this is the `x` command.

```
(gdb) help x 
```
 
Using this command we can have gdb interpret a specified area of memory.  The `x` command lets us  print the byte values at a location in memory in various formats. For example:

```
(gdb) x/8bx 0x401000
```

prints 8 (b)ytes found at the memory address `0x401000` in he(x)adecimal notation.


We can also use the current value of a register to specify the address. Eg.

```
(gdb) x/16bx $rip     
```

prints 16 (b)ytes found at the memory address in the rip register in he(x)adecimal notation.
       
##### Using `x` to "Disassemble"

One very useful format is interpreting memory bytes as opcodes and translating them to the corresponding assembly instructions.  This ability is called disassembling -- going from opcodes to the human readable assembly instruction definitions from the CPU's manual.

For example `x/1i $rip` would decode enough bytes at the memory location currently pointed to by the instruction pointer that form one IA64 instruction.  Note to switch gdb to use the INTEL assembly format use
```
(gdb) set disassembly-flavor intel
```

Here is an example 
```
(gdb) b _start
Breakpoint 1 at 0x401000
(gdb) run
Starting program: /home/jovyan/work/UnderTheCovers-IM/assembly/CS400-F21-PS2/src/empty 

Breakpoint 1, 0x0000000000401000 in _start ()
(gdb) x /5xb & _start
0x401000 <_start>:      0x00    0x00    0x00    0x00    0x00
(gdb) source q2.gdb
(gdb) q2
(gdb) x /5xb _start
0x401000 <_start>:      0xf3    0x48    0x0f    0xb8    0xd8
(gdb) x /1i _start
=> 0x401000 <_start>:   popcnt %rax,%rbx
(gdb) set disassembly-flavor intel
(gdb) x /1i _start
=> 0x401000 <_start>:   popcnt rbx,rax
(gdb) p $rip
$1 = (void (*)()) 0x401000 <_start>
(gdb) x /1i $rip
=> 0x401000 <_start>:   popcnt rbx,rax
(gdb) 
```
### The task

Using the above information:
1. Update your `empty.s` file if needed.
2. Create a `q2.gdb` file and a `q2` gdb command with in it. 
   1. Your `q2` command should write the necessary opcode bytes of our assembly instruction to the locations starting at the `_start` address.  In our case our assembly instruction is `popcnt rbx, rax`  and the opcode bytes are `0xf3, 0x48, 0x0f, 0xb8, 0xd8`.  
   
Don't forget you can confirm if your `q2` gdb function is doing the right thing by disassembling the memory (see the hints above).   

After writing the command, you should be able to execute the loaded instruction as follows (commands shown in the example above):
1. Start `gdb` and load the `empty` program.
2. Load the gdb file and execute the command.
2. Set the `rip` to `_start`, and
3. Finally use the `stepi` command to execute the instruction.

You can test your solution by running the script `./q2test.sh`. Also, you can test your `q2` command  by loading 'rax' ahead of running your `q2` command and then examine the contents of `rbx` after to see if things look right.

## Question 3: `q3.gdb`

In this question we are going to put our new skills to the test with  bit of a puzzle.

The following is gdb ouput that this question will deal with.

```
(gdb) x /12xb _start
0x400078 <_start>:      0xf3    0x48    0x0f    0xb8    0xd8    0x48    0x89    0x1d
0x400080 <_start+8>:    0x00    0x00    0x00    0x00
(gdb)
```

### Step 1: Modify your `empty.s`

1. First  modify  your `empty.s` so that it leaves enough space at `_start` for the 12 bytes.
2. Add the following two lines before your `.text` secion
```
       .data
       .fill 16, 1, 0x0
```
3. Add the following option `--omagic` to your compile line inside the Makefile. It sets the text and data sections to be readable and writable.
```
       ld --omagic -g empty.o -o empty
```

### Step 2: `q3.gdb` and testng with `q3test.sh`

1. Create a `q3.gdb` and define a `q3` gdb command that places the 12 values at the location of `_start` (similar to `q2`).
2. Use `q3test.sh` to confirm that your q3.gdb is working correctly.