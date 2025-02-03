%token <int> INT
%token PLU MIN MUL DIV
%token LPAREN RPAREN
%token EOL
%left PLU MIN
%left MUL DIV
%nonassoc UMINUS
%start main
%type <int> main

%%
main:
  expr EOL { $1 }
;

expr:
    INT { $1 }
  | LPAREN expr RPAREN { $2 }
  | expr PLU expr { $1 + $3 }
  | expr MIN expr { $1 - $3 }
  | expr MUL expr { $1 * $3 }
  | expr DIV expr { $1 / $3 }
  | MIN expr %prec UMINUS { - $2 }

