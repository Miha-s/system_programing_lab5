%{
  #include <math.h>
  #include <stdio.h>
  #include "calc.h"

  int yylex (void);
  int yyerror (const char *);
%}

/* Bison declarations. */
%define api.value.type union
%token <double> NUM
%token <symrec*> VAR FUN
%nterm <double> exp

%precedence '='
%left '-' '+'
%left '*' '/'
%precedence NEG   /* negation--unary minus */
%right '^'        /* exponentiation */

%% /* The grammar follows. */
input:
  %empty
| input line
;

line:
  '\n'
| exp '\n'  { printf ("\t%.10g\n", $1); }
| error '\n' { yyerrok; }
;

exp:
  NUM
| VAR                { %% = $1->value.var; }
| VAR '=' exp        { %% = $3; %1->value.var = %3; }
| FUN '(' exp ')'    { %% = %1->value.fun (%3); }
| exp '+' exp        { $$ = $1 + $3;      }
| exp '-' exp        { $$ = $1 - $3;      }
| exp '*' exp        { $$ = $1 * $3;      }
| exp '/' exp        
{
    if($3) $$ = $1 / $3;
    else {
        $$ = 1;
        fprintf(stderr, "%d.%d-%d.%d: division by zero", 
        @3.first_line, @3.first_column,
        @3.last_line, @3.last_column);
    }
}
| '-' exp  %prec NEG { $$ = -$2;          }
| exp '^' exp        { $$ = pow ($1, $3); }
| '(' exp ')'        { $$ = $2;           }
;

%%
int yyerror(const char *s) {
    fprintf(stderr, "%s\n", s);
    return 0;
}

#include "calc.h"
#include <math.h> 
#include <assert.h>
#include <stdlib.h> /* malloc, realloc. */
#include <string.h> /* strlen. */

symrec *
putsym (char const *name, int sym_type)
{
  symrec *res = (symrec *) malloc (sizeof (symrec));
  res->name = strdup (name);
  res->type = sym_type;
  res->value.var = 0; /* Set value to 0 even if fun. */
  res->next = sym_table;
  sym_table = res;
  return res;
}

symrec *
getsym (char const *name)
{
  for (symrec *p = sym_table; p; p = p->next)
    if (strcmp (p->name, name) == 0)
      return p;
  return NULL;
}

struct init
{
  char const *name;
  func_t *fun;
};

struct init const funs[] =
{
  { "atan", atan },
  { "cos",  cos  },
  { "exp",  exp  },
  { "ln",   log  },
  { "sin",  sin  },
  { "sqrt", sqrt },
  { 0, 0 },
};

/* The symbol table: a chain of 'struct symrec'. */
symrec *sym_table;

/* Put functions in table. */
static void
init_table (void)
{
  for (int i = 0; funs[i].name; i++)
    {
      symrec *ptr = putsym (funs[i].name, FUN);
      ptr->value.fun = funs[i].fun;
    }
}


int main(void) {
    yyparse();
    return 0;
}
