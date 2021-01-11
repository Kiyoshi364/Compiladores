#include <stdlib.h>
#include <map>
#include <vector>
#include <string>
#include <iostream>

#define DEBUG if(0)

using namespace std;

enum TOKEN { NUM = 256, ID, STRING, FLOAT };

string lexema;
vector<string> pilha;
map<string, string> var;

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

int isNum( string s ) {
	int dot = 0;
	for ( char c : s ) {
		if ( c == '.' || c == ',' ) {
			dot += 1;
			if ( dot > 1 ) return false;
		} else if ( isdigit(c) ) {
		} else return false;
	}
	return true;
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
	string str = pop_string();
	if ( isNum(str) ) {
		push( str );
		cout << pop_double() << " ";
	} else {
		cout << "\"" << str << "\"" << " ";
	}
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
		while( isdigit( look_ahead ) ) {
			lexema += (char) look_ahead;

			look_ahead = getchar();
		}

		if ( look_ahead != '.' && look_ahead != ',' ) {
			return NUM;
		}

		// FLOAT
		lexema += (char) look_ahead;

		look_ahead = getchar();
		while( isdigit( look_ahead ) ) {
			lexema += (char) look_ahead;

			look_ahead = getchar();
		}

		return FLOAT;
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
		lexema = "";

		look_ahead = getchar();
		while( look_ahead != '"' ) {
			lexema += (char) look_ahead;

			look_ahead = getchar();
		}
		look_ahead = getchar();

		return STRING;
	}

	switch( look_ahead ) {
		case '+':
		case '-':
		case '*':
		case '/':
		case '=':
		case '@':
		case '#':
			int tmp = look_ahead;
			lexema = (char) look_ahead;
			look_ahead = getchar();
			return tmp;
	}

	return EOF;
}

int main() {
	int token = next_token();

	while( token != EOF ) {
		DEBUG printf("token: `%c' (%d)\n", token, token);
		DEBUG cout << "lexema: `" << lexema << "'" << endl;

		double op1, op2;
		string str;

		switch( token ) {
			case NUM:
				push( lexema ); 
				break;

			case ID:
				push( lexema );
				break;

			case STRING:
				push( lexema );
				break;

			case FLOAT:
				push( lexema );
				break;

			case '@':
				push( var[pop_string()] );
				break;

			case '=':
				str = pop_string();
				var[pop_string()] = str;
				break;

			case '+':
				str = pop_string();
				if ( isNum(str) ) {
					push( str );
					op2 = pop_double();
					op1 = pop_double();

					push( op1 + op2 );
				} else {
					string str1 = pop_string();
					str = str1 + str;
					push( str );
				}
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

	cout << endl << endl << "FIM" << endl;

	cout << "Variáveis" << endl;
	for( auto x : var )
		cout << x.first << " = " << x.second << endl;

	cout << "Pilha" << endl;
	for( string x : pilha )
		cout << x << " ";

	cout << endl;
}
