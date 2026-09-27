.global sum
# pointer to list head in %rdi; result in %rax
# struct ll { char *name; long value; struct ll *next; }
#   offset 0  : name
#   offset 8  : value
#   offset 16 : next
sum:
  movq $0, %rax         # rax = total = 0
  movq %rdi, %rcx       # rcx = ptr = list

.Lwhile:
  cmpq $0, %rcx
  je .Ldone              # if ptr is null exit loop

  movq 8(%rcx), %rdx     # rdx = ptr->value - offset 8
  addq %rdx, %rax        # total += ptr->value

  movq 16(%rcx), %rcx    # ptr = ptr->next - offset 16
  jmp .Lwhile

.Ldone:
  ret


# sum of the elements of a linkedlist in C
# long sum(struct ll *list){
#    long total = 0;
#    struct ll *ptr = list;
#    while(ptr){
#        total += ptr->value;
#        ptr = ptr->next;
#    }
#    return total;
# }
