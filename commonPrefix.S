.global commonPrefix
# a in %rdi, b in %rsi; result (prefix length) in %eax
commonPrefix:
  movl $0, %ecx            # n = 0

.Lwhile:
  movslq %ecx, %rax          # n to 64 bits for indexing
  movb (%rdi,%rax,1), %r8b   # r8b = a[n (rdi + 1*n)] - characters so use byte register and only scale n by 1
  cmpb $0, %r8b
  je .Ldone                  # if a[n] == null for null-terminated string exit loop

  movb (%rsi,%rax,1), %r9b   # r9b = b[n (rdi + 1*n)]
  cmpb %r9b, %r8b
  jne .Ldone                 # if a[n] != b[n] exit loop

  incl %ecx           # n++
  jmp .Lwhile

.Ldone:
  movl %ecx, %eax     # return n
  retq


# length of the longest common prefix of two null-terminated strings
# int commonPrefix(char *a, char *b){
#     int n = 0;
#     while(a[n] && a[n] == b[n])
#         n++;
#     return n;
# }
