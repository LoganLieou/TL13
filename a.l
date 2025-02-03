%{
#include <stdio.h>
#include <stdlib.h>
#include "a.tab.h"
%}

%option noyywrap
%option yylineno

%%
"if"      { return IF_TOK; }
"then"    { return THEN_TOK; }
"else"    { return ELSE_TOK; }
"begin"   { return BEGIN_TOK; }
"end"     { return END_TOK; }
"do"      { return DO_TOK; }
"while "  { return WHILE_TOK; }
"program" { return PROGRAM_TOK; }
"var"     { return VAR_TOK; }
"as"      { return AS_TOK; }
"int"     { return INT_TOK; }
"bool"    { return BOOL_TOK; }

[1-9][0-9]*|0 { 
    yylval.number = atoi(yytext);
    return NUM_TOK; 
}

"true" { yylval.number = 2; return BOOLLIT_TOK; }
"false" { yylval.number = 1; return BOOLLIT_TOK; }

[A-Z][A-Z0-9_]* {
    yylval.string = NULL;
    char *temp = malloc(sizeof(yytext));
    strcpy(temp, yytext);
    yylval.string = temp;
    return IDENT_TOK; 
}

"("  { return LP_TOK; }
")"  { return RP_TOK; }
":=" { return ASGN_TOK; }
";"  { return SC_TOK; }

"*"   { yylval.charr = yytext[0]; return OP2_TOK; }
"div" { yylval.charr = '/'; return OP2_TOK; }
"mod" { yylval.charr = '%'; return OP2_TOK; }

"+" { yylval.charr = yytext[0]; return OP3_TOK; }
"-" { yylval.charr = yytext[0]; return OP3_TOK; }

"="  { yylval.charr = yytext[0]; return OP4_TOK; }
"!=" { yylval.charr = 'n'; return OP4_TOK; }
"<"  { yylval.charr = yytext[0]; return OP4_TOK; }
">"  { yylval.charr = yytext[0]; return OP4_TOK; }
"<=" { yylval.charr = 'l'; return OP4_TOK; }
">=" { yylval.charr = 'g'; return OP4_TOK; }

"writeInt" { return WRITEINT_TOK; }
"readInt"  { return READINT_TOK; }

[ \t\r\n]+  { /* skip over whitespace */ }
.           { /* ignore everything else */ }
%%
