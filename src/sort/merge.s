# MERGE - MERGESORT HELPER FUNCTION
# INPUTS: (*data_buffer_first, *data_buffer_mid, *data_buffer_last)
# PURPOSE: function to merge two sorted arrays

.section .text
# CONSTANTS
# stack position
.equ ST__SIZE_RESERVE, 24
# local variables
.equ ST__LEFT_START, -4
.equ ST__LEFT_END, -8
.equ ST__LEFT_LEN, -12
.equ ST__RIGHT_START, -16
.equ ST__RIGHT_END, -20
.equ ST__RIGHT_LEN, -24
# passed variables
.equ ST__LAST_INDEX, 8
.equ ST__MID_INDEX, 12
.equ ST__FIRST_INDEX, 16

.globl merge
.type merge, @function
merge:
  #function prologue start
  pushl %ebp
  movl %esp, %ebp
  subl $ST__SIZE_RESERVE, %esp
  #function prologue end

  # left len = mid - left + 1
  movl ST__FIRST_INDEX(%ebp), %eax
  movl ST__MID_INDEX(%ebp), %ebx
  subl %eax, %ebx
  addl $4, %ebx
  movl %ebx, ST__LEFT_LEN(%ebp)

  # right len = last - mid
  movl ST__LAST_INDEX(%ebp), %eax
  movl ST__MID_INDEX(%ebp), %ebx
  subl %ebx, %eax 
  movl %eax, ST__RIGHT_LEN(%ebp)

  # padding for debug
  movl $0xFFFFFFFF, %eax
  pushl %eax
  
  # allocate space and save pointers for left
  subl $4, %esp
  movl %esp, ST__LEFT_START(%ebp)
  movl ST__LEFT_LEN(%ebp), %eax
  subl $4, %eax
  subl %eax, %esp
  movl %esp, ST__LEFT_END(%ebp)

  # padding for debug
  movl $0xFFFFFFFF, %eax
  pushl %eax

  # allocate space and save pointers for left
  subl $4, %esp
  movl %esp, ST__RIGHT_START(%ebp)
  movl ST__RIGHT_LEN(%ebp), %eax
  subl $4, %eax
  subl %eax, %esp
  movl %esp, ST__RIGHT_END(%ebp)

  # copy (first -> mid) to left
  # end pointer because stack is reversed 
  movl ST__FIRST_INDEX(%ebp), %eax
  pushl %eax
  movl ST__LEFT_END(%ebp), %eax 
  pushl %eax
  movl ST__LEFT_LEN(%ebp), %eax
  pushl %eax
  call copy
  addl $12, %esp

  # copy (mid+1 -> last) to right
  # end pointer because stack is reversed 
  movl ST__MID_INDEX(%ebp), %eax
  addl $4, %eax
  pushl %eax
  movl ST__RIGHT_END(%ebp), %eax
  pushl %eax
  movl ST__RIGHT_LEN(%ebp), %eax
  pushl %eax
  call copy
  addl $12, %esp

  # call combine (left_len, *left, right_len, *right, *original)
  # end pointer passed cause stack is reversed

  # size/4 -> convert from pointer math to logic math
  movl ST__LEFT_LEN(%ebp), %eax
  sarl $2, %eax
  pushl %eax
  movl ST__LEFT_END(%ebp), %eax
  pushl %eax
  # size/4 -> convert from pointer math to logic math
  movl ST__RIGHT_LEN(%ebp), %eax
  sarl $2, %eax
  pushl %eax
  movl ST__RIGHT_END(%ebp), %eax
  pushl %eax
  movl ST__FIRST_INDEX(%ebp), %eax
  pushl %eax
  call combine
  addl $20, %esp

merge_end:
  # free up array space
  movl ST__LEFT_LEN(%ebp), %eax
  addl %eax, %esp
  movl ST__RIGHT_LEN(%ebp), %eax
  addl %eax, %esp

  # removing padding for debug
  addl $8, %esp

  # function epilogue start
  addl $ST__SIZE_RESERVE, %esp
  movl %ebp, %esp
  popl %ebp
  ret
  # function epilogue end



# ===================================================================
# COMBINE - MERGE HELPER FUNCTION
# INPUTS (left_size, *left, right_size, *right, *first)
# PURPOSE: given two arrays combine them into one sorted 

# CONSTANTS
# pased variables 
.equ ST__ARR, 8
.equ ST__RIGHT, 12
.equ ST__RIGHT_SIZE, 16
.equ ST__LEFT, 20
.equ ST__LEFT_SIZE, 24
# local variables 
.equ ST__ARR_INDEX, -4

.globl combine
.type combine, @function
combine:
  #function prologue start
  pushl %ebp
  movl %esp, %ebp
  subl $4, %esp
  movl ST__ARR(%ebp), %eax # debug
  #function prologue end

  # set variables counters
  movl $0, %edi
  movl $0, %esi
  movl $0, ST__ARR_INDEX(%ebp)

combine_main_loop:
  # while (i < left_len)
  movl ST__LEFT_SIZE(%ebp), %eax
  subl %edi, %eax
  jle combine_right_loop

  # while (j < right_len)
  movl ST__RIGHT_SIZE(%ebp), %eax
  subl %esi, %eax
  jle combine_left_loop

  # left < right ?
  movl ST__LEFT(%ebp), %eax
  movl (%eax, %edi, 4), %ecx
  movl ST__RIGHT(%ebp), %eax
  movl (%eax, %esi, 4), %edx
  subl %ecx, %edx
  jl combine_left_large
  
  # right >= left
  # arr[ind] = right[j]
  movl ST__ARR(%ebp), %eax
  movl ST__ARR_INDEX(%ebp), %ebx
  movl %edx, (%eax, %ebx, 4)
  incl %esi
  incl %ebx
  movl %ebx, ST__ARR_INDEX(%ebp)
  jmp combine_main_loop
  
combine_left_large:
  # left > right
  # arr[ind] = left[i]
  movl ST__ARR(%ebp), %eax
  movl ST__ARR_INDEX(%ebp), %ebx
  movl %ecx, (%eax, %ebx, 4)
  incl %edi
  incl %ebx
  movl %ebx, ST__ARR_INDEX(%ebp)
  jmp combine_main_loop

combine_left_loop:
  # while (i < left_len) move from left to original
  movl ST__LEFT_SIZE(%ebp), %eax
  subl %edi, %eax
  jle combine_end
  
  # arr[ind] = left[i]
  # i++ ind++
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
  movl ST__RIGHT_SIZE(%ebp), %eax
  subl %esi, %eax
  jle combine_end

  # arr[ind] = left[i]
  # i++ ind++
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
  movl ST__ARR(%ebp), %eax #debug
  # function epilogue start
  addl $4, %esp
  movl %ebp, %esp
  popl %ebp
  ret
  # function epilogue end



# ===================================================================
# COPY - MERGE HELPER FUNCION 
# INPUTS: (*from, *to, size)
# PURPOSE: copies from one array to other given two pointers and size

# CONSTANTS
# passed variables
.equ ST__SIZE, 8
.equ ST__TO, 12
.equ ST__FROM, 16

.globl copy
.type copy, @function
copy:
  #function prologue start
  pushl %ebp
  movl %esp, %ebp
  #function prologue end
  
  # reg set up
  movl $0, %edi
  movl ST__FROM(%ebp), %ebx
  movl ST__TO(%ebp), %ecx

copy_loop:
  # while size - i != 1
  movl ST__SIZE(%ebp), %eax
  sarl $2, %eax
  subl %edi, %eax
  cmpl $0, %eax
  je copy_end

  # to[i] = from[i]
  movl (%ebx, %edi, 4), %eax
  movl %eax, (%ecx, %edi, 4)
  incl %edi
  jmp copy_loop

copy_end:
  # function epilogue start
  movl %ebp, %esp
  popl %ebp
  ret
  # function epilogue end
