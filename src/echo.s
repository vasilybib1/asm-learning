.section .data

.section .text
.globl _start 
_start:
  subl $64, %esp
  # allocate space on the stack
  movl $3, %eax
  movl $0, %ebx
  mov %esp, %ecx
  mov $64, %edx
  # set up all the arguments for read system call
  int $0x80
  # calls the system call

  movl %eax, %edx
  # saves number of bytes written to bytes to write
  movl $4, %eax
  movl $1, %ebx
  mov %esp, %ecx
  # set up all the arguments for write system call
  int $0x80
  # calls system call

  movl $1, %eax
  movl $0, %ebx
  int $0x80
  # exits the app with correct exit code

