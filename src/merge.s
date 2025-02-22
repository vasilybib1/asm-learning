# MERGE - MERGESORT HELPER FUNCTION
# INPUTS (*data, first_ind, mid_left, last_ind)
# PURPOSE: function to merge two sorted arrays 

.section .text
# CONSTANTS 
# stack positions 
.equ ST__SIZE_RESERVE, 16
# local variables
.equ ST__LEFT, -4
.equ ST__LEFT_LEN, -8
.equ ST__RIGHT, -12
.equ ST__RIGHT_LEN, -16
# passed variables
.equ ST__LAST_IND, 8
.equ ST__MID_IND, 12
.equ ST__FIRST_IND, 16
.equ ST__DATA, 20


.globl merge
.type merge, @function
merge:
  #function prologue start
  pushl %ebp
  movl %esp, %ebp
  subl $ST__SIZE_RESERVE, %esp
  #function prologue end

  # left len = mid - first + 1
  movl ST__FIRST_IND(%ebp), %ebx
  movl ST__MID_IND(%ebp), %eax
  subl %ebx, %eax
  incl %eax
  movl %eax, ST__LEFT_LEN(%ebp)

  # right len = last - mid 
  movl ST__LAST_IND(%ebp), %eax
  movl ST__MID_IND(%ebp), %ebx
  subl %ebx, %eax
  movl %eax, ST__RIGHT_LEN(%ebp)

  # padding for debug
  movl $0xFFFFFFFF, %eax
  pushl %eax

  # allocate space for left 
  movl ST__LEFT_LEN(%ebp), %eax
  imull $4, %eax
  subl %eax, %esp
  movl %esp, ST__LEFT(%ebp)

  # padding for debug
  movl $0xFFFFFFFF, %eax
  pushl %eax

  # allocate space for right
  movl ST__RIGHT_LEN(%ebp), %eax
  imull $4, %eax
  subl %eax, %esp
  movl %esp, ST__RIGHT(%ebp)

  # copy (first -> mid) to left
  movl ST__DATA(%ebp), %eax
  pushl %eax
  movl ST__LEFT(%ebp), %eax
  pushl %eax 
  movl ST__FIRST_IND(%ebp), %eax
  pushl %eax
  movl ST__LEFT_LEN(%ebp), %eax
  pushl %eax
  call copy
  addl $16, %esp
  
  # copy (mid + 1 -> last) to right
  movl ST__DATA(%ebp), %eax
  pushl %eax
  movl ST__RIGHT(%ebp), %eax
  pushl %eax 
  movl ST__MID_IND(%ebp), %eax
  incl %eax
  pushl %eax
  movl ST__RIGHT_LEN(%ebp), %eax
  pushl %eax
  call copy
  addl $16, %esp

  # merge (data, left, right, left_len, right_len, first_ind)
  movl ST__DATA(%ebp), %eax
  pushl %eax
  movl ST__LEFT(%ebp), %eax
  pushl %eax
  movl ST__RIGHT(%ebp), %eax
  pushl %eax
  movl ST__LEFT_LEN(%ebp), %eax
  pushl %eax
  movl ST__RIGHT_LEN(%ebp), %eax
  pushl %eax
  movl ST__FIRST_IND(%ebp), %eax
  pushl %eax
  call combine
  addl $24, %esp

merge_end:
  # free up space 
  movl ST__LEFT_LEN(%ebp), %eax
  imull $4, %eax
  addl %eax, %esp
  movl ST__RIGHT_LEN(%ebp), %eax
  imull $4, %eax
  addl %eax, %esp

  # remove padding for debug
  addl $8, %esp

  # function epilogue start
  addl $ST__SIZE_RESERVE, %esp
  movl %ebp, %esp
  popl %ebp
  ret
  # function epilogue end
