# PARSE FUNCTION
# INPUTS: (read_buffer_len, *read_buffer, 
#   data_buffer_len, *data_buffer)
# PURPOSE: converts from an ascii list seperated by new lines
#   to an indexable array of longs 
# PRE-REQ: ascii raw data ran through the convert function to 
#   get data in the fromat of 01 0a 02 03 0a ... and so on
# EXAMPLE: 01 02 0a -> 0x0c

# CONSTANTS 
# stack position
.equ ST_DATA_INDEX, -8
.equ ST_TEMP, -4
.equ ST_BUFF_READ_LEN, 8
.equ ST_BUFF_READ, 12
.equ ST_BUFF_DATA_LEN, 16
.equ ST_BUFF_DATA, 20
.equ ST_BUFF_DATA_INDEX, 24
# other
.equ NEW_LINE, 0x0A

.globl parse
.type parse, @function
parse:
  # function prologue start
  pushl %ebp
  movl %esp, %ebp
  subl $8, %esp
  # function prologue end

  # cleaning and setting local variables
  movl ST_BUFF_READ(%ebp), %eax
  movl ST_BUFF_READ_LEN(%ebp), %ebx
  # movl $0, ST_DATA_INDEX(%ebp)
  movl $0, ST_TEMP(%ebp)
  movl $0, %edi
  movl $0, %edx
  movl $0, %ecx

  # check if there is data to read
  cmpl $0, %ebx
  je end_parse_loop

start_parse_loop:
  # read byte check if its new line
  movb (%eax, %edi, 1), %cl
  cmpb $NEW_LINE, %cl
  je convert_pops

  # check if index is at end of file
  cmpl %edi, %ebx
  je end_parse_loop
  
  # push int val & increase indecies
  pushl %ecx
  incl %edx 
  incl %edi

  # check if index is at end of file
  cmpl %edi, %ebx
  jne start_parse_loop

end_parse_loop:
  # set return value
  movl $0, %eax

  # function epilogue start
  addl $8, %esp
  movl %ebp, %esp
  popl %ebp
  ret
  # function epilogue end

convert_pops:
  # increment index and reset values
  incl %edi
  movl $0, ST_TEMP(%ebp)
  movl $1, %eax

start_convert_pops_loop:
  # check if more pops to do
  cmpl $0, %edx
  je end_convert_pops_loop

  # pop multiply and add to current temp
  popl %ecx
  imull %eax, %ecx
  movl ST_TEMP(%ebp), %ebx
  addl %ebx, %ecx
  movl %ecx, ST_TEMP(%ebp)

  # increase to next power & decrement counter
  imull $10, %eax
  decl %edx
  jmp start_convert_pops_loop

end_convert_pops_loop:
  # checks if current index is out of range
  movl ST_BUFF_DATA_INDEX(%ebp), %ebx
  movl ST_BUFF_DATA_LEN(%ebp), %eax
  sarl $2, %eax
  cmpl %eax, %ebx
  je convert_pops_exit_with_error
  
  # loads value into array and index++
  movl ST_BUFF_DATA(%ebp), %eax
  movl ST_TEMP(%ebp), %ecx
  movl %ecx, (%eax, %ebx, 4)
  incl %ebx
  movl %ebx, ST_BUFF_DATA_INDEX(%ebp)
  
  # loads back register val and cleans ecx
  movl $0, %ecx
  movl ST_BUFF_READ(%ebp), %eax
  movl ST_BUFF_READ_LEN(%ebp), %ebx
  jmp start_parse_loop

convert_pops_exit_with_error:
  # set return value
  movl $1, %eax

  # function epilogue start
  addl $8, %esp
  movl %ebp, %esp
  popl %ebp
  ret
  # function epilogue end























