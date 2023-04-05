	.intel_syntax noprefix

	.section .text

	.global PROCESS_ARRAY

	# rbx should be pointing to opc (eg second byte of command type quad)
PROCESS_ARRAY:
	mov   cl, BYTE PTR [rbx]  # cl = '<op>'
        add   rbx, 7                # advance to len (1 + 6 bytes of padding)
        mov   r14, QWORD PTR [rbx]  # r14 len of array
 	add   rbx, 8                # advance to baseaddr
	mov   r13, QWORD PTR [rbx]  # r13 = A -- array base addr 
	add   rbx, 8                # advance rbx
	
	cmp   r14, 0                # if len == 0 goto done
	jz    PROCESS_ARRAY_DONE
	
	call   opToAddr
	cmpq   r15, 0               # if operation was not known then
                                    # nothing to be done just leave
        jz     PROCESS_ARRAY_DONE
	push   rbx                  # save rbx as loop needs to
                                    # overwrite it to pass array location
                                    # as argument to operations

        xor    r12, r12             # r12 i = 0
PROCESS_ARRAY_LOOP: 
	lea    rbx, [r13 + r12 * 8] # rbx address of ith array element
	call   r15                  # call operation pointed to by r15 
	inc    r12                  # i++
	dec    r14                  # len--
        jnz    PROCESS_ARRAY_LOOP   # until len==0 process next element in array

	pop    rbx                  # restore rbx to point to current lcoation
                                    # in command input 
PROCESS_ARRAY_DONE:	
	ret

	

