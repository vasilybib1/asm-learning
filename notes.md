# Notes

## General Purpose Registers 
these are the general purpose registers
- %eax
- %ebx
- %ecx
- %edx
- %edi
- %esx

these are special purpose registers 
- %ebp
- %esp
- %eip
- %eflags

## Instructions 
~~~
movl $1, %eax
~~~

moves value into a register 

~~~
int $0x80
~~~

interrupt command that invokes system call

~~~
movl BEGINNINGADDRESS(, %INDEXREGISTER, WORDSIZE)
~~~

loading a values from an array

~~~
cmpl $0, %eax
~~~

compares two values, it affects the %eflags, also known as the status register

~~~
je # jump if the value were equal
jg # jump if the second value was greater than the first value
jge # jump if the second value was greater than or equal to the first value 
jl # jump if the second value was less than the first value 
jle # jump if the second value was less than or equal to the first value
jmp # unconditional jump
~~~

all the different jump variation

~~~
incl %edi
~~~

increment current register

## Storage 
~~~
.byte # takes up one byte
.int # takes up two bytes 
.long # takes up four bytes 
.ascii # takes up one byte
~~~

this is how we can access some address

~~~
ADDRESS_OR_OFFSET(%BASE_OR_OFFSET, %INDEX, MULTIPLIER)

# FINAL = ADDRESS_OR_OFFSET + BASE_OR_OFFSET + INDEX * MULTIPLIER
~~~

## Stack and Functions 

~~~
movl %ebp, %esp
popl %ebp
ret
~~~














