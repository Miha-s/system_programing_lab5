%token	INTEGER VARIABLE
%left '+' '-'
%left '*' '/'

%{
#include <stdio.h>
int yyerror(char*);
int yylex();

int sym[26];
%}
%%
program:
	program statement '\n'
	|
	;
statement:
	VARIABLE		{ printf("%c = %d\n", $1+'a', sym[$1]); }
	| expr			{ printf("%d\n", $1); }
	| VARIABLE '=' expr	{ sym[$1] = $3; }
	;
expr:
	INTEGER		{ $$ = $1; }
	| VARIABLE	{ $$ = sym[$1]; }
	| expr '+' expr	{ $$ = $1 + $3; }
	| expr '-' expr { $$ = $1 - $3; }
	| expr '*' expr { $$ = $1 * $3; }
	| expr '/' expr { $$ = $1 / $3; }
	| '(' expr ')' 	{ $$ = $2; }
	;
%%

int yyerror(char *s) {
	fprintf(stderr, "%s\n", s);
	return 0;
}

int main(void) {
	yyparse();
	return 0;
}
