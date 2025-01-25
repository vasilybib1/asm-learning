# PURPOSE: test program to see how functions work
# INPUT: none
# OUTPUT: 2^3 + 5^2

.section .data

.section .text
.globl _start
_start:
  pushl $3
  # push the second arg
  pushl $2
  # push the first arg
  call power
  addl $8, %esp
  # move teh stack pointer back
  pushl %eax
  # save the first answer 

  pushl $2
  pushl $5
  call power 
  addl $8, %esp
  # preform power function call with (5, 2)

  popl %ebx 
  # retrieve first answer into ebx
  addl %eax, %ebx
  # add output of first power call to second 

  movl $1, %eax
  int $0x80
  # preform system exit call
