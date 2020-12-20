	/* Uma definição regular */

D			[0-9]
L			[A-Za-z]
I			({L}|"$"|"_")

ID			{I}({I}|{D})*

INT			{D}+
FLOAT		{INT}\.?{INT}?([e|E][\+|-]?{INT})?

FOR			[f|F][o|O][r|R]
IF			[i|I][f|F]

MAIG		>=
MEIG		<=
IG			==
DIF			!=

C_INLIN		"//".+\n
C_MULT_S	"/*"
C_MULT_M	[^\*]\/|\*[^\/]|[^\*\/]
C_MULT_E	"*/"
C_MULT		{C_MULT_S}{C_MULT_M}*{C_MULT_E}

COMENTARIO	({C_MULT}|{C_INLIN})

STRING		\"([^\"\n]|\\\"|\"\")+\"

WS			[ \t\n]

%%

{WS}			{ /* Skip ws */ }

{COMENTARIO}	{ return _COMENTARIO; }

{STRING}		{ return _STRING; }
    
{INT}			{ return _INT; }
{FLOAT}			{ return _FLOAT; }

{FOR}			{ return _FOR; }
{IF}			{ return _IF; }

{MAIG}			{ return _MAIG; }
{MEIG}			{ return _MEIG; }
{IG}			{ return _IG; }
{DIF}			{ return _DIF; }

{ID}			{ return _ID; }
.				{ return yytext[0]; }

%%
