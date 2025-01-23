# PURPOSE: simple program that finds the maximum number of a set of data 
# INPUT: none
# OUTPUT: max number in the array of data 
# VARIABLES: 
#   %edi - holds the index of the data 
#   %ebx - largest number found so far 
#   %eax - current data item
# 
#   data_items - contains the item data (0 to indicate end of list)

.section .data
data_items: # data to find highest number 
  .long 3, 20, 87, 33, 22, 139, 92, 73, 27, 1, 34, 77, 83, 0

.section .text
.globl _start
_start:
  movl $0, %edi 
  # set 0 as the index 
  movl data_items(, %edi, 4), %eax 
  # load the first byte of data 
  movl %eax, %ebx
  # since its the first item we set it as the largest currently found

start_loop:
  cmpl $0, %eax
  #check if we hit 0 (aka the end)
  je loop_exit
  # jump if we did
  incl %edi
  # increment counter
  movl data_items(, %edi, 4), %eax
  # load next value
  cmpl %ebx, %eax
  # compare values
  jle start_loop
  # jump to start of loop if new one isnt bigger 

  movl %eax, %ebx
  # change largest value found to new one
  jmp start_loop
  # go to start of the loop 

loop_exit:
  movl $1, %eax
  # move 1 to invoke exit system call
  int $0x80
  # execute system call


