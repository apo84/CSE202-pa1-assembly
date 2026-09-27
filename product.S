.global product
# a in %rdi, b in %rsi, c in %rdx, size in %ecx
product:
  movl $0, %r8d            # r8d = i = 0

.Lloop:
  cmpl %ecx, %r8d         # compare i, size
  jge .Done              # if i >= size, exit loop

  movslq %r8d, %r9           # extend i to 64 bits for indexing
  movss (%rdi,%r9,4), %xmm0  # xmm0 = a[i] - scale i by 4 since float = 4 bytes
  movss (%rsi,%r9,4), %xmm1  # xmm1 = b[i]
  mulss %xmm1, %xmm0         # xmm0 = a[i] * b[i]
  movss %xmm0, (%rdx,%r9,4)  # c[i] = xmm0

  addl $1, %r8d             # i++
  jmp .Lloop

.Done:
  ret

# Product of two vectors in C
# void product(float *a, float *b, float *c, unsigned size){
#    for(int i=0; i<size; i++){
#        c[i] = a[i] * b[i];
#    }
# }
