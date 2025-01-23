# PURPOSE: just simpel program that exits and returns a status code back to the linux kernel 

# INPUT: none 

# OUTPUT: returns a status code that can be viewed by typing 'echo $?' after program executes 

# VARIABLES: 
#   %eax holds the system call number 
#   %ebx holds the return status 

.section .data 

.section .text 
.globl _start
_start:
  movl $1, %eax 
  # 1 - system call for exiting a program 

  movl $0, %ebx 
  # %ebx status number to return to os 
  # number that gets returned to the 'echo $?' command 

  int $0x80
  # execute the system call
