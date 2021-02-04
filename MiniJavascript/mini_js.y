%{
#include <string>
#include <iostream>
#include <vector>
#include <map>

using namespace std;

struct Atributos {
    vector<string> v;
};

#define YYSTYPE Atributos

int yylex();
void yyerror( const char* );
int ret( int );

int linha = 1;
int coluna = 1;

int label = 0;
string GOTO( int label ) {
    string temp = ":G" ;
    return temp + to_string(label);
}
string LABEL( int label ) {
    string temp = ":L" ;
    return temp + to_string(label);
}

map<string, int> lets;
void addVar( string var ) {
    if ( lets.count( var ) > 0 ) {
        cerr << "Erro: a variável '" << var
        << "' já foi declarada na linha " << lets[var] << "." << endl;
        exit(1);
    }
    lets[var] = linha;
}
void checkVar( string var ) {
    if ( lets.count( var ) <= 0 ) {
        cerr << "Erro: a variável '" << var
        << "' não foi declarada." << endl;
        exit(1);
    }
}

vector<string> operator+( vector<string>, vector<string> );
vector<string> operator+( vector<string>, string );
vector<string> resolve_enderecos( vector<string> in );
vector<string> newVec = {};
void final( vector<string> );

void print( vector<string> v ) {
    for (auto s : v)
        cout << s << " ";
    cout << endl;
}

%}

%token _NUM
%token _STR

%token _LET
%token _CONST
%token _VAR

%token _ARR
%token _OBJ

%token _LE
%token _GE
%token _EQ
%token _NE
%token _AND
%token _OR

%token _IF
%token _ELSE
%token _WHILE
%token _FOR

%token _ID

%right '='
%nonassoc '!'
%left _OR
%left _AND
%nonassoc '<' '>' _LE _GE _EQ _NE
%left '+' '-'
%left '*' '/' '%'

%start I
%%

I : Cmds    { final( $1.v + "." ); }
  ;

Cmds : Cmd Cmds { $$.v = $1.v + $2.v; }
     |          { $$.v = newVec; }
     ;

Cmd : Decl ';'  { $$.v = $1.v; }
    | Atr  ';'  { $$.v = $1.v + "^"; }
    | Con       { $$.v = $1.v; }
    ;

Decl : _LET Let     { $$.v = $2.v; }
     ;

Let : _ID '=' Expr Let_Loop
        { addVar($1.v[0]); $$.v = $1.v + "&" + $1.v + $3.v + "=" + "^" + $4.v; }
    | _ID Let_Loop
        { addVar($1.v[0]); $$.v = $1.v + "&" + $2.v; }
    ;

Let_Loop : ',' Let  { $$.v = $2.v; }
         |          { $$.v = newVec; }
         ;

Atr : Lvalue '=' Expr   { $$.v = $1.v + $3.v + "="; }
    | LvalP '=' Expr    { $$.v = $1.v + $3.v + "[=]"; }
    ;

Con : _IF Expr Blk { $$.v =
            $2.v + "!" + GOTO(label) + "?" + $3.v + LABEL(label);
            label += 1;
        }
    | _IF Expr Blk _ELSE Blk    { $$.v =
            $2.v + "!" + GOTO(label) + "?"              // if
            + $3.v + GOTO(label+1) + "#"                // then
            + LABEL(label) + $5.v + LABEL(label+1);     // else
            label += 2;
        }
    | _WHILE Expr Blk           { $$.v =
            newVec + LABEL(label) + $2.v + "!" + GOTO(label+1) + "?"
            + $3.v + GOTO(label) + "#"
            + LABEL(label+1);
            label += 2;
        }
    | _FOR '(' Expr ';' Expr ';' Expr ')' Blk   { $$.v =
            $3.v + "^" + LABEL(label) + $5.v + "!" + GOTO(label+1) + "?"
            + $9.v + $7.v + "^" + GOTO(label) + "#"
            + LABEL(label+1);
            label += 2;
        }
    | _FOR '(' Decl ';' Expr ';' Expr ')' Blk   { $$.v =
            newVec + ":Push"
            + $3.v + LABEL(label) + $5.v + "!" + GOTO(label+1) + "?"
            + $9.v + $7.v + "^" + GOTO(label) + "#"
            + LABEL(label+1)
            + ":Pop";
            label += 2;
        }
    ;

Blk : '{' Cmd Cmds '}' { $$.v = newVec + ":Push" + $2.v + $3.v + ":Pop"; }
    | Cmd              { $$.v = newVec + ":Push" + $1.v + ":Pop"; }
    ;

Expr : Expr '+' Expr    { $$.v = $1.v + $3.v + "+"; }
     | Expr '-' Expr    { $$.v = $1.v + $3.v + "-"; }
     | '-' Expr         { $$.v = newVec + "0" + $2.v + "-"; }
     | Expr '*' Expr    { $$.v = $1.v + $3.v + "*"; }
     | Expr '/' Expr    { $$.v = $1.v + $3.v + "/"; }
     | Expr '%' Expr    { $$.v = $1.v + $3.v + "%"; }
     | Expr '<' Expr    { $$.v = $1.v + $3.v + "<"; }
     | Expr '>' Expr    { $$.v = $1.v + $3.v + ">"; }
     | Expr _LE Expr    { $$.v = $1.v + $3.v + "<="; }
     | Expr _GE Expr    { $$.v = $1.v + $3.v + ">="; }
     | Expr _EQ Expr    { $$.v = $1.v + $3.v + "=="; }
     | Expr _NE Expr    { $$.v = $1.v + $3.v + "!="; }
     | Expr _AND Expr   { $$.v = $1.v + $3.v + "&&"; }
     | Expr _OR Expr    { $$.v = $1.v + $3.v + "||"; }
     | '!' Expr         { $$.v = $2.v + "!"; }
     | Expr_Val         { $$.v = $1.v; }
     ;

Expr_Val : Atr              { $$.v = $1.v; }
         | Lvalue           { $$.v = $1.v + "@"; }
         | LvalP            { $$.v = $1.v + "[@]"; }
         | _NUM             { $$.v = $1.v; }
         | _STR             { $$.v = $1.v; }
         | _ARR             { $$.v = $1.v; }
         | _OBJ             { $$.v = $1.v; }
         | '(' Expr ')'     { $$.v = $2.v; }
         ;

Lvalue : _ID    { checkVar($1.v[0]); $$.v = $1.v; }
       ;

LvalP : Lvalue '[' Expr ']' { checkVar($1.v[0]); $$.v = $1.v + "@" + $3.v; }
      | LvalP '[' Expr ']'  { checkVar($1.v[0]); $$.v = $1.v + "[@]" + $3.v; }
      | Lvalue '.' _ID      { checkVar($1.v[0]); $$.v = $1.v + "@" + $3.v; }
      | LvalP '.' _ID       { checkVar($1.v[0]); $$.v = $1.v + "[@]" + $3.v; }
      ;

%%

#include "lex.yy.c"

auto p = &yyunput; // Para evitar uma warning de 'unused variable'

int ret( int token ) {
    yylval.v = { yytext };
    coluna += strlen( yytext );
    return token;
}

void yyerror( const char* msg ) {
    cout << endl << "Erro: " << msg << endl
        << "Linha: " << linha << ", Coluna: " << coluna << endl
        << "Perto de: '" << yylval.v[0] << "'" << endl;
    exit(1);
}

vector<string> operator+( vector<string> a, vector<string> b ) {
    a.insert( a.end(), b.begin(), b.end() );
    return a;
}

vector<string> operator+( vector<string> a, string b ) {
    a.push_back( b );
    return a;
}

vector<string> tira_push_pop( vector<string> in ) {
    vector<string> out;
    for (int i = 0; i < (signed)in.size(); i++) {
        if ( in[i] == ":Push" || in[i] == ":Pop" ) {
        } else {
            out.push_back( in[i] );
        }
    }

    return out;
}

vector<string> resolve_enderecos( vector<string> in ) {
    map<string,int> label;
    vector<string> out;
    for (int i = 0; i < (signed)in.size(); i++) {
        if ( in[i].size() > 2 && in[i][0] == ':' && in[i][1] == 'L' ) {
            label[in[i].substr(2)] = out.size();
        } else {
            out.push_back( in[i] );
        }
    }

    for (int i = 0; i < (signed)out.size(); i++) {
        if ( out[i].size() < 2 || out[i][0] != ':' || out[i][1] != 'G' ) continue;

        string key = out[i].substr(2);
        if ( label.count( key ) > 0 ) {
            out[i] = to_string(label[key]);
        }
    }

    return out;
}

void final( vector<string> a ) {
    // cout << "Final: ";
    auto semPushPop = tira_push_pop( a );
    auto comAddrs = resolve_enderecos( semPushPop );
    print( comAddrs );
}

int main() {
    yyparse();

    cout << endl;

    return 0;
}
