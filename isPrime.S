.global isPrime
# n in %edi; result in %eax (1 = prime, 0 = not prime)
isPrime:
  cmpl $2, %edi
  jl .Notprime
  movl %edi, %eax
  cltd               # convert long to double-long, edx:eax
  movl $2, %ecx
  idiv %ecx          # edx = n % 2; eax = n / 2
  cmpl $0, %edx
  je .Even           # if remainder of n/2 == 0, # is even
  movl $3, %ecx      # ecx = i = counter

.OddLoop:
  movq %rcx, %rax    # rax = i
  imul %rcx          # rax = i*i
  cmp %rdi, %rax     # n - i*i
  jg .Prime          # loop termination condition i*i > n
  movl %edi, %eax    # eax = n
  cltd               # convert long to double-long, edx:eax
  idiv %rcx          # edx = n % i; eax = n / i
  cmpl $0, %edx
  je .Notprime       # if remainder of n/i == 0, # is not prime
  addl $2, %ecx      # rcx = i + 2
  jmp .OddLoop

.Even:
  cmp $2, %edi
  je .Prime            # if quotient of n/2 == 0, n == 2
  movl $0, %eax      # return 0 since even != 2
  ret

.Prime:
  movl $1, %eax      # n is prime so return 1
  ret

.Notprime:
  movl $0, %eax
  ret


# int isPrime(int n){
#     if(n < 2)
#         return 0;
#     if(n % 2 == 0)
#         return n == 2;
#     /* only test odd divisors i while i*i <= n */
#     for(int i = 3; i * i <= n; i += 2){
#         if(n % i == 0)
#             return 0;
#     }
#     return 1;
# }
