	.intel_syntax noprefix

	.section .text
	.global _start	
_start:	
	xor rax, rax
	mov rbx, OFFSET [CALC_DATA_BEGIN]

PARSE:	mov  cl, BYTE PTR [rbx]   # mov the first byte in the data into cl
	cmp  cl, 0
	jz   DONE

	# real work would go here
	add rbx, 0x8
	call dummy

	jmp PARSE
	
DONE:
	mov rax, 60
	mov rdi, 0
	syscall


dummy:
	add rbx, 8
	ret
