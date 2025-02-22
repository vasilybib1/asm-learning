# MERGESORT FUNCTION
# INPUTS: (*data_buffer_first, *data_buffer_last)
# PURPOSE: sorts an array of integers

.section .bss
# temp copy buffer
.equ BUFF_TEMP_LEN, 500
.lcomm BUFF_TEMP, BUFF_TEMP_LEN

.section .text
# CONSTANTS 
# stack position
.equ ST_LAST_INDEX, 8
.equ ST_FIRST_INDEX, 12

.globl mergesort
.type mergesort, @function
mergesort:
  # function prologue start
  pushl %ebp
  movl %esp, %ebp
  # function prologue end

mergesort_loop:
  # while first < last
  movl ST_FIRST_INDEX(%ebp), %ebx
  movl ST_LAST_INDEX(%ebp), %eax
  subl %ebx, %eax 
  cmpl $4, %eax
  jle mergesort_done

  # find the mid point (eax)
  movl $2, %ecx
  movl $0, %edx
  divl %ecx 
  movl $0xFFFFFFF8, %ecx
  movl ST_FIRST_INDEX(%ebp), %ebx
  addl %ebx, %eax
  andl %ecx, %eax

  # mergesort(first, mid)
  movl ST_FIRST_INDEX(%ebp), %ebx
  pushl %ebx
  pushl %eax
  call mergesort
  popl %eax
  addl $4, %esp
  
  # mergesort(mid+1, last)
  addl $4, %eax
  pushl %eax
  movl ST_LAST_INDEX(%ebp), %edx
  pushl %edx
  call mergesort
  addl $4, %esp
  popl %eax

  # call merge (first, mid, last)
  movl ST_FIRST_INDEX(%ebp), %ebx
  pushl %ebx
  subl $4, %eax
  pushl %eax
  movl ST_LAST_INDEX(%ebp), %ebx
  pushl %ebx
  call merge
  addl $12, %esp

mergesort_done:
  # function epilogue start
  movl %ebp, %esp
  popl %ebp
  ret
  # function epilogue end

