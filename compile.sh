# takes an argument of file names to compile and run
for arg in "$@"
do 
  as ./src/$arg.s -o ./obj/$arg.o
  ld ./obj/$arg.o -o ./exec/$arg 
  ./exec/$arg
  echo $?
done
