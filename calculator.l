%{
    #include "calculator.tab.h"
    #include "string.h"
    int yyerror (const char *);

    size_t offset;

    #define YY_USER_ACTION         \
    offset += yyleng;            \
    yylloc.last_line = yylineno; \
    yylloc.last_column = offset;

    #define BEFORE_ACTION \
    yylloc.first_line = yylloc.last_line; \
    yylloc.first_column = yylloc.last_column;
%}

%%
[0-9]+ {
    BEFORE_ACTION
    yylval.NUM = atoi(yytext);
    return NUM;
}

log {
    yylval.LOG = strdup(yytext);
    return LOG;
}

sin {
    yylval.SIN = strdup(yytext);
    return SIN;
}

cos {
    yylval.COS = strdup(yytext);
    return COS;
}

[a-zA-Z]+ {
    yylval.VAR = strdup(yytext);
    return VAR;
}

[\n]    { offset = 0; yylloc.last_column = 0; yylloc.last_line = 0; return *yytext; }
[-+()=/*^] { BEFORE_ACTION return *yytext; }

[ \t]   ;

.   yyerror("invalid character");
%%

int yywrap(void) {
    return 1;
}

    char* copy_string(char* from, int size);
