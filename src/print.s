.section .data

.section .text
.globl _start
_start:
  pushl %ebp
  movl %esp, %ebp 
  # back up and initialize base pointer 
  # (this is for future to become a function)

  movl $0x0A474645, %eax
  pushl %eax
  movl $0x44434241, %eax
  pushl %eax
  # store a new line character into the array (0xA)

  movl $4, %eax
  movl $1, %ebx
  movl %esp, %ecx
  movl $8, %edx
  int $0x80 
  # load system call, fd number, pointer, len
  # and invoke the system call

  movl %eax, %ebx
  movl $1, %eax
  int $0x80
  # get the return val of the write command 
  # print it as the exit code
