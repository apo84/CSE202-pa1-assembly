.global mult7div8
# a in %dil (signed char), overflow pointer in %rsi; result in %eax
mult7div8:
  movsbl %dil, %eax        # eax = (int) a, sign-extended from 1 byte to long
  imull $7, %eax, %ecx     # ecx = 7*a
  movb %cl, %r8b           # r8b = mult = (char)(7*a) truncated to 1 byte
  cmpb $0, %dil            # compare a to 0
  jg .Apositive
  jl .Anegative
  jmp .NoOverflow          # a == 0 -> mult == 0, overflow imposible

.Apositive:
  cmpb $0, %r8b            # compare mult to 0
  jl .Overflow             # a > 0 and mult < 0, overflow = 1
  jmp .NoOverflow

.Anegative:
  cmpb $0, %r8b
  jg .Overflow             # a < 0 and mult > 0, overflow = 1
  jmp .NoOverflow

.Overflow:
  movb $1, (%rsi)           # set memory value for overflow pointer = 1
  jmp .Divide

.NoOverflow:
  movb $0, (%rsi)          # set memory value for overflow pointer = 0

.Divide:
  movsbl %r8b, %eax        # sign-extend mult to 32 bits for division
  cltd                     # convert long to double-long, edx:eax
  movl $8, %ecx      
  idivl %ecx               # eax = mult / 8
  ret


# char mult7div8(char a, char *overflow){
#     char mult = (7 * a);
#     if(a > 0 && mult < 0 || a < 0 && mult > 0)
#       *overflow = 1;
#     else
#       *overflow = 0;
#     return mult/8;
# }
