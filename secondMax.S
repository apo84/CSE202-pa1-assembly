.global secondMax
# v1 in %di, v2 in %si, v3 in %dx, v4 in %cx  (signed 16-bit); result in %ax
secondMax:
  cmpw %si, %di
  jl .Lv2bigger
  
  movw %di, %r8w        # if v1 >= v2, first = v1: r8w = first, r9w = second
  movw %si, %r9w        # second = v2
  jmp .Lcheckv3

.Lv2bigger:
  movw %si, %r8w        # if v2 > v1, first = v2
  movw %di, %r9w        # second = v1

.Lcheckv3:
  cmpw %r8w, %dx        # compare first to v3
  jg .Lv3newfirst       # if v3 > first, jump to v3 new first
  cmpw %r9w, %dx
  jg .Lv3newsecond      # if v3 <= first and > second, jump to v3 new second
  jmp .Lcheckv4

.Lv3newfirst:
  movw %r8w, %r9w       # second = first
  movw %dx, %r8w        # first = v3
  jmp .Lcheckv4

.Lv3newsecond:
  movw %dx, %r9w         # second = v3

.Lcheckv4:
  cmpw %r8w, %cx         # compare v4 to first
  jg .Lv4newfirst
  cmpw %r9w, %cx         # compare v4 to second
  jg .Lv4newsecond
  jmp .Ldone

.Lv4newfirst:
  movw %r8w, %r9w        # second = first
  movw %cx, %r8w         # first = v4
  jmp .Ldone

.Lv4newsecond:
  movw %cx, %r9w          # second = v4

.Ldone:
  movw %r9w, %ax          # return second
  ret


# short secondMax(short v1, short v2, short v3, short v4){
#     short first, second;
#     if(v1 >= v2){ first = v1; second = v2; }
#     else        { first = v2; second = v1; }
#     if(v3 > first)       { second = first; first = v3; }
#     else if(v3 > second) { second = v3; }
#     if(v4 > first)       { second = first; first = v4; }
#     else if(v4 > second) { second = v4; }
#     return second;
# }
