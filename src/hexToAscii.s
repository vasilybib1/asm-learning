# HEX TO ASCII - HELPER FUNCTION 
# INPUTS: (*data) %eax = hex int
# OUTPUS: data in data buffer and %eax = total bytes wrote
# PURPOSE: converts from hex to ascii representation

# CONSTANTS
# passed variables 
.equ ST__BUFFER, 8

.globl hexToAscii
.type hexToAscii, @function
hexToAscii:
  # function prologue start
  pushl %ebp
  movl %esp, %ebp
  # function prologue end
  
  # set up counter 
  movl $0, %edi
  movl $0, %esi

hexToAscii_loop:
  # hex div by 10 
  movl $10, %ebx
  movl $0, %edx
  divl %ebx
  # push the remainder i++
  pushl %edx
  incl %edi
  # check if quotient is 0
  cmpl $0, %eax
  jne hexToAscii_loop

hexToAscii_convert_loop:
  # while i != 0
  cmpl $0, %edi
  je hexToAscii_end
  
  # pop and plus '0'
  popl %edx
  decl %edi
  addl $'0', %edx
  movl ST__BUFFER(%ebp), %eax
  movl %edx, (%eax, %esi, 1)
  incl %esi
  jmp hexToAscii_convert_loop

hexToAscii_end:
  movl $0x0A, %edx
  movl ST__BUFFER(%ebp), %eax
  movl %edx, (%eax, %esi, 1)
  incl %esi
  movl %esi, %eax

  # function epilogue start
  movl %ebp, %esp
  popl %ebp
  ret
  # function epilogue end
