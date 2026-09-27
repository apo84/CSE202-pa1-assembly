.global gcd
# a in %edi, b in %esi; result in %eax
gcd:
  cmpl $0, %esi
  je .Ldone
  movl %edi, %eax  # eax = a
  cltd             # convert long to double-long, edx:eax
  idiv %esi        # edx = a % b; eax = a / b
  movl %esi, %edi  # edi (a) = b
  movl %edx, %esi  # esi (b) = a % b
  jmp gcd

.Ldone:
  movl %edi, %eax   # return a
  ret


# greatest common divisor via Euclid's algorithm (recursive)
# int gcd(int a, int b){
#     if(b == 0)
#         return a;
#     /* recursive call */
#     return gcd(b, a % b);
# }
