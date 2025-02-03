open Ast

let _ =
  try
    let lexbuf = Lexing.from_channel stdin in
    while true do
      let result = Tl13_yac.main Tl13_lex.token lexbuf in
        print_int result; print_newline(); flush stdout
    done
  with Tl13_lex.Eof ->
    exit 0
