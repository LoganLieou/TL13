type program_t = {
  declaration_node : declaration_t option;
  statementseq_node : statementseq_t option;
}

and declaration_t = {
  id : string;
  type_node : type_t option;
  declaration2_node : declaration_t option;
}

and statement_t = {
  assignment_node : assignment_t option;
  if_node : if_t option;
  while_node : while_t option;
  write_node : write_t option;
}

and type_t = {
  t : int
}

and assignment_t = {
  id2 : string;
  expression_node : expression_t option;
}

and if_t = {
  expression_node2 : expression_t option;
  statementseq_node2 : statementseq_t option;
  else_node : else_t option;
}

and else_t = {
  statementseq_node3 : statementseq_t option;
}

and while_t = {
  expression_node3 : expression_t option;
  statementseq_node4 : statementseq_t option;
}

and write_t = {
  expression_node4 : expression_t option;
}

and statementseq_t = {
  statementseq_node6 : statementseq_t option;
  statement_node : statement_t option;
}

and expression_t = {
  simpleexpression_node : simpleexpression_t option list;
  op : char;
}

and simpleexpression_t = {
  term_node : term_t option list;
  op2 : char;
}

and term_t = {
  op3 : char;
  factor_node : factor_t option list;
}

and factor_t = {
  id3 : string;
  num : int;
  boollit : bool;
  expression_node5 : expression_t option;
}

