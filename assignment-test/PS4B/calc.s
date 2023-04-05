	.intel_syntax noprefix
	
	.section .data
	.comm SUM_POSITIVE, 8, 8
	.comm SUM_NEGATIVE, 8, 8
	.global SUM_POSITIVE
	.global SUM_NEGATIVE
	
	.section .text
	
	.global _start
_start:	
	# setup registers
	# rbx is expected to point to the input
	xor  rax, rax     # zero out rax  : running result
	xor  rcx, rcx     # zero out rcx  : tmp used to parse chracters into cl
	xor  rdx, rdx     # zero out rdx  : used in UPPER, SUM
	xor  rdi, rdi     # zero out rdi  : used in UPPER
	xor  r8,  r8      # zero out r8   : used in UPPER
	xor  r9,  r9      # zero out r9   : used in ATOQ
	xor  r10, r10     # zero out r10  : used in ATOQ
	xor  r11, r11     # zero out r11  : used in ATOQ
	xor  r12, r12     # zero out r12  : used in PROCESS_ARRAY
	xor  r13, r13     # zero out r13  : used in PROCESS_ARRAY
	xor  r14, r14     # zero out r14  : used in PROCESS_ARRAY, PROCESS_LIST
	xor  r15, r15     # zero out r15  : used in PROCESS_ARRAY, PROCESS_LIST
	
	mov  QWORD PTR [SUM_POSITIVE], rax
	mov  QWORD PTR [SUM_NEGATIVE], rax
	
	mov  rbx, OFFSET [CALC_DATA_BEGIN]

PARSE:	mov  cl, BYTE PTR [rbx]   # mov the first byte in the data into cl
	                          # we expect this to be an operation character
	cmp  cl, 0
	jz   DONE

IF_AND:	
	cmp  cl, '&'      # if operation == '&'
	jne  ELSE_IF_OR
	add  rbx, 0x8    # update rbx to point to argument	
	call ANDF
	jmp  PARSE

ELSE_IF_OR:
	cmp  cl, '|'
	jne  ELSE_IF_SUM
        add  rbx, 0x8     # update rbx to point to argument
	call ORF
	jmp  PARSE
	
ELSE_IF_SUM:
	cmp  cl, 'S'
	jne  ELSE_IF_UPPER
	add  rbx, 0x8
	call SUM
	jmp  PARSE
	
ELSE_IF_UPPER:	
	cmp  cl, 'U'
	jne  ELSE_IF_ATOQ
	add  rbx, 0x8    # update rbx to point to argument
	call UPPER
	jmp  PARSE
	
ELSE_IF_ATOQ:
	cmp  cl, 'I'
	jne  ELSE_IF_ARRAYSUM
	add  rbx, 0x8
	call ATOQ
	jmp  PARSE
	
ELSE_IF_ARRAYSUM:	
	cmp  cl, 'a'
	jne  ELSE_IF_LISTSUM
	add  rbx, 0x8
	call ARRAYSUM
	jmp  PARSE
	
ELSE_IF_LISTSUM:
	cmp  cl, 'l'
	jne  ELSE_IF_ARRAY
	add  rbx, 0x8
	call LISTSUM
	jmp  PARSE
	
ELSE_IF_ARRAY:
	cmp  cl, 'A'
	jne  ELSE_LIST
	inc  rbx
	call PROCESS_ARRAY
	jmp  PARSE
	
ELSE_LIST:	
	cmp  cl, 'L'
	jne  DONE
	inc  rbx
	call PROCESS_LIST
	jmp  PARSE
	
	add  rbx, 8   # default behaviour is to move to the next
	              # 8 bytes and look for a command character
	jmp PARSE
	
DONE:
	call writeValues
	call writeData
	mov rdi, 0
	call exit

	# expects rdi to have return value
exit:	
	mov rax, 60
	syscall 
	# should never get here

	# assumes rax has result
writeValues:
	push rsi   # spill
	push rdx   # spill
	push rax   # buffer rax  value

	# write(&rax, 8)
	mov rsi, rsp
	mov rdx, 8
	call write

	# write(&SUM_POSTIVE, 8) 
	mov rsi, OFFSET SUM_POSITIVE
	mov rdx, 8
	call write

	# write(&SUM_NEGATIVE, 8) 
	mov rsi, OFFSET SUM_NEGATIVE
	mov rdx, 8
	call write
		
	pop rax
	pop rsi
	pop rdx
	
	ret

	# inputs: None
	# outputs: None
writeData:
	push rsi
	push rdx
	
	mov rsi, OFFSET CALC_DATA_BEGIN
	mov rdx, OFFSET CALC_DATA_END
	sub rdx, rsi
	call write
	
	pop rdx
	pop rsi
	ret

	# Inputs: rsi=buf, rdx=n
	# Outputs: none
	# being consevative and pushing all the registers we clobber
	# rcx is implicity clobbered by syscall (return pc is placed in rcx by syscall instruction)
	# r11 is implicity clobbered by syscall (current rflags is place in R11 by syscall instruction)
write:
	push rax
	push rcx
	push r11
	push rdi
	

	mov rdi, 1   # rdi = stdout
	mov rax, 1   # rax = write syscall num
	syscall

	pop rdi
	pop r11
	pop rcx
	pop rax
	ret
	
	.global opToAddr
opToAddr:
	# set r15 to address of code that implements the operation
        # if not supported operation then skip
	xor   r15, r15          # operation code addr = 0
 	# conditional mov can not load 64bit value so
	# we use values from JMP TABLE to load value
        cmp   cl, '&'                                     # if cl=='&' 
	cmove r15, QWORD PTR [JMP_TABLE + (AND_IDX * 8)]  #   r15 = AND
	cmp   cl, '|'                                     # if cl=='|'
	cmove r15, QWORD PTR [JMP_TABLE + (OR_IDX * 8) ]  #   r15 = OR
	cmpb  cl, 'S'                                     # if cl=='S'
	cmove r15, QWORD PTR [JMP_TABLE + (SUM_IDX * 8)]  #   r15 = SUM
	cmpb  cl, 'U'                                     # if cl=='U'
	cmove r15, QWORD PTR [JMP_TABLE + (UPPER_IDX * 8)]#   r15 = UPPER
	cmpb  cl, 'I'                                     # if cl=='I'
	cmove r15, QWORD PTR [JMP_TABLE + (ATOQ_IDX * 8)] #   r15 = ATOQ
	ret

	.section .rodata
	
	.align 8
JMP_TABLE:
	.equ  AND_IDX, (. - JMP_TABLE)/8
	.quad ANDF
	.equ  OR_IDX, (. - JMP_TABLE)/8
	.quad ORF
	.equ  SUM_IDX, (. - JMP_TABLE)/8
	.quad SUM
	.equ  UPPER_IDX, (. - JMP_TABLE)/8
	.quad UPPER
	.equ  ATOQ_IDX, (. - JMP_TABLE)/8
        .quad ATOQ
	
