type token =
  | INT of (
# 1 "tl13.mly"
        int
# 6 "tl13.ml"
)
  | PLU
  | MIN
  | MUL
  | DIV
  | LPAREN
  | RPAREN
  | EOL

open Parsing
let _ = parse_error;;
let yytransl_const = [|
  258 (* PLU *);
  259 (* MIN *);
  260 (* MUL *);
  261 (* DIV *);
  262 (* LPAREN *);
  263 (* RPAREN *);
  264 (* EOL *);
    0|]

let yytransl_block = [|
  257 (* INT *);
    0|]

let yylhs = "\255\255\
\001\000\002\000\002\000\002\000\002\000\002\000\002\000\002\000\
\000\000"

let yylen = "\002\000\
\002\000\001\000\003\000\003\000\003\000\003\000\003\000\002\000\
\002\000"

let yydefred = "\000\000\
\000\000\000\000\002\000\000\000\000\000\009\000\000\000\008\000\
\000\000\000\000\000\000\000\000\000\000\001\000\003\000\000\000\
\000\000\006\000\007\000"

let yydgoto = "\002\000\
\006\000\007\000"

let yysindex = "\003\000\
\027\255\000\000\000\000\027\255\027\255\000\000\008\255\000\000\
\022\255\027\255\027\255\027\255\027\255\000\000\000\000\254\254\
\254\254\000\000\000\000"

let yyrindex = "\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\012\255\
\015\255\000\000\000\000"

let yygindex = "\000\000\
\000\000\252\255"

let yytablesize = 33
let yytable = "\008\000\
\009\000\012\000\013\000\001\000\000\000\016\000\017\000\018\000\
\019\000\010\000\011\000\012\000\013\000\004\000\004\000\014\000\
\005\000\005\000\004\000\004\000\000\000\005\000\005\000\010\000\
\011\000\012\000\013\000\003\000\015\000\004\000\000\000\000\000\
\005\000"

let yycheck = "\004\000\
\005\000\004\001\005\001\001\000\255\255\010\000\011\000\012\000\
\013\000\002\001\003\001\004\001\005\001\002\001\003\001\008\001\
\002\001\003\001\007\001\008\001\255\255\007\001\008\001\002\001\
\003\001\004\001\005\001\001\001\007\001\003\001\255\255\255\255\
\006\001"

let yynames_const = "\
  PLU\000\
  MIN\000\
  MUL\000\
  DIV\000\
  LPAREN\000\
  RPAREN\000\
  EOL\000\
  "

let yynames_block = "\
  INT\000\
  "

let yyact = [|
  (fun _ -> failwith "parser")
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'expr) in
    Obj.repr(
# 13 "tl13.mly"
           ( _1 )
# 97 "tl13.ml"
               : int))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 17 "tl13.mly"
        ( _1 )
# 104 "tl13.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'expr) in
    Obj.repr(
# 18 "tl13.mly"
                       ( _2 )
# 111 "tl13.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 19 "tl13.mly"
                  ( _1 + _3 )
# 119 "tl13.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 20 "tl13.mly"
                  ( _1 - _3 )
# 127 "tl13.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 21 "tl13.mly"
                  ( _1 * _3 )
# 135 "tl13.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 22 "tl13.mly"
                  ( _1 / _3 )
# 143 "tl13.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 23 "tl13.mly"
                          ( - _2 )
# 150 "tl13.ml"
               : 'expr))
(* Entry main *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
|]
let yytables =
  { Parsing.actions=yyact;
    Parsing.transl_const=yytransl_const;
    Parsing.transl_block=yytransl_block;
    Parsing.lhs=yylhs;
    Parsing.len=yylen;
    Parsing.defred=yydefred;
    Parsing.dgoto=yydgoto;
    Parsing.sindex=yysindex;
    Parsing.rindex=yyrindex;
    Parsing.gindex=yygindex;
    Parsing.tablesize=yytablesize;
    Parsing.table=yytable;
    Parsing.check=yycheck;
    Parsing.error_function=parse_error;
    Parsing.names_const=yynames_const;
    Parsing.names_block=yynames_block }
let main (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 1 lexfun lexbuf : int)
