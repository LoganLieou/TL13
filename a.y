%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "AST.h"

#define YYERROR_VERBOSE 1
#define YYDEBUG 1

void yyerror(const char *s);

extern int yylex();
extern int yyparse();
extern int yylineno;
extern FILE *yyin;

int scope = 0; // 0 is global scope and increment as we nest
struct Entry *m = NULL;
%}

%union {
	struct ProgramNode* program;
	struct DeclarationsNode* declaration;
	struct TypeNode* type;
	struct StatementSequenceNode* statementSequence;
	struct StatementNode *statement;
	struct AssignmentNode *assignment;
	struct IfStatementNode *iif;
	struct WriteIntNode *writet;
	struct ElseClauseNode *eelse;
	struct WhileStatementNode *wwhile;
	struct ExpressionNode *expression;
	struct SimpleExpressionNode *simpleExpression;
	struct TermNode *term;
	struct FactorNode *factor;

	char *string;
	char charr;
	int number;
};

%token PROGRAM_TOK
%token BEGIN_TOK
%token END_TOK
%token VAR_TOK
%token AS_TOK
%token SC_TOK
%token INT_TOK
%token BOOL_TOK
%token ASGN_TOK
%token READINT_TOK
%token IF_TOK
%token THEN_TOK
%token ELSE_TOK
%token DO_TOK
%token WHILE_TOK
%token WRITEINT_TOK
%token <charr> OP4_TOK
%token <charr> OP3_TOK
%token <charr> OP2_TOK
%token LP_TOK
%token RP_TOK

%token <number> BOOLLIT_TOK
%token <number> NUM_TOK
%token <string> IDENT_TOK

%type <program> Program
%type <declaration> Declarations
%type <type> Type
%type <statementSequence> StatementSequence
%type <statement> Statement
%type <assignment> Assignment
%type <iif> IfStatement
%type <eelse> ElseClause
%type <wwhile> WhileStatement
%type <writet> WriteInt
%type <expression> Expression
%type <simpleExpression> SimpleExpression
%type <term> Term
%type <factor> Factor

%start Program
%%
Program:
	PROGRAM_TOK Declarations BEGIN_TOK StatementSequence END_TOK
	{
		struct ProgramNode *programNode = (struct ProgramNode*)malloc(sizeof(struct ProgramNode));
		programNode->declarations = (struct DeclarationsNode*)malloc(sizeof($2));
		programNode->declarations = $2;
		programNode->statementSequence = (struct StatementSequenceNode*)malloc(sizeof($4));
		programNode->statementSequence = $4;

		$$ = programNode;

		ProgramGenerator($$);
	}
	;

Declarations:
	VAR_TOK IDENT_TOK AS_TOK Type SC_TOK Declarations
	{
		struct DeclarationsNode *declarations = (struct DeclarationsNode*)malloc(sizeof(struct DeclarationsNode));
		declarations->declarations = (struct DeclarationsNode*)malloc(sizeof($6));
		declarations->declarations = $6;

		declarations->ident = (char *)malloc(sizeof($2));
		declarations->ident = $2;

		// Check for redefinition
		struct Entry *e = NULL;
		HASH_FIND_STR(m, $2, e);
		if (e != NULL) {
			fprintf(stderr, "ERROR: Redefinition of identifier %s\n", $2);
			exit(1);
		}

		// Insert into table
		e = (struct Entry*)malloc(sizeof(struct Entry));
		e->id = $2;
		e->type = $4->type;
		e->scope = scope;
		HASH_ADD_KEYPTR(hh, m, $2, strlen($2), e);

		$$ = declarations;
	}
	|
	{
		$$ = NULL;
	}
	;

Type:
	INT_TOK
	{
		
		struct TypeNode *type = (struct TypeNode*)malloc(sizeof(struct TypeNode));
		type->type = 0;
		$$ = type;
	}
	| BOOL_TOK
	{
		struct TypeNode *type = (struct TypeNode*)malloc(sizeof(struct TypeNode));
		type->type = 1;
		$$ = type;
	}
	;

StatementSequence:
	Statement SC_TOK StatementSequence
	{
		struct StatementSequenceNode *statementSequenceNode = (struct StatementSequenceNode*)malloc(sizeof(struct StatementSequenceNode));
		statementSequenceNode->statement = (struct StatementNode*)malloc(sizeof($1));
		statementSequenceNode->statement = $1;
		statementSequenceNode->statementSequence = (struct StatementSequenceNode*)malloc(sizeof($3));
		statementSequenceNode->statementSequence = $3;

		$$ = statementSequenceNode;
	}
	|
	{
		$$ = NULL;
	}
	;

Statement:
	Assignment
	{
		struct StatementNode* statementNode = (struct StatementNode*)malloc(sizeof(struct StatementNode));

		statementNode->assignment = (struct AssignmentNode*)malloc(sizeof($1));
		statementNode->assignment = $1;

		$$ = statementNode;
	}
	| IfStatement
	{
		struct StatementNode* statementNode = (struct StatementNode*)malloc(sizeof(struct StatementNode));

		statementNode->ifStatement= (struct IfStatementNode*)malloc(sizeof($1));
		statementNode->ifStatement= $1;

		$$ = statementNode;
	}
	| WhileStatement
	{
		struct StatementNode* statementNode = (struct StatementNode*)malloc(sizeof(struct StatementNode));
		statementNode->whileStatement = (struct WhileStatementNode*)malloc(sizeof($1));
		statementNode->whileStatement = $1;

		$$ = statementNode;
	}
	| WriteInt
	{
		struct StatementNode* statementNode = (struct StatementNode*)malloc(sizeof(struct StatementNode));
		statementNode->writeInt = (struct WriteIntNode*)malloc(sizeof($1));
		statementNode->writeInt = $1;

		$$ = statementNode;
	}
	;

Assignment:
	IDENT_TOK ASGN_TOK Expression
	{
		struct AssignmentNode *assignment = (struct AssignmentNode*)malloc(sizeof(struct AssignmentNode));
		assignment->expression = (struct ExpressionNode*)malloc(sizeof($3));
		assignment->expression = $3;
		assignment->ident = (char *)malloc(sizeof($1));
		assignment->ident = $1;

		// Undefined symbol, assignment
		struct Entry *e = NULL;
		HASH_FIND_STR(m, $1, e);
		if (e == NULL) {
			fprintf(stderr, "ERROR: undefined symbol %s\n", $1);
			exit(1);
		}

		// Derive the expression's type
		int r_exp = $3->simpleExpression[0]->term[0]->factor[0]->num ? 0 : 1;
		char *r_exp_id = $3->simpleExpression[0]->term[0]->factor[0]->ident;
		if (r_exp_id) {
			struct Entry *f = NULL;
			HASH_FIND_STR(m, r_exp_id, f);
			if (f != NULL)
				r_exp = f->type;
		}
		if (r_exp != e->type) {
			fprintf(stderr, "ERROR: mismatched types for assignment\n");
			exit(1);
		}

		// Check expression type
		if (ExpressionCheck($3, m) == 0) {
			fprintf(stderr, "ERROR: expression has invalid types");
			exit(1);
		}

		$$ = assignment;
	}
	| IDENT_TOK ASGN_TOK READINT_TOK
	{
		struct AssignmentNode *assignment = (struct AssignmentNode*)malloc(sizeof(struct AssignmentNode));
		assignment->expression = NULL;
		assignment->ident = strdup($1);

		$$ = assignment;
	}
	;

IfStatement:
	IF_TOK Expression THEN_TOK StatementSequence ElseClause END_TOK
	{
		struct IfStatementNode *ifStatement = (struct IfStatementNode*)malloc(sizeof(struct IfStatementNode));
		ifStatement->expression = (struct ExpressionNode*)malloc(sizeof($2));
		ifStatement->expression = $2;
		ifStatement->statementSequence = (struct StatementSequenceNode*)malloc(sizeof($4));
		ifStatement->statementSequence = $4;
		ifStatement->elseClause = (struct ElseClauseNode*)malloc(sizeof($5));
		ifStatement->elseClause = $5;

		// Check expression type
		if (ExpressionCheck($2, m) == 0) {
			fprintf(stderr, "ERROR: expression has invalid types");
			exit(1);
		}

		$$ = ifStatement;
	}
	;

ElseClause:
	ELSE_TOK StatementSequence
	{
		struct ElseClauseNode *elseNode = (struct ElseClauseNode*)malloc(sizeof(struct ElseClauseNode));
		elseNode->statementSequence = (struct StatementSequenceNode*)malloc(sizeof($2));
		elseNode->statementSequence = $2;

		$$ = elseNode;
	}
	| 
	{
		$$ = NULL;
	}
	;

WhileStatement:
	WHILE_TOK Expression DO_TOK StatementSequence END_TOK
	{
		struct WhileStatementNode *whileNode = (struct WhileStatementNode*)malloc(sizeof(struct WhileStatementNode));
		whileNode->expression = (struct ExpressionNode*)malloc(sizeof($2));
		whileNode->expression = $2;
		whileNode->statementSequence = (struct StatementSequenceNode*)malloc(sizeof($4));
		whileNode->statementSequence = $4;

		// Check expression type
		if (ExpressionCheck($2, m) == 0) {
			fprintf(stderr, "ERROR: expression has invalid types");
			exit(1);
		}

		$$ = whileNode;
	}
	;

WriteInt:
	WRITEINT_TOK Expression
	{
		struct WriteIntNode *writeInt = (struct WriteIntNode*)malloc(sizeof(struct WriteIntNode));
		writeInt->expression = (struct ExpressionNode*)malloc(sizeof($2));
		writeInt->expression = $2;

		// Check expression type
		if (ExpressionCheck($2, m) == 0) {
			fprintf(stderr, "ERROR: expression has invalid types");
			exit(1);
		}

		$$ = writeInt;
	}
	;

Expression:
	SimpleExpression OP4_TOK SimpleExpression
	{
		struct ExpressionNode* expression = (struct ExpressionNode*)malloc(sizeof(struct ExpressionNode));
		expression->simpleExpression = (struct SimpleExpressionNode**)malloc(2 * sizeof(struct SimpleExpressionNode*));
		expression->simpleExpression[0] = $1;
		expression->simpleExpression[1] = $3;
		expression->opt = $2;

		$$ = expression;
	}
	| SimpleExpression
	{
		struct ExpressionNode* expression = (struct ExpressionNode*)malloc(sizeof(struct ExpressionNode));
		expression->simpleExpression = (struct SimpleExpressionNode**)malloc(1 * sizeof(struct SimpleExpressionNode*));
		expression->simpleExpression[0] = $1;

		$$ = expression;
	}
	;

SimpleExpression:
	Term OP3_TOK Term
	{
		struct SimpleExpressionNode *simpleExpression = (struct SimpleExpressionNode*)malloc(sizeof(struct SimpleExpressionNode));
		simpleExpression->term = (struct TermNode**)malloc(2 * sizeof(struct TermNode*));
		simpleExpression->term[0] = $1;
		simpleExpression->term[1] = $3;
		simpleExpression->opt = $2;

		$$ = simpleExpression;
	}
	| Term
	{
		struct SimpleExpressionNode *simpleExpression = (struct SimpleExpressionNode*)malloc(sizeof(struct SimpleExpressionNode));
		simpleExpression->term = (struct TermNode**)malloc(1 * sizeof(struct TermNode*));
		simpleExpression->term[0] = $1;

		$$ = simpleExpression;
	}
	;

Term:
	Factor OP2_TOK Factor
	{
		struct TermNode *term = (struct TermNode*)malloc(sizeof(struct TermNode));
		term->factor = (struct FactorNode**)malloc(2 * sizeof(struct FactorNode*));
		term->factor[0] = $1;
		term->factor[1] = $3;
		term->opt = $2;

		$$ = term;
	}
	| Factor
	{
		struct TermNode *term = (struct TermNode*)malloc(sizeof(struct TermNode));
		term->factor = (struct FactorNode**)malloc(1 * sizeof(struct FactorNode*));
		term->factor[0] = $1;

		$$ = term;
	}
	;

Factor:
	IDENT_TOK
	{
		struct FactorNode* factorNode = (struct FactorNode*)malloc(sizeof(struct FactorNode));
		factorNode->ident = (char *)malloc(sizeof($1));
		factorNode->ident = $1;

		// Undefined symbol
		struct Entry *e = NULL;
		HASH_FIND_STR(m, $1, e);
		if (e == NULL) {
			fprintf(stderr, "ERROR: undefined symbol\n");
			exit(1);
		}

		$$ = factorNode;
	}
	| NUM_TOK
	{
		struct FactorNode* factorNode = (struct FactorNode*)malloc(sizeof(struct FactorNode));
		factorNode->num = $1;

		// Edge case when num is 0
		if ($1 == 0) factorNode->num = -1;

		$$ = factorNode;
	}
	| BOOLLIT_TOK
	{
		struct FactorNode* factorNode = (struct FactorNode*)malloc(sizeof(struct FactorNode));
		factorNode->boollit = $1;

		$$ = factorNode;
	}
	| LP_TOK Expression RP_TOK
	{
		struct FactorNode *factor = (struct FactorNode*)malloc(sizeof(struct FactorNode));
		factor->expression = (struct ExpressionNode*)malloc(sizeof(struct ExpressionNode));
		factor->expression = $2;

		// Check expression type
		if (ExpressionCheck($2, m) == 0) {
			fprintf(stderr, "ERROR: expression has invalid types");
			exit(1);
		}

		$$ = factor;
	}
	;
%%

int yywrap() {
	return 1;
}

void yyerror(const char *s) {
	fprintf(stderr, "error: %s in line %d\n", s, yylineno);
	exit(1);
}

int main() {
	return yyparse();
}
