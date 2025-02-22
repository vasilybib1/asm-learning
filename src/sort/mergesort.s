# MERGESORT FUNCTION 
# INPUTS: (*data, first_ind, last_ind)
# PURPOSE: sorts an array of integers 

.section .text
# CONSTANTS 
# passed variables 
.equ ST__LAST_IND, 8
.equ ST__FIRST_IND, 12
.equ ST__DATA, 16

.globl mergesort
.type mergesort, @function
mergesort:
  #function prologue start
  pushl %ebp
  movl %esp, %ebp
  #function prologue end

mergesort_loop:
  # while first < last 
  movl ST__LAST_IND(%ebp), %eax
  movl ST__FIRST_IND(%ebp), %ebx
  subl %ebx, %eax
  jle mergesort_end

  # find mid point (eax)
  movl $2, %ecx
  movl $0, %edx
  divl %ecx
  movl ST__FIRST_IND(%ebp), %edx
  addl %edx, %eax

  # mergesort (arr, first, mid)
  movl ST__DATA(%ebp), %ebx
  pushl %ebx
  movl ST__FIRST_IND(%ebp), %ecx
  pushl %ecx
  pushl %eax
  call mergesort
  popl %eax
  addl $8, %esp

  # mergesort (arr, mid+1, last)
  movl ST__DATA(%ebp), %ebx
  pushl %ebx
  incl %eax
  pushl %eax
  movl ST__LAST_IND(%ebp), %ecx
  pushl %ecx
  call mergesort
  addl $4, %esp
  popl %eax
  decl %eax
  addl $4, %esp

  # merge (arr, first, mid, last)
  movl ST__DATA(%ebp), %ebx
  pushl %ebx
  movl ST__FIRST_IND(%ebp), %ecx
  pushl %ecx
  pushl %eax
  movl ST__LAST_IND(%ebp), %edx
  pushl %edx
  call merge
  addl $16, %esp

mergesort_end:
  # function epilogue start
  movl %ebp, %esp
  popl %ebp
  ret
  # function epilogue end
