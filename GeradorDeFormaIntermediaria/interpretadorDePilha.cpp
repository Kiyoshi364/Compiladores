#include <stdlib.h>
#include <map>
#include <vector>
#include <string>
#include <iostream>

using namespace std;

enum TOKEN { NUM = 256, ID };

string lexema;
vector<string> pilha;
map<string, double> var;

void print();
void Max2();

typedef void (*Funcao)();

map<string,Funcao> funcao = {
	{ "print", &print },
	{ "max", &Max2 }
};

void push( double valor ) {
	pilha.push_back( to_string( valor ) );
}
void push( string valor ) {
	pilha.push_back( valor );
}

string pop_string() {
	string temp = pilha.back();
	pilha.pop_back();
	return temp;
}

double pop_double() {
	double temp = stod( pilha.back() );
	pilha.pop_back();
	return temp;
}

void print() {
	cout << pop_double() << " ";
}

void Max2() {
	double b = pop_double();
	double a = pop_double();

	push( a > b ? a : b );
}

int next_token() {
	static int look_ahead = ' ';

	while( look_ahead == ' ' || look_ahead == '\n' || look_ahead == '\r' || look_ahead == '\t' )
		look_ahead = getchar();

	if( isdigit( look_ahead ) ) {
		lexema = (char) look_ahead;

		look_ahead = getchar();
		return NUM;
	}

	if( isalpha( look_ahead ) ) {
		lexema = (char) look_ahead;

		look_ahead = getchar();
		while( isalpha( look_ahead ) ) {
			lexema += (char) look_ahead;

			look_ahead = getchar();
		}

		return ID;
	}

	// STRING
	if( look_ahead == '"' ) {
		lexema = (char) look_ahead;

		look_ahead = getchar();
		while( look_ahead != '"' ) {
			lexema += (char) look_ahead;

			look_ahead = getchar();
		}

		return ID;
	}

	switch( look_ahead ) {
		case '+':
		case '-':
		case '*':
		case '/':
		case '=':
		case '@':
		case '#':
			int temp = look_ahead;
			look_ahead = getchar();
			return temp;
	}

	return EOF;
}

int main() {
	int token = next_token();

	while( token != EOF ) {
		double op1, op2;

		switch( token ) {
			case NUM:
				push( lexema ); 
				break;

			case ID:
				push( lexema );
				break;

			case '@':
				push( var[pop_string()] );
				break;

			case '=':
				op2 = pop_double();
				var[pop_string()] = op2;
				break;

			case '+':
				op2 = pop_double();
				op1 = pop_double();

				push( op1 + op2 ); 
				break;

			case '-':
				op2 = pop_double();
				op1 = pop_double();

				push( op1 - op2 ); 
				break;

			case '/':
				op2 = pop_double();
				op1 = pop_double();

				push( op1 / op2 ); 
				break;

			case '*':
				op2 = pop_double();
				op1 = pop_double();

				push( op1 * op2 ); 
				break;

			case '#': {
				string temp = pop_string();
				Funcao f = funcao[temp];

				if( f == nullptr ) {
					cout << "Funcao não definida: " << temp << endl;
					exit( 1 );
				}
					f(); }
				break;
		}

		token = next_token();
	}

	cout << "Variáveis" << endl;
	for( auto x : var )
		cout << x.first << " = " << x.second << endl;

	cout << "Pilha" << endl;
	for( string x : pilha )
		cout << x << " ";


	cout << endl;
}
