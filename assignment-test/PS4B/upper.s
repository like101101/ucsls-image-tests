	.intel_syntax noprefix

	.section .text
	
        .global UPPER
UPPER:
	# INPUTS: rax -> x
	#         rbx -> &str address of where the string is located
	# OUTPUTS: x = x + length of string
	#          When done any lower case letters should be translated
	#          to an upper case letter
	mov  rdx, QWORD PTR [rbx]
	test rdx, rdx
	jz  UPPER_EXIT
        xor rdi, rdi
UPPER_WHILE:	
        mov  r8b, BYTE PTR [rdx + rdi]
        test r8b, r8b
	jz   UPPER_EXIT
        cmp  r8b, 'a'
        jb   UPPER_CONTINUE
        cmp r8b, 'z'
        ja  UPPER_CONTINUE
	sub r8b, 'a'-'A'
        mov BYTE PTR [rdx + rdi], r8b
UPPER_CONTINUE:
	inc rdi
        jmp UPPER_WHILE
UPPER_EXIT:
        add rax, rdi   # add the number of characters we processed to rax
        add rbx, 8     # update rbx and we have finished this command and processed the
                       # argument
        ret

	

