%{ // Código em C/C++
#include <stdio.h>
#include <string>

using namespace std;

enum TOKEN { _INT = 256, _FLOAT, _ID, _IF, _MAIG };

%}
	/* Uma definição regular */

D		[0-9]
L		[A-Za-z_]

WS		[ \t\n]
INT		{D}+
FLOAT	{INT}("."{INT})?([Ee]("+"|"-")?{INT})?
ID		{L}({L}|{D})*

%%
  /* Comentários devem ter um tab antes */
  /* Padões e ações - ao casar a entrada com um padrão o código
     da ação será executado. Se for um return, o token será retornado.
     Caso contrário, a entrada avança e o loop continua. */
    
{WS}		{ /* ignora espaço */ }    
"if"		{ return _IF; }
{INT}		{ return _INT; }
{FLOAT}		{ return _FLOAT; }
{ID}		{ return _ID; }

">="		{ return _MAIG; }

%%
// Código C auxiliar ou para testes.

int main() {
  int token = 0;
  
  while( (token = yylex()) != EOF )  
    printf( "Token: %d %s\n", token, yytext );
  
  return 0;
}
