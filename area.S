.globl area
# a in %edi, b in %esi, c in %edx; result in %eax
area:
  movl %edi, %eax
  addl %esi, %eax
  addl %edx, %eax
  sarl $1, %eax        # eax = p = (a+b+c) >> 1
  
  movl %eax, %r10d
  subl %edi, %r10d       # r10d = p - a
  movl %eax, %r11d
  subl %esi, %r11d      # r11d = p - b
  movl %eax, %r12d
  subl %edx, %r12d      # r12d = p - c
  
  imull %r10d, %eax       # eax = p*(p-a)
  imull %r11d, %eax       # eax *= (p-b)
  imull %r12d, %eax       # eax *= (p-c)
  
  movl %eax, %edi        # argument for r_sqrt
  call r_sqrt            # eax now holds the return value
  ret

.globl r_sqrt
# x in %edi; result in %eax
r_sqrt:
  cmpl $0, %edi
  jge .Lnotneg
  movl $-1, %eax        # return -1 if x < 0
  ret
.Lnotneg:
  cmpl $2, %edi
  jge .Lrecurse
  movl %edi, %eax
  ret
.Lrecurse:
  pushq %rbx            # for each loop save x
  movl %edi, %ebx       # save x, since %edi is caller-saved across the call
  sarl $2, %edi         # edi = x >> 2
  call r_sqrt           # eax = r_sqrt(x >> 2)
  sall $1, %eax         # eax = small_cand = r_sqrt(x>>2) << 1
  movl %eax, %ecx       # ecx = small_cand for possible return
  leal 1(%eax), %edx    # edx = large_cand = small_cand + 1
  movl %edx, %r8d
  imull %r8d, %r8d      # r8d = large_cand * large_cand
  cmpl %ebx, %r8d
  jg .Lreturnsmall      # if large_cand * large_cand > x, return small_cand
  movl %edx, %eax       # eax = large_cand
  jmp .Ldone
.Lreturnsmall:
  movl %ecx, %eax       # eax = small_cand
.Ldone:
  popq %rbx
  ret

# int area(int a, int b, int c){
#     int p = (a + b + c)/2;
#     p = p * (p-a) * (p-b) * (p-c);
#     return sqrt(p);
# }
# calculate recursively the square root of an int (in C)
# int r_sqrt(int x){
#    if(x < 0)
#        return -1;
#    if (x < 2)
#        return x;
#   /* recursive call */
#    int small_cand = r_sqrt(x >> 2) << 1;
#    int large_cand = small_cand + 1;
#    if (large_cand * large_cand > x)
#        return small_cand;
#    else
#        return large_cand;
# }
