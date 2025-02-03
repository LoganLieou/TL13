(* File lexer.mll *)
{
open Tl13_yac (* The type token is defined in parser.mli *)
exception Eof
}
rule token = parse
  [' ' '\t']     { token lexbuf }     (* skip blanks *)
  | ['\n' ]        { EOL }
  | ['0'-'9']+ as lxm { INT(int_of_string lxm) }
  | '+'            { PLU }
  | '-'            { MIN }
  | '*'            { MUL }
  | '/'            { DIV }
  | '('            { LPAREN }
  | ')'            { RPAREN }
  | eof            { raise Eof }
