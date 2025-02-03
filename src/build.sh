#!/bin/sh

ocamllex tl13_lex.mll
ocamlyacc tl13_yac.mly
ocamlc -c tl13_yac.mli
ocamlc -c tl13_lex.ml
ocamlc -c tl13_yac.ml
ocamlc -c tl13.ml
ocamlc -o tl13 tl13_lex.cmo tl13_yac.cmo tl13.cmo
