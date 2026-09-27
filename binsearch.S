.global binsearch
# arr in %rdi, n in %esi, target in %edx
binsearch:
  movl $0, %r10d           # r10d = lo = 0
  movl %esi, %r11d         # r11d = n  (into 32 bit int register)
  subl $1, %r11d           # r11d = hi = n - 1
  movl %edx, %r12d         # move target to safe register since cltd later

.Lwhile:
  cmpl %r11d, %r10d        # compare lo, hi
  jg .Lnotfound            # if lo > hi, exit loop -> not found

  movl %r11d, %eax         # eax = hi
  subl %r10d, %eax         # eax = hi - lo
  cltd                     # sign-extend eax into edx:eax for idiv
  movl $2, %ecx
  idivl %ecx               # eax = (hi - lo) / 2 (quotient stored in eax, remainder edx)
  addl %r10d, %eax         # eax = lo + (hi-lo)/2 = mid
  movl %eax, %ecx          # ecx = mid

  movslq %ecx, %r8          # sign-extend mid to 64 bits for indexing
  movl (%rdi,%r8,4), %r9d   # r9d = arr[mid] - (array pointer + 4(int)*mid(location in array))

  cmpl %r12d, %r9d       # arr[mid] - target
  je .Lfound             # if arr[mid] == target, return mid

  jl .Lmoveright         # if arr[mid] < target, move right

  movl %ecx, %r11d       # else: hi = mid - 1
  subl $1, %r11d
  jmp .Lwhile

.Lmoveright:
  movl %ecx, %r10d   # lo = mid + 1
  addl $1, %r10d
  jmp .Lwhile

.Lfound:
  movl %ecx, %eax          # return mid
  ret

.Lnotfound:
  movl $-1, %eax           # return -1
  ret

# binary search over a sorted int array; returns the index of target, or -1
# int binsearch(int *arr, unsigned n, int target){
#     int lo = 0;
#     int hi = (int)n - 1;
#     while(lo <= hi){
#         int mid = lo + (hi - lo) / 2;
#         if(arr[mid] == target)
#             return mid;
#         else if(arr[mid] < target)
#             lo = mid + 1;
#         else
#             hi = mid - 1;
#     }
#     return -1;
# }
