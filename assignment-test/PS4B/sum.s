	.intel_syntax noprefix

	.section .text
	# The symbolic label SUM will mark the address
        # in memory that your routine will be placed by the 
        # linker.  The '.global' directive exposes this label
        # so that code from other object files can know the
        # address of your routine and thus jump to it
        .global SUM
SUM:
	# INPUTS: rax -> x
	#         rbx -> &y address of where in memory y is
	# OUTPUTS: x = x + y : update rax by adding v
	#                      quantity at the location of &y
	#          if y is positive then add y into the 8 byte value at 0x100 
	#          else add y into the 8 byte value at 0x108
	#          final rbx should equal &y + 8
	mov  rdx, QWORD PTR [rbx]
	addq rbx, 8
	add  rax, rdx
	cmp  rdx, 0
	js   SUM_NEG
	add  QWORD PTR [SUM_POSITIVE], rdx
	ret
SUM_NEG:	
	addq QWORD PTR [SUM_NEGATIVE], rdx
	ret

	
				  

