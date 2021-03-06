%{
#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <iostream>

using namespace std;

enum TOKEN { NUM = 256, ID, STRING, PRINT };

int token;
string lexema;

void Init();
void Atr();
void Print();
void Expr();
void Expr_T();
void Expr_F();
void Maybe_Func();
void Args();

void next_token();
void casa( int );
void casa_print( int, string );

#define ERROR( x ) { \
string msg = x; \
cout << endl << "*** Erro: ***" << endl << msg << endl; \
exit( 1 ); \
}

void print(string s);

void print( string s ) {
	cout << s;
}

void casa( int esperado ) {
	if ( token == esperado ) {
		next_token();
	} else {
		printf("\nEsperado `%c' (%d), encontrado: `%c' (%d)\n",
			esperado, esperado, token, token);
		exit( 1 );
	}
}

void casa_print( int esperado, string s ) {
	if ( token == esperado ) {
		print( lexema + s );
		next_token();
	} else {
		printf( "Esperado `%c' (%d), encontrado: `%c' (%d)\n",
			esperado, esperado, token, token );
		exit( 1 );
	}
}

void Init() {
	while ( token ) {
		switch ( token ) {
			case ID: Atr(); break;
			case PRINT: Print(); break;
		}
	}
}

void Atr() {
	// Guardamos o lexema pois a função 'casa' altera o seu valor.
	string temp = lexema; 
	casa_print( ID, " " );
	casa( '=' );
	Expr();
	casa( ';' );
	print("=\n");
}

void Print() {
	casa( PRINT );
	Expr();
	casa( ';' );
	print("print #\n");
}

void Expr() {
	Expr_T();
	
	while ( 1 ) {
		switch( token ) {
			case '+' : casa( '+' ); Expr_T(); print("+ "); break;
			case '-' : casa( '-' ); Expr_T(); print("- "); break;
			default: return;
		}
	}
}

void Expr_T() {
	Expr_F();

	while ( 1 ) {
		switch( token ) {
			case '*' : casa( '*' ); Expr_F(); print("* "); break;
			case '/' : casa( '/' ); Expr_F(); print("/ "); break;
			default: return;
		}
	}
}

void Expr_F() {
	switch( token ) {
		case ID:
			Maybe_Func(); break;
		case NUM:
			casa_print( token, " " ); break;
		case STRING:
			casa_print( token, " " ); break;
		case '(': 
			casa( '(' ); Expr(); casa( ')' ); break;
		default:
			ERROR( "Operando esperado, encontrado " + lexema );
	}
}

void Maybe_Func() {
	string temp = lexema;
	casa( ID );
	switch ( token ) {
		case '(':
			casa( '(' ); Args(); casa( ')' ); print( temp + " # " ); break;
		default:
			print( temp + " @ " ); break;
	}
}

void Args() {
	switch ( token ) {
		case ID:
		case NUM:
		case STRING:
		case '(':
			Expr();
			break;
		default:
			return;
	}

	while ( 1 ) {
		switch ( token ) {
			case ',':
				casa( ',' ); Expr(); break;
			default: return;
		}
	}
}

%}
	/* Uma definição regular */

D			[0-9]
L			[A-Za-z]
I			({L}|"$"|"_")

ID			{I}({I}|{D})*

INT			{D}+
FLOAT		{INT}\.?{INT}?([e|E][\+|-]?{INT})?

NUM			({INT}|{FLOAT})

STRING		\"([^\"\n]|\\\"|\"\")+\"

PRINT		print

WS			[ \t\n]

%%

{WS}			{ /* skip ws */ }

{NUM}			{ return NUM; }
{STRING}		{ return STRING; }

{PRINT}			{ return PRINT; }

{ID}			{ return ID; }

.				{ return yytext[0]; }

%%

auto p = &yyunput; // Para evitar uma warning de 'unused variable'

void next_token() {
	token = yylex();
	lexema = yytext;
}

int main() {

	next_token();

	Init();

	return 0;
}
