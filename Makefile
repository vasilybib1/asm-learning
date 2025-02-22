obj = ./obj
src = ./src

sort: parse.o sort.o convert.o mergesort.o merge.o copy.o combine.o
	ld -m elf_i386 ${obj}/sort.o ${obj}/parse.o ${obj}/convert.o ${obj}/mergesort.o ${obj}/merge.o ${obj}/combine.o ${obj}/copy.o -o sort 

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

copy.o:
	as ${src}/copy.s -o ${obj}/copy.o --32 -g

combine.o:
	as ${src}/combine.s -o ${obj}/combine.o --32 -g

clean: 
	rm ${obj}/*.o; rm sort
