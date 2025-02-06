as ./src/power/*.s -o power.o --32 
ld power.o -o power -melf_i386
./power
echo $?
rm power power.o
