%{
#include <string>
#include <stdlib.h>

enum TOKEN {
  ID = 256, NUMERO, MENOR_IGUAL, MAIOR_IGUAL, DIFERENTE,
  FOR, IF, REAL = 999
};

%}

D		[0-9]
L		[a-zA-Z_]
ID		{L}({L}|{D})*
NUM		{D}+("."{D}+)?([Ee][+\-]?{D}+)?
WS		[ \t\n]
RESTO	[^\n]

REAL	"R$"(" "?)({D}|{D}{D}|{D}{D}{D})("."{D}{D}{D})*","{D}{D}

%%

{WS}	{ }
{NUM}	{ return NUMERO; }
{REAL}	{ return REAL; }
  
">="	{ return MAIOR_IGUAL; }  
"<="	{ return MENOR_IGUAL; }  
"<>"	{ return DIFERENTE; }  

"for"	{ return FOR; }
"if"	{ return IF; }

{ID}	{ return ID; } // ID deve vir depois das palavras reservadas

{RESTO}	{ return yytext[0]; }
  
%%

int main() {
  int token = yylex(); // next_token
  
  while( token != 0 ) {
    printf( "%d: [%s]\n", token, yytext );
    token = yylex();
  }
  
  return 0;
}
