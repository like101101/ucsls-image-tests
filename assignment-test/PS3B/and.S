	.intel_syntax noprefix

	.section .text
	.global AND_FRAG
AND_FRAG:
	and rax, QWORD PTR [rbx]
	add rbx, 8
	int3

	
	
