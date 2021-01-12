all: out.pilha mdp
	./mdp < out.pilha

pilha: interpretadorDePilha.cpp
	g++ -Wall -std=c++17 interpretadorDePilha.cpp -o pilha

mdp: mdp.cpp
	g++ -Wall -std=c++17 mdp.cpp -ll -o mdp

mdp.cpp: mdp.l
	lex mdp.l
	mv lex.yy.c mdp.cpp

out.pilha: output in.txt
	./output < in.txt > out.pilha

output: tradutor.cpp
	g++ -Wall -std=c++17 tradutor.cpp -ll -o output

tradutor.cpp: tradutor.l
	lex tradutor.l
	mv lex.yy.c tradutor.cpp

clean:
	rm output tradutor.cpp out.pilha mdp.cpp mdp

