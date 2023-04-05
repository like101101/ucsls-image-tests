	.intel_syntax noprefix
	.text
	.global _start
_start:
	# zero out rax
	xor  rax, rax
	# setup rbx to point to the start of the commands
	mov  rbx, OFFSET [CALC_DATA_BEGIN]
	
	## This is where we would do some real work
	
	# but we are just exiting for the moment
	mov rax, 60
	mov rdi, 0
        syscall
