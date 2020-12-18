%{ // Código em C/C++
#include <stdio.h>
#include <string>

using namespace std;

enum TOKEN { _NUM = 256, _ID, _IF };

%}
	/* Uma definição regular */

DIGITO	[0-9]
LETRA	[A-Za-z_]

NUM		{DIGITO}+
ID		{LETRA}({LETRA}|{DIGITO})*

%%
  /* Comentários devem ter um tab antes */
  /* Padões e ações - ao casar a entrada com um padrão o código
     da ação será executado. Se for um return, o token será retornado.
     Caso contrário, a entrada avança e o loop continua. */
    
" "	{ /* ignora espaço */ }    
"if"	{ return _IF; }
{NUM}	{ return _NUM; }
{ID}	{ return _ID; }

%%
// Código C auxiliar ou para testes.

int main() {
  int token = 0;
  
  while( (token = yylex()) != EOF )  
    printf( "Token: %d %s\n", token, yytext );
  
  return 0;
}
