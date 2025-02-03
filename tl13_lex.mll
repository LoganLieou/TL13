{
open Tl13_yac
exception Eof
}

rule token = parse [' ' '\t'] { token lexbuf }
  | ['\n'] { EOL }
  | '+' { PLU }
  | '-' { MIN }
  | '*' { MUL }
  | '/' { DIV }
  | '(' { LPAREN }
  | ')' { RPAREN }
  | eof { raise Eof }
