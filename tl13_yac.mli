type token =
  | INT of (
# 1 "tl13_yac.mly"
        int
# 6 "tl13_yac.mli"
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
