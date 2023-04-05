	.intel_syntax noprefix

	.section .text
	.global myfunc2
myfunc2:
	mov rax, 42
	call myfunc1
	mov QWORD PTR [myvar1], rax
