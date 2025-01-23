# takes an argument of file names to compile and run

# for each file it compiles and links and executate and prints exit code 
for arg in "$@"
do 
  as ./src/$arg.s -o ./obj/$arg.o --32
  ld ./obj/$arg.o -o ./exec/$arg -melf_i386
  ./exec/$arg
  echo $?
done
