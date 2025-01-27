# Notes

## Registers
%eax, %ebx, %ecx, %edx, %edi, %esx are the available general purpose register. With those we also have %ebp (base pointer), %esp (stack pointer), %eip, %eflags which are the special pointers that have their own features. 

## Instructions 
~~~
movl $1, %eax # moves 1 (decimal) into eax
movl $0x1, %eax # moves 1 (hex) into eax
movl (%esp), %eax # moves value stored at esp 
movl %eax, (%esp) # moves value from eax in to address at esp
~~~
~~~
int $0x80 # initiates a system call
~~~
~~~
cmpl $0, %eax # compares two values and sets %eflags which are used for the jump conditions 
~~~
~~~
je # jump if the value were equal
jg # jump if the second value was greater than the first value
jge # jump if the second value was greater than or equal to the first value 
jl # jump if the second value was less than the first value 
jle # jump if the second value was less than or equal to the first value
jmp # unconditional jump
~~~
~~~
incl %eax # increment value
decl %eax # decrement value
~~~
~~~
# accessing values from an array
ADDRESS_OR_OFFSET(%BASE_OR_OFFSET, %INDEX, MULTIPLIER)
# FINAL = ADDRESS_OR_OFFSET + BASE_OR_OFFSET + INDEX * MULTIPLIER
~~~
~~~
pushl %eax # pushes value at eax to the stack
popl %eax # pops value and writes it into eax
~~~

## Stack and Functions 
Returning from a function always should look something like this. Where we reset the stack pointer and restore the old base pointer of the previous function.
~~~
movl %ebp, %esp
popl %ebp
ret
~~~

The start of every function should save the old base pointer and allocated any needed space for local variables.
~~~
pushl %ebp
movl %esp, %ebp
subl $4, %esp # saves one location for local variable 
~~~

## Debugging and Compiling 
General compile commands look something like this and after executing it prints the value of the exit code 
~~~
as somefile.s -o somefile.o --32 -g
ld somefile.o -o somefile -melf_i386
./somefile
echo $?
~~~
If you want to compile multiple files into one object file you just do this
~~~
as somefile1.s somefile2.s -o somefile.o --32 -g
ld somefile.o -o somefile -melf_i386
./somefile
echo $?
~~~
The dash g is used to get debug information so we can us GDB to debug the program. The following code opens the debugger for somefile and sets breakpoint at line 16 of the source file and it runs up until that point.
~~~
gdb somefile
br 16 
run 
~~~
We can then print values from the breakpoint. For example we print the value of the current stack pointer. Printing with p/x will print the hexedecimal value of it and printing with p/t will print the decimal value of it 
~~~
p/x $sp
p/t $sp
~~~
We can also print the first 40 words from the stack pointer like such 
~~~
x/40x $sp
~~~














