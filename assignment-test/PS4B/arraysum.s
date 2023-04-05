	.intel_syntax noprefix

	.section .text

	.global ARRAYSUM
	
ARRAYSUM:
        mov   r14, QWORD PTR [rbx] # r14 len of array
 	add   rbx, 8               # advance to baseaddr
	mov   r13, QWORD PTR [rbx] # r13 = A -- array base addr 
	add   rbx, 8               # advance rbx
	cmp   r14, 0               # if len == 0 goto done
	jz    ARRAYSUM_DONE
	push  rbx                  # save rbx as loop needs to
                                   # overwrite it to pass array location
                                   # as argument to operations
        xor   r12, r12             # r12 i = 0
ARRAYSUM_LOOP: 
	lea   rbx, [r13 + r12 *8]  # rbx address of ith element
	callq  SUM                 # call sum
	inc    r12                 # i++
	dec    r14                 # len--
        jnz    ARRAYSUM_LOOP       # until len==0 process next element in array
	pop    rbx                 # restore rbx to point to current location
                                   # in command input 
ARRAYSUM_DONE:	
	ret

