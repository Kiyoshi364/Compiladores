D			[0-9]
L			[A-Za-z]
I			({L}|"$"|"_")

ID			{I}({I}|{D})*

INT			{D}+
FLOAT		{INT}\.?{INT}?([e|E][\+|-]?{INT})?

C_INLIN		"//".+
C_MULT_S	"/*"
C_MULT_M	[^\*]\/|\*[^\/]|[^\*\/]
C_MULT_E	"*/"
C_MULT		{C_MULT_S}{C_MULT_M}*{C_MULT_E}

COMENTARIO	({C_MULT}|{C_INLIN})

SSTR		\'([^\'\n]|\\\'|\'\')+\'
DSTR		\"([^\"\n]|\\\"|\"\")+\"
STRING		({SSTR}|{DSTR})

%%

"\t"			{ coluna += 4; }
" "             { coluna += 1; }
"\n"            { linha += 1; coluna = 1; }

{STRING}		{ return ret (_STR); }
    
{INT}			{ return ret (_NUM); }
{FLOAT}			{ return ret (_NUM); }

"let"			{ return ret (_LET); }
"const"			{ return ret (_CONST); }
"var"			{ return ret (_VAR); }

"[]"			{ return ret (_ARR); }
"{}"			{ return ret (_OBJ); }

"<="			{ return ret (_LE); }
">="			{ return ret (_GE); }
"=="			{ return ret (_EQ); }
"!="			{ return ret (_NE); }
"&&"			{ return ret (_AND); }
"||"			{ return ret (_OR); }

"if"			{ return ret (_IF); }
"else"			{ return ret (_ELSE); }
"while"			{ return ret (_WHILE); }
"for"			{ return ret (_FOR); }

{ID}			{ return ret (_ID); }
.				{ return ret (*yytext); }

%%
