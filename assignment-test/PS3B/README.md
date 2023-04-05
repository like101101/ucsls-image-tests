# Assembly Writing some simple assembly fragments

Before we start writing functions in assembly language we will start writing some simple assembly "fragments".  

## IMPORTANT GENERAL INFORMATION

Each fragment should have a symbolic label that identifies the beginning of its instructions.  The last instruction in each fragment should trap back to the debugger.  For more information about trapping back to the debugger  see the lecture notes here:

https://jappavoo.github.io/UndertheCovers/lecturenotes/assembly/L08.html#interrupt-3-int3-trap-to-debugger) 

You should write each fragment in its own assembly source code file. 
You will also need to write a single `Makefile`.  In your `Makefile` should have a recipe that converts the fragment assembly source file to its own object file.  

In the descriptions for the fragments, that follows, we will also provide you test code for each fragment.  You should place this test code into its own source file and add a recipe to your `Makefile` to assemble the source file into its own object file.  The descriptions below will tell what file names you should use for the source files.

Finally, you will need to add a recipe to your `Makefile`, that links the two object files to produce the necessary binary executable.   To understand what your `Makefile` recipe needs to look like you will need read the provided test script for each fragment.   

The provided test script for each fragments will check if your fragments are correct.  The test scripts expect your `Makefile` to have certain targets that you will need to write.  You will have to study the test script to figure out what these targets are.  HINT: Examine each line in the test script that invokes make.

Given that we don't know how to write complete functions yet our fragments finish by trapping back to the debugger.  With this in mind our code is "run" and tested using `gdb`.   For example, each provided test script starts `gdb` with your executable and then runs `gdb` commands to exercise  your fragment.  You should use `gdb` by hand to explore both the test code and your fragments.  

**Don't blindly use the test scripts they are there for you to explore and learn from.**


## NOTES

What you need to complete this assignment can be found in the examples in the lecture slides, discussion handouts and textbook. Additionally provided reference sheet summarizes all the assembly and gdb syntax that you need.


### Examples

The examples, in lecturenotes, discussions and textbook, include example of the commands required to assemble your code into object files and how link it the object files into an executable.  In particular, the `sumit.s and usesum.s` example, from the lecture notes, illustrates the complete process of creating a binary from two source files; 1) a file containing a assembly fragment (`sumit.s` and 2) a file containing test code that uses the fragment `usesum.s`.  This example can be found here:

https://jappavoo.github.io/UndertheCovers/lecturenotes/assembly/L10.html#sumit-s-and-usesumit-s


### Reference Information

The reference sheet:

https://jappavoo.github.io/UndertheCovers/textbook/images/INTELAssemblyAndGDBReferenceSheet.pdf

Has a summary of all the INTEL instructions, addressing mode syntax and gdb commands you need.

If needed more information you can look up INTEL instructions and how they work in the INTEL manual that are available online here:

https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html

Chapters 3, 4, 5 of Volume 2A is the INTEL instruction set reference documentation that provides a detailed description of all the INTEL. 
The table of contents lets you jump directly to the pages for a particular instruction. 

With respect to the address mode syntax for the operands, beyond what is on the reference sheet, you can find a summary and guidance in the lecture notes here: 

https://jappavoo.github.io/UndertheCovers/lecturenotes/assembly/L09.html#addressing-modes-for-sources-and-destinations


## The Fragments to write

There are three fragments `AND_FRAG`, `OR_FRAG` and `SUM_FRAG`.  Each are described below. 

### File: `and.s` Fragment symbol: `AND_FRAG`

#### Description
```
	# AND_FRAG Fragement
	# INPUTS: rax -> x
	#         rbx -> &y address of where in memory y is
	# OUTPUTS: x = x bitwise and y : update rax with bit wise and of the 
	#                                8 byte quantity at the location of &y
	#          rbx should be updated to equal &y + 8
```


#### Test code: `andtest.s`
```
	.intel_syntax noprefix
	.section .text
	.global _start
_start:
test1:
	mov rbx, OFFSET data_start
	mov rax, 0xdeadbeefdeadbeef
	jmp AND_FRAG
test2:	
	jmp AND_FRAG
test3:	
	jmp AND_FRAG

	.section .data
data_start:
	.quad -1                  # mask all bits
	.quad 0xaaaaaaaaaaaaaaaa  # every other bit
	.quad 0xF000F000F000F000
data_end:
	.quad 0x0
```

Study the test code to figure out exactly what is expected of your AND
routine.  You are encouraged to write your own more complex test program to ensure that you understand what is going on.  

The included `addtest.sh` will be used to test your solution. It
assumes that you have created a Makefile that does what is needed. You
will need to study the `addtest.sh` to figure out what your Makefile
will need to do and how your code will be tested with `gdb`.  Do not
blindly try and make your solution work with the test script.  Rather
read the scripts and figure out how to writing things and test them
yourselves by hand.


### File: `or.s` Fragment Symbol: `OR_FRAG`

Similar to above but with or.  

#### Description

```
        # INPUTS: rax -> x
        #         rbx -> &y address of where in memory y is
        # OUTPUTS: x = x bitwise or y : update rax with bitwise or of the 
        #                               8 byte quantity at the location of &y
        #          rbx should be updated to equal &y + 8
```

#### Test code: `ortest.s`
```
        .intel_syntax noprefix
        .section .text
        .global _start
_start:
test1:
        mov rbx, OFFSET data_start
        xor rax, rax
        jmp OR_FRAG
test2:
        jmp OR_FRAG
test3:
        jmp OR_FRAG

        .section .data
data_start:
        .quad 1                  # lowest bit
        .quad 0x8000000000000000 # higest bit
        .quad 0x00000FFFFFF00000 # middle 12
data_end:
        .quad 0x0
```

### File: `sum.s`  Fragement Symbol: `SUM_FRAG`

Now that we have gotten the hang of the mechanics lets write a fragment that is a little more involved and operates on memory as well as registers.

#### Description
```
        # INPUTS: rax -> x
        #         rbx -> &y address of where in memory y is
        # OUTPUTS: x = x + y : update rax by adding y
        #                      quantity at the location of &y
        #          if y is positive then add y into an 8 byte value
        #          stored at a location marked by a symbol
        #          named SUM_POSTIVE
        #          else add y into an 8 byte value stored at a 
        #          location marked by a symbol named SUM_NEGATIVE
        #          final rbx should be updated to equal &y + 8
        #
        # This file must provide the symbols SUM_POSTIVE 
        # and SUM_NEGATIVE and associated memory
```        


#### Test code: `sumtest.s`

```
        .intel_syntax noprefix

        .section .text
        .global _start
_start:
test1:
        xor rax, rax
        mov QWORD PTR [SUM_POSITIVE], rax
        mov QWORD PTR [SUM_NEGATIVE], rax

        mov rbx, OFFSET data_start

        jmp SUM_FRAG
test2:
        jmp SUM_FRAG
test3:
        jmp SUM_FRAG
test4:
        jmp SUM_FRAG

        .section .data
data_start:
        .quad -1
        .quad 1
        .quad 54644566
        .quad -2233
data_end:
        .quad 0x0
```