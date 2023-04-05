	.intel_syntax noprefix

	.section .text

	.global ATOQ
ATOQ:
	# INPUTS: rax -> x
	#         rbx -> &str address of where a string is located
	# OUTPUTS: x = x + ascii to quad of string
	#          update postive and negative sum with ascii to quad of string 		

        mov  rdx, QWORD PTR [%rbx] # rdx = &str load address of string 
	test rdx, rdx              # if NULL 
	jz   ATOQ_EXIT             #   then exit
        xor  rdi, rdi           # rdi = i = 0  : tracks position in string 
                                # r8 tmp -- r8b character processing
                                #        -- r8  byte value of digit
        xor  r9, r9           # r9  = num  = 0
        mov  r10, 1           # r10 = scale = 1
	or   r11, r11         # r11 = isNegative = 0

	cmp  BYTE PTR [rdx], '-' # if str[0] != '-'	
	jne  ATOQ_SCAN_TO_END     # then start processing charadters

        not  r11              # isNeg = ~0
        incq rdx              # advance rbxskip '-' 

ATOQ_SCAN_TO_END:
        mov  r8b, BYTE PTR [rdx + rdi] #  tmp = str[i]
        cmp  r8b, '0'                  #  if tmp < '0'
        jb   ATOQ_CALC_NUM             #  found non-digit character must be done start processing
        cmp  r8b, '9'                  #  if tmp > '9'
        ja   ATOQ_CALC_NUM             #  found non-digit character must be done start processing
	inc  rdi                       #  found a digit keeping going till end of digits
	jmp  ATOQ_SCAN_TO_END       
	
	       # at this point i holds the index of the first non-digit ascii (this could be 0)
ATOQ_CALC_NUM:
        test rdi, rdi        # if we did not find any digits we are done (num=0 at this point)
        jz ATOQ_EXIT
	# work backwards to calculate number as a sum of factors of 10
ATOQ_WHILE:                           # while begin
        orq  r8, r8                   #  tmp = 0 (clear out all bits of r8)
        dec  rdi                      #  i = i - 1                           : next position 
        mov  r8b, BYTE PTR [rdx + rdi] # tmp = str[i]
        #   num += v * 10^i	   
        sub  r8b, '0'                  #  convert ascii digit to binary number: tmp = tmp - '0' 
	imul r8, r10                   #  tmp = scale * tmp          : scale by power of 10
	add  r9, r8                    #  num = num + tmp            : accumulate into number 
	imul r10, 10                   #  scale = scale * 10         : scale up by 10 for next digit position
        test rdi, rdi            #  if i=0                              : if i=0 we got to thefirst digit
        jz ATOQ_DONE               #    goto done                         :
        jmp  ATOQ_WHILE         # goto while begin                     
	
ATOQ_DONE:
        test r11,r11         # if isNeg == 0
        jz  ATOQ_POSITIVE       #   then goto positive
	                                # else
	neg  r9                #   num = -num 
	addq QWORD PTR [SUM_NEGATIVE], r9  #   accumulate in negatives sum_neg += num
	jmp ATOQ_EXIT           #   goto exit
ATOQ_POSITIVE:                          # positive 
	addq QWORD PTR [SUM_POSITIVE], r9  #   accumulate in positives sum_pos += num
ATOQ_EXIT:                              # exit
	addq rax, r9          #   add value to rax
	addq rbx, 8         #   advance rbx
	ret                     #   return 	

	
				  

