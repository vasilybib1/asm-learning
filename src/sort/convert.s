# CONVERT FUNCTION 
# INPUTS: (read_buffer_len, *read_buffer)
# PURPOSE: convert from an ascii list seperated by new lines 
#   into just hex values also seperated by new lines
# EXAMPLE: 31 32 0a -> 01 02 0a

# CONSTANTS
.equ START_NUMB, '0'
.equ END_NUMB, '9'
.equ NUMB_CONVERSION, '0'
.equ NEW_LINE, 0x0A

# stack local variables
.equ ST_BUFFER_LEN, 8
.equ ST_BUFFER, 12

.globl convert
.type convert, @function
convert:
  # function prologue start
  pushl %ebp
  movl %esp, %ebp
  # function prologue end
  
  # load local variables
  movl ST_BUFFER(%ebp), %eax
  movl ST_BUFFER_LEN(%ebp), %ebx
  movl $0, %edi
  movl $0, %ecx

  # jump to end if nothing to process
  cmpl $0, %ebx
  je end_convert_loop

convert_loop:
  # check if value is in numb range
  movb (%eax, %edi, 1), %cl
  cmpb $START_NUMB, %cl
  jl convert_next_byte
  cmpb $END_NUMB, %cl
  jg convert_next_byte

  # apply the conversion and store back
  subb $NUMB_CONVERSION, %cl
  movb %cl, (%eax, %edi, 1)
  jmp convert_next_byte_p2

convert_next_byte:
  # check if its new line
  cmpb $NEW_LINE, %cl
  jne convert_exit_with_error
  
convert_next_byte_p2:
  # tick counter and continue
  incl %edi
  cmpl %edi, %ebx
  jne convert_loop
  jmp end_convert_loop

convert_exit_with_error:
  # set return value
  movl $1, %eax

  # function epilogue start
  movl %ebp, %esp
  popl %ebp
  ret
  # function epilogue end

end_convert_loop:
  # set return value
  movl $0, %eax

  # function epilogue start
  movl %ebp, %esp
  popl %ebp
  ret
  # function epilogue end










