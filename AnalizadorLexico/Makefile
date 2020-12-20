all: output in.txt
	./output < in.txt

lex.yy.c: scan.lex
	lex scan.lex

output: lex.yy.c
	g++ -Wall -std=c++17 main.cc -ll -o output

clean:
	rm output lex.yy.c

