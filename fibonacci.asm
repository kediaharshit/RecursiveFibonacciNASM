%include 'io.inc'

	global _start

	section .bss
in: resb '10'				;buffer reserve of max capacity 

	section .data
x: 	dq  10

	section .text
fibo:
		cmp	rdi, 1			;base cases
		jg .rec
		mov rax, rdi
		ret
	.rec:					;recursive if n>1
		push rdi
		sub rdi, 1			;rdi = n-1
		call fibo			;rax = fibo(n-1)
		pop rdi				;rdi = n
		mov r9, rax			;r9 = fibo(n-1)
		
		push r9				;to avoid altering value during recursive calls
		push rdi		
		sub rdi, 2			;rdi = n-2
		call fibo			;rax = fibo(n-2)
		pop rdi				;rdi = n
		mov r10, rax		;r10 has fib(n-2)
		pop r9				;r = fibo(n-1)

		mov rax, r9			
		add rax, r10
		ret

_start:
		mov rdi, in 		;buffer pointer as argument 1
		mov rsi, 10			;maximum length as argument 2
		call read_word		;read as string from STDIN

		mov rdi, rax		;move string address as first argument
		call parse_uint		;call to get integer value of input 

		mov r13, rax		;rax has number given as input
		mov r12, 0			;counter

	.loop:
		
		cmp r12, r13		;compare with input number
		je .end				;print upto fibo(n-1)
		
		mov rdi, r12		
		call fibo			;returns fibo(i) at rax

		mov rdi, rax		;send fibo(i) as output in STDOUT
		call print_uint

		inc r12				;increment counter
		jmp .loop
	.end:

		mov rdi, 0
		call exit