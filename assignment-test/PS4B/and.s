	.intel_syntax noprefix

	.section .text
	# The symbolic label AND will mark the address
        # in memory that your routine will be placed by the 
        # linker.  The '.global' directive exposes this label
        # so that code from other object files can know the
        # address of your routine and thus jump to it
        .global ANDF
ANDF:
	# INPUTS: rax -> x
	#         rbx -> &y address of where in memory y is
	# OUTPUTS: x = x bitwise and y : update rax with bit wise and of the 8 byte
	#                                quantity at the location of &y
	#          rbx sould equal &y + 8
        and rax, QWORD PTR [%rbx]
	add rbx, 0x8
	ret
	
	
				  

