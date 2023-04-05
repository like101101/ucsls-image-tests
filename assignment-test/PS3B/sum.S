	.intel_syntax noprefix
	
	.section .text
	.global SUM_FRAG
	
SUM_FRAG:
	mov  rdx, QWORD PTR [rbx]
	add  rbx, 0x8
	add  rax, rdx
	cmp  rdx, 0
	js   SUM_NEG
	add  QWORD PTR [SUM_POSITIVE], rdx
	int3
SUM_NEG:	
	add  QWORD PTR [SUM_NEGATIVE], rdx
	int3

	
	.section .data
SUM_POSITIVE:
	.quad 0
	.global SUM_POSITIVE
	
SUM_NEGATIVE:
	.quad 0
	.global SUM_NEGATIVE
