%{ // Código em C/C++
#include <stdio.h>
#include <string>

using namespace std;

enum TOKEN { TK_NUM = 256, TK_ID, TK_IF, TK_MAIG };
int col = 0;
%}
/* Uma definição regular */

DIGITO	[0-9]
LETRA	[A-Za-z_]

NUM		{DIGITO}+("."{DIGITO}+)?
ID		{LETRA}({LETRA}|{DIGITO})*


%%
  /* Comentários devem ter um tab antes */
  /* Padrões e ações - ao casar a entrada com um padrão o código
     da ação será executado. Se for um return, o token será retornado.
     Caso contrário, a entrada avança e o loop continua. */
    
" "		{ col++; /* ignora espaço */ }    
\t		{ col+=2; /* ignora tab */ }    
"if"	{ return TK_IF; }
{NUM}	{ return TK_NUM; }
{ID}	{ return TK_ID; }
">="	{ return TK_MAIG; }

.       { return yytext[0]; }

%%
// Código C auxiliar ou para testes.

int main() {
  int token = 0;
  
  while( (token = yylex()) != 0 )  
    printf( "Token: %d %s\n", token, yytext );
  
  return 0;
}
