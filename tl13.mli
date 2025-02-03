type token =
  | INT of (
# 1 "tl13.mly"
        int
# 6 "tl13.mli"
)
  | PLU
  | MIN
  | MUL
  | DIV
  | LPAREN
  | RPAREN
  | EOL

val main :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> int
