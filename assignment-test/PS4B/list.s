	.intel_syntax noprefix

	.section .text

	#	'L'pad'<op>'pad<listheadaddr>
	#       rbx is address of '<op>'	
	.global PROCESS_LIST

PROCESS_LIST:
	mov   cl, BYTE PTR [rbx]    # cl = '<op>'
        add   rbx, 7                # advance to list head (1 + 6 byte pad)
        mov   r14, QWORD PTR [rbx]  # r14 address of first list element
	add   rbx, 8                # advance rbx

	cmp   r14, 0                # if head == NULL goto done
	jz    PROCESS_LIST_DONE  
	
	call   opToAddr
	
	cmpq   r15, 0              # if operaiton was not known then
                                   # nothing to be done just leave
	
        jz     PROCESS_LIST_DONE
	push   rbx                # save rbx as loop needs to
                                  # overwrite it to pass array location
                                  # as argument to operations

	# this is a list walk first element == NULL already taken careof
        #  element: <8 byte op argument>,<8 byte pointer to next>
PROCESS_LIST_LOOP: 
	mov   rbx, r14                  # first 8 bytes of element is argument
	call  r15                       # call operation pointed to by r15
        mov    r14, QWORD PTR [r14 + 8] # put next value in r14
	cmp   r14, 0                    # until next == NULL 
        jnz    PROCESS_LIST_LOOP        # process next element   
	
	pop    rbx                # restore rbx to point to current location
                                  # in command input 
PROCESS_LIST_DONE:			
	ret


