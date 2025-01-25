# PURPOSE: function is used to compute the power 
# INPUT: 
#   first arg: the base number
#   second arg: the power to raise the base number to
# OUTPUT: will give result of the power 
# NOTES: power must be 1 or greater 
# VARIABLE:
#   %ebx - holds the base number
#   %ecx - holds the power
#   -4(%ebp) - holds the current result 
#   %eax - is used for temp storage 

.type power, @function 
power: 
  pushl %ebp
  # save base pointer 
  movl %esp, %ebp
  # make stack pointer the base pointer 
  subl $4, %esp
  # make room for local variable 

  movl 8(%ebp), %ebx
  # put first arg in %ebx
  movl 12(%ebp), %ecx
  # put second arg in %ecx

  movl %ebx, -4(%ebp)
  # store base number 

power_loop_start:
  cmpl $1, %ecx 
  je end_power
  # if power is 1 then quit
  
  movl -4(%ebp), %eax
  # get current value
  imull %ebx, %eax
  # multiply current by the base number
  movl %eax, -4(%ebp)
  # store the current result 

  decl %ecx
  # decrease the power 
  jmp power_loop_start

end_power:
  movl -4(%ebp), %eax
  # store output value in return register
  movl %ebp, %esp
  # restore the stack pointer
  popl %ebp
  # restore the base pointer
  ret
  # return from function
