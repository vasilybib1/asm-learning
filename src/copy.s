# COPY - MERGE HELPER FUNCTION 
# INPUTS: (*from, *to, start, size)
# PURPOSE: copies from one array to other given start ind and size 

# CONSTANTS
# passed variables 
.equ ST__SIZE, 8
.equ ST__START_IND, 12
.equ ST__TO, 16
.equ ST__FROM, 20

.globl copy
.type copy, @function
copy:
  #function prologue start
  pushl %ebp
  movl %esp, %ebp
  #function prologue end

  # set up 
  movl $0, %edi
  movl ST__FROM(%ebp), %eax
  movl ST__TO(%ebp), %ebx

copy_loop:
  # while size - 1 != 0
  movl ST__SIZE(%ebp), %ecx
  subl %edi, %ecx
  je copy_end

  # to[i] = from[i]
  movl ST__START_IND(%ebp), %esi
  addl %edi, %esi
  movl (%eax, %esi, 4), %edx
  movl %edx, (%ebx, %edi, 4)
  incl %edi
  jmp copy_loop

copy_end:
  # function epilogue start
  movl %ebp, %esp
  popl %ebp
  ret
  # function epilogue end
