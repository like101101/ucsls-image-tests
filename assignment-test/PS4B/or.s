	.intel_syntax noprefix
	.section .text
	# The symbolic label OR will mark the address
        # in memory that your routine will be placed by the 
        # linker.  The '.global' directive exposes this label
        # so that code from other object files can know the
        # address of your routine and thus jump to it
        .global ORF	 
ORF:
	# INPUTS: rax -> x
	#         rbx -> &y address of where in memory y is
	# OUTPUTS: x = x bitwise or y : update rax with bitwise or of the 8 byte
	#                               quantity at the location of &y
	#          rbx should equal &y + 8
	or  rax, QWORD PTR [rbx]
        add rbx, 8
        ret

	
				  

