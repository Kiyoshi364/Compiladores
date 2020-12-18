all: output in.txt
	./output < in.txt

lex.yy.c: teste.l
	lex teste.l

output: lex.yy.c main.cc 
	g++ lex.yy.c main.cc -o output -lfl

clean:
	rm output lex.yy.c

