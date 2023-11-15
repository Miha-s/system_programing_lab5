%{
  #include <stdio.h> 
  #include <math.h>   
  #include "utils.h" 
  int yylex (void);
  void yyerror (char const *);
%}

%locations
%define api.value.type union /* Generate YYSTYPE from these types: */
%token <double>  NUM     /* Double precision number. */
%token <char*> VAR LOG SIN COS
%nterm <double>  exp

%precedence '='
%left '-' '+'
%left '*' '/'
%precedence NEG /* negation--unary minus */
%right '^'      /* exponentiation */



%% /* The grammar follows. */
input:
  %empty
| input line
;

line:
  '\n'
| exp '\n'   { printf ("%.10g\n", $1); }
| error '\n' { yyerrok;                }
;

exp:
  NUM
| VAR                
{ 
  variable_node* var = get_variable($1);
  if(var == NULL) {
    yyerror("Referencing undefined variable");
    YYERROR;
  }

  $$ = var->value;
}
| VAR '=' exp        { $$ = $3; add_variable($1, $3);    }
| LOG '(' exp ')'
{ 
  if($3 <= 0) {
    yyerror("Non positive number to logarithm");
    YYERROR;
  }

  $$ = log($3);
}
| SIN '(' exp ')'
{
  $$ = sin($3);
}
| COS '(' exp ')'
{
  $$ = cos($3);
}
| exp '+' exp        { $$ = $1 + $3;                    }
| exp '-' exp        { $$ = $1 - $3;                    }
| exp '*' exp        { $$ = $1 * $3;                    }
| exp '/' exp        { $$ = $1 / $3;                    }
| '-' exp  %prec NEG { $$ = -$2;                        }
| exp '^' exp        { $$ = pow ($1, $3);               }
| '(' exp ')'        { $$ = $2;                         }
;
/* End of grammar. */
%%

/* Called by yyparse on error. */
void yyerror (char const *s)
{
  fprintf (stderr, "%s\n", s);
}

int main (int argc, char const* argv[])
{
  init_variable_table();
  return yyparse ();
}