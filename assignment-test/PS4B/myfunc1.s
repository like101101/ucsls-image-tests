	.intel_syntax noprefix
	.section .data
	.global myvar1
myvar1:
	.quad 0xdeadbeefdeadbeef

	.section .text
	.global myfunc1
myfunc1:
	add rax, QWORD PTR [myvar1]
	ret

	.global _start
_start:
	call myfunc2
	mov rax, 60
	mov rdi, 0
	syscall
