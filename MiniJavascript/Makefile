all: out.pilha mdp/mdp
	./mdp/mdp < out.pilha

run: out.pilha
	cat out.pilha

out.pilha: mini_js in
	./mini_js < in > out.pilha

lex.yy.c: mini_js.l
	lex mini_js.l

y.tab.c: mini_js.y
	yacc mini_js.y

mini_js: lex.yy.c y.tab.c
	g++ -Wall -std=c++17 y.tab.c -ll -o mini_js

clean:
	rm lex.yy.c y.tab.c mini_js out.pilha

