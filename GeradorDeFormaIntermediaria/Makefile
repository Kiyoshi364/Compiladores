all: out.pilha pilha
	./pilha < out.pilha

pilha: interpretadorDePilha.cpp
	g++ -Wall -std=c++17 interpretadorDePilha.cpp -o pilha

out.pilha: output in.txt
	./output < in.txt > out.pilha

lex.yy.c: tradutor.l
	lex tradutor.l

output: lex.yy.c
	g++ -Wall -std=c++17 lex.yy.c -ll -o output

clean:
	rm output lex.yy.c out.pilha pilha

