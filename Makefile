obj = ./obj
src = ./src/sort

sort: parse.o sort.o convert.o mergesort.o merge.o
	ld -m elf_i386 ${obj}/sort.o ${obj}/parse.o ${obj}/convert.o ${obj}/mergesort.o ${obj}/merge.o -o sort 

sort.o:
	as ${src}/sort.s -o ${obj}/sort.o --32 -g

parse.o:
	as ${src}/parse.s -o ${obj}/parse.o --32 -g

convert.o:
	as ${src}/convert.s -o ${obj}/convert.o --32 -g

mergesort.o:
	as ${src}/mergesort.s -o ${obj}/mergesort.o --32 -g

merge.o:
	as ${src}/merge.s -o ${obj}/merge.o --32 -g

clean: 
	rm ${obj}/*.o; rm sort
