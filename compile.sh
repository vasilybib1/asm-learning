# takes an argument of file names to compile and run

# cleans the executable and obj folder
rm ./exec/*
rm ./obj/*.*

# for each file it compiles and links and executate and prints exit code 
for arg in "$@"
do 
  as ./src/$arg.s -o ./obj/$arg.o
  ld ./obj/$arg.o -o ./exec/$arg 
  ./exec/$arg
  echo $?
done
