.section .data 

# CONSTANTS
# system calls
.equ SYS_CLOSE, 6
.equ SYS_OPEN, 5
.equ SYS_WRITE, 4
.equ SYS_READ, 3
.equ SYS_EXIT, 1
# flags
.equ O_RDONLY, 0
.equ O_CREAT_WRONLY_TRUNC, 03101
# file descriptors
.equ STDIN, 0
.equ STDOUT, 1
.equ STDERR, 2
# system stuff
.equ LINUX_SYSCALL, 0x80
.equ END_OF_FILE, 0
.equ NUMBER_OF_ARGS, 2

.section .bss
.equ READ_BUFFER_SIZE, 500
.equ DATA_BUFFER_SIZE, 500
.lcomm READ_BUFFER_DATA, READ_BUFFER_SIZE
.lcomm DATA_BUFFER_DATA, DATA_BUFFER_SIZE

.section .text
.equ ST_SIZE_RESERVE, 8
.equ ST_FD_IN, -4
.equ ST_FD_OUT, -8
.equ ST_ARGC, 0
.equ ST_ARGV_0, 4
.equ ST_ARGV_1, 8
.equ ST_ARGV_2, 12

.globl _start 
_start:
  # init stack
  movl %esp, %ebp
  subl $ST_SIZE_RESERVE, %esp

open_files:
  # open and store fd
  movl $SYS_OPEN, %eax
  movl ST_ARGV_1(%ebp), %ebx
  movl $O_RDONLY, %ecx
  movl $0666, %edx 
  int $LINUX_SYSCALL
  movl %eax, ST_FD_IN(%ebp)

read_loop_begin:
  movl $SYS_READ, %eax
  movl ST_FD_IN(%ebp), %ebx
  movl $READ_BUFFER_DATA, %ecx
  movl $READ_BUFFER_SIZE, %edx
  int $LINUX_SYSCALL

  cmpl $END_OF_FILE, %eax
  jle read_loop_end

  pushl $READ_BUFFER_DATA
  pushl %eax
  call convert
  popl %eax
  addl $4, %esp
  
  pushl $DATA_BUFFER_DATA
  pushl $DATA_BUFFER_SIZE
  pushl $READ_BUFFER_DATA
  pushl %eax
  call parse
  popl %eax
  addl $12, %esp

  jmp read_loop_begin

read_loop_end:
  movl $READ_BUFFER_DATA, %eax
  movl $DATA_BUFFER_DATA, %ebx

  movl $SYS_CLOSE, %eax
  movl ST_FD_IN(%ebp), %ebx
  int $LINUX_SYSCALL

  movl $SYS_EXIT, %eax
  movl $0, %ebx
  int $LINUX_SYSCALL

#======================================================
# PARSE FUNCTION
# INPUTS (rb_len, *rb, db_len, *db)
# PURPOSE: converts from a ascii list seperated by new 
#   lines to a indexable array of longs 
# PRE-REQ: data read from file needs to be ran through 
#   the convert function to get data in the format of 
#   01 0a 02 03 0a ... and so on
# EXAMPLE: 01 02 0a -> 0x0c
.equ ST_DATA_INDEX, -8
.equ ST_TEMP, -4
.equ ST_READ_BUFFER_LEN, 8
.equ ST_READ_BUFFER, 12
.equ ST_DATA_BUFFER_LEN, 16
.equ ST_DATA_BUFFER, 20

.equ NEW_LINE, 0x0A

parse:
  # function prologue start
  pushl %ebp
  movl %esp, %ebp
  subl $8, %esp
  # function prologue end

  movl ST_READ_BUFFER(%ebp), %eax
  movl ST_READ_BUFFER_LEN(%ebp), %ebx
  movl $0, ST_DATA_INDEX(%ebp)
  movl $0, ST_TEMP(%ebp)
  movl $0, %edi
  movl $0, %edx
  movl $0, %ecx

  cmpl $0, %ebx
  je end_parse_loop

start_parse_loop:
  movb (%eax, %edi, 1), %cl
  cmpb $NEW_LINE, %cl
  je convert_pops
  cmpl %edi, %ebx
  je end_parse_loop

  pushl %ecx
  incl %edx
  incl %edi
  cmpl %edi, %ebx
  jne start_parse_loop
  
end_parse_loop:
  # function epilogue start
  addl $8, %esp
  movl %ebp, %esp
  popl %ebp
  ret
  # function epilogue end

convert_pops:
  incl %edi
  movl $0, ST_TEMP(%ebp)
  movl $1, %eax
  movl $0, %ebx
  
start_convert_pops_loop:
  cmpl $0, %edx
  je end_convert_pops_loop
  
  popl %ecx
  imull %eax, %ecx
  movl ST_TEMP(%ebp), %ebx
  addl %ebx, %ecx
  movl %ecx, ST_TEMP(%ebp)
  
  imull $10, %eax
  decl %edx
  jmp start_convert_pops_loop

end_convert_pops_loop:
  movl ST_DATA_INDEX(%ebp), %ebx
  movl ST_DATA_BUFFER(%ebp), %eax
  movl ST_TEMP(%ebp), %ecx
  movl %ecx, (%eax, %ebx, 4)
  incl %ebx
  movl %ebx, ST_DATA_INDEX(%ebp)

  movl $0, %ecx
  movl ST_READ_BUFFER(%ebp), %eax
  movl ST_READ_BUFFER_LEN(%ebp), %ebx
  jmp start_parse_loop


#======================================================
# CONVERT FUNCTION
# INPUTS: (*buffer_data, buffer_size)
# PURPOSE: converts from ascii to hex for whole buffer
#   none number ascii codes get ignored (new line)
# EXAMPLE: 31 0a -> 01 0a 
.equ START_NUMB, '0'
.equ END_NUMB, '9'
.equ NUMB_CONVERSION, '0'

.equ ST_BUFFER_LEN, 8
.equ ST_BUFFER, 12

convert:
  # function prologue start
  pushl %ebp
  movl %esp, %ebp
  # function prologue end

  movl ST_BUFFER(%ebp), %eax
  movl ST_BUFFER_LEN(%ebp), %ebx
  movl $0, %edi

  cmpl $0, %ebx
  je end_convert_loop

convert_loop:
  movb (%eax, %edi, 1), %cl
  cmpb $START_NUMB, %cl
  jl convert_next_byte
  cmpb $END_NUMB, %cl
  jg convert_next_byte

  subb $NUMB_CONVERSION, %cl
  movb %cl, (%eax, %edi, 1)

convert_next_byte:
  incl %edi
  cmpl %edi, %ebx
  jne convert_loop

end_convert_loop:
  # function epilogue start
  movl %ebp, %esp
  popl %ebp
  ret
  # function epilogue end




















