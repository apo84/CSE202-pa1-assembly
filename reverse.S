.global reverse
# list in %rdi (array of char*), n in %esi
reverse:
  movl $0, %r8d            # r8d = i = 0
  movl %esi, %eax
  movl $2, %ecx
  cltd                      # convert long to double-long, edx:eax
  idivl %ecx                # eax = n / 2
  movl %eax, %r10d          # r10d = n/2

.Lwhile:
  cmpl %r10d, %r8d          # compare i, n/2
  jge .Ldone                # if i >= n/2 loop terminated

  # temp = list[i]
  movslq %r8d, %r11           # sign-extend i to 64 bits for indexing
  movq (%rdi,%r11,8), %rax    # rax = temp = list[i] - scale 8 because char* is 8 bytes

  # list[n-i-1]
  movl %esi, %ecx
  subl %r8d, %ecx             # ecx = n - i
  subl $1, %ecx               # ecx = n - i - 1
  movslq %ecx, %r12           # sign-extend (n-i-1) to 64 bits for indexing

  movq (%rdi,%r12,8), %rdx    # rdx = list[n-i-1]
  movq %rdx, (%rdi,%r11,8)    # list[i (r11)] = list[n-i-1]
  movq %rax, (%rdi,%r12,8)    # list[n-i-1] = temp

  addl $1, %r8d                # i++
  jmp .Lwhile

.Ldone:
  ret


# void reverse(char **list, unsigned n){
#     unsigned i = 0;
#     while (i < n/2){
#      char *temp = list[i];
#      list[i] = list[n-i-1];
#      list[n-i-1] = temp;
#      i++;
#     }
# }
