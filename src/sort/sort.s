# MAIN SORT FUNCTION
# INPUTS: command line file to read from and output file
# PRE-REQ: input file must be ascii int values entered on seperate lines

.section .data 
  # error messages 
convert_err_msg: 
  .ascii "ERR: non number in data\n"
convert_err_msg_end: 
  .equ convert_err_msg_len, convert_err_msg_end  - convert_err_msg

parse_err_msg: 
  .ascii "ERR: ran out of space\n"
parse_err_msg_end: 
  .equ parse_err_msg_len, parse_err_msg_end - parse_err_msg

# CONSTANTS
# system calls
.equ SYS_OPEN, 5
.equ SYS_CLOSE, 6
.equ SYS_WRITE, 4
.equ SYS_READ, 3
.equ SYS_EXIT, 1
# file descriptors
.equ STDIN, 0
.equ STDOUT, 1
.equ STDERR, 2
# flags
.equ O_RDONLY, 0
# sys stuff
.equ LINUX_SYSCALL, 0x80
.equ END_OF_FILE, 0

.section .bss
# for reading the file
.equ BUFF_READ_LEN, 500
.lcomm BUFF_READ, BUFF_READ_LEN
# for storing the values
.equ BUFF_DATA_LEN, 400 # 400 / 4 is 100 entries
.lcomm BUFF_DATA, BUFF_DATA_LEN

.section .text
.equ ST_SIZE_RESERVE, 12
.equ ST_FD_IN, -4
.equ ST_FD_OUT, -8
.equ ST_DATA_TEMP_INDEX, -12
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

  movl $0, ST_DATA_TEMP_INDEX(%ebp)

read_loop_begin:
  # reads into the buffer from file using fd
  movl $SYS_READ, %eax
  movl ST_FD_IN(%ebp), %ebx
  movl $BUFF_READ, %ecx
  movl $BUFF_READ_LEN, %edx
  int $LINUX_SYSCALL
  
  # check file still has bytes to read
  cmpl $END_OF_FILE, %eax
  jle read_loop_end

  # call convert
  pushl $BUFF_READ
  pushl %eax
  call convert
  # error checking
  cmpl $0, %eax
  jne convert_error
  # cleaning up args
  popl %eax
  addl $4, %esp

  # call parse
  movl ST_DATA_TEMP_INDEX(%ebp), %ebx
  pushl %ebx
  pushl $BUFF_DATA
  pushl $BUFF_DATA_LEN
  pushl $BUFF_READ
  pushl %eax
  call parse
  addl $16, %esp
  popl %ebx
  movl %ebx, ST_DATA_TEMP_INDEX(%ebp)

  # error checking
  cmpl $0, %eax
  jne parse_error
  
  jmp read_loop_begin

read_loop_end:
  # close opened read file
  movl $SYS_CLOSE, %eax
  movl ST_FD_IN(%ebp), %ebx
  int $LINUX_SYSCALL

  # call mergesort (first, last)
  pushl $BUFF_DATA
  movl $BUFF_DATA, %ecx # debug
  movl ST_DATA_TEMP_INDEX(%ebp), %eax
  movl $4, %edx
  imull %edx, %eax
  addl $BUFF_DATA, %eax
  pushl %eax
  call mergesort
  popl %eax
  popl %eax

br:
  # debug
  movl $BUFF_DATA, %eax

  # exit with 0 error code
  movl $SYS_EXIT, %eax
  movl $0, %ebx
  int $LINUX_SYSCALL

convert_error:
  # print the error msg
  movl $SYS_WRITE, %eax
  movl $STDERR, %ebx
  movl $convert_err_msg, %ecx
  movl $convert_err_msg_len, %edx
  int $LINUX_SYSCALL
  jmp err

parse_error:
  # print the error msg
  movl $SYS_WRITE, %eax
  movl $STDERR, %ebx
  movl $parse_err_msg, %ecx
  movl $parse_err_msg_len, %edx
  int $LINUX_SYSCALL

err:
  # exit with error code
  movl $SYS_EXIT, %eax
  movl $1, %ebx
  int $LINUX_SYSCALL










