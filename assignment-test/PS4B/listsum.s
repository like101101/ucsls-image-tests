	.intel_syntax noprefix

	.section .text

	.global LISTSUM

LISTSUM:
        mov   r14, QWORD PTR [rbx] # r14 address of first list element
	add   rbx, 0x8             # advance rbx

	cmp   r14, 0               # if head == NULL goto done
	jz    LISTSUM_DONE
	
	push  rbx                # save rbx as loop needs to
                                  # overwrite it to pass array location
                                  # as argument to operations

	# this is a list walk first element == NULL already taken careof
        #  element: <8 byte op argument>,<8 byte pointer to next>
LISTSUM_LOOP: 
	mov   rbx, r14            # first 8 bytes of element is argument
	call  SUM                 # call operation pointed to by r15
        mov   r14, [r14 + 8]      # put next value in r14
	cmp   r14,0               # until next == NULL 
        jnz   LISTSUM_LOOP        # process next element   
	
	pop   rbx                 # restore rbx to point to current location
                                  # in command input 
LISTSUM_DONE:			
	ret


