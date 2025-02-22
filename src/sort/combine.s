# COMBINE - MERGE HELPER FUNCTION 
# INPUTS: (*data, *left, *right, left_len, right_len, first_ind)
# PURPOSE: given two arrays combine into one sorted array

# CONSTANS
# passed variables 
.equ ST__FIRST_IND, 8
.equ ST__RIGHT_LEN, 12
.equ ST__LEFT_LEN, 16
.equ ST__RIGHT, 20
.equ ST__LEFT, 24
.equ ST__ARR, 28
# local variables 
.equ ST__ARR_INDEX, -4
# local var size
.equ ST__SIZE_RESERVE, 4

.globl combine
.type combine, @function
combine:
  #function prologue start
  pushl %ebp
  movl %esp, %ebp
  subl $ST__SIZE_RESERVE, %esp
  #function prologue end

  # set up
  movl $0, %edi
  movl $0, %esi
  movl ST__FIRST_IND(%ebp), %eax
  movl %eax, ST__ARR_INDEX(%ebp)

combine_main_loop:
  # while i (edi) < left_len
  movl ST__LEFT_LEN(%ebp), %eax
  subl %edi, %eax
  jle combine_right_loop

  # while j (esi) < right_len
  movl ST__RIGHT_LEN(%ebp), %eax
  subl %esi, %eax
  jle combine_left_loop

  # left[i] < right[j] ?
  movl ST__LEFT(%ebp), %eax
  movl (%eax, %edi, 4), %ecx
  movl ST__RIGHT(%ebp), %eax
  movl (%eax, %esi, 4), %edx
  subl %ecx, %edx
  jl combine_left_large

  # right >= left   arr[ind] = right[j]
  movl ST__ARR(%ebp), %eax 
  movl ST__ARR_INDEX(%ebp), %ebx
  movl ST__RIGHT(%ebp), %ecx 
  movl (%ecx, %esi, 4), %edx
  movl %edx, (%eax, %ebx, 4)
  incl %esi
  incl %ebx
  movl %ebx, ST__ARR_INDEX(%ebp)
  jmp combine_main_loop

combine_left_large:
  # left > right   arr[ind] = left[i]
  movl ST__ARR(%ebp), %eax
  movl ST__ARR_INDEX(%ebp), %ebx
  movl ST__LEFT(%ebp), %ecx
  movl (%ecx, %edi, 4), %edx
  movl %edx, (%eax, %ebx, 4)
  incl %edi
  incl %ebx
  movl %ebx, ST__ARR_INDEX(%ebp)
  jmp combine_main_loop

combine_left_loop:
  # while (i < left_len) move from left to original 
  movl ST__LEFT_LEN(%ebp), %eax 
  subl %edi, %eax 
  jle combine_end

  # arr[ind] = left[i]
  movl ST__ARR(%ebp), %eax 
  movl ST__ARR_INDEX(%ebp), %ebx
  movl ST__LEFT(%ebp), %ecx 
  movl (%ecx, %edi, 4), %edx
  movl %edx, (%eax, %ebx, 4)
  incl %edi
  incl %ebx
  movl %ebx, ST__ARR_INDEX(%ebp)
  jmp combine_left_loop

combine_right_loop:
  # while (j < right_len) move from right to original 
  movl ST__RIGHT_LEN(%ebp), %eax 
  subl %esi, %eax
  jle combine_end

  # arr[ind] = right[j]
  movl ST__ARR(%ebp), %eax 
  movl ST__ARR_INDEX(%ebp), %ebx
  movl ST__RIGHT(%ebp), %ecx 
  movl (%ecx, %esi, 4), %edx
  movl %edx, (%eax, %ebx, 4)
  incl %esi
  incl %ebx
  movl %ebx, ST__ARR_INDEX(%ebp)
  jmp combine_right_loop

combine_end:
  # function epilogue start
  addl $ST__SIZE_RESERVE, %esp
  movl %ebp, %esp
  popl %ebp
  ret
  # function epilogue end
