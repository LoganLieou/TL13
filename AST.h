#include "a.tab.h"
#include "uthash.h"
#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>

void ProgramGenerator(struct ProgramNode *programNode);
void DeclarationsGenerator(struct DeclarationsNode *declarationsNode);
void IfGenerator(struct IfStatementNode *ifStatementNode);
void StatementSequenceGenerator(struct StatementSequenceNode *statementSequenceNode);
void StatementGenerator(struct StatementNode *statementNode);
void AssignmentGenerator(struct AssignmentNode *assignmentNode);
void WhileGenerator(struct WhileStatementNode *whileStatementNode);
void WriteIntGenerator(struct WriteIntNode *writeIntNode);
void ExpressionGenerator(struct ExpressionNode *expressionNode);
void SimpleExpressionGenerator(struct SimpleExpressionNode *simpleExpressionNode);
void TermGenerator(struct TermNode *termNode);
void FactorGenerator(struct FactorNode *factorNode);

struct Entry {
	char *id;
	int type;
	int scope;
	UT_hash_handle hh;
};

struct ProgramNode {
	struct DeclarationsNode *declarations;
	struct StatementSequenceNode *statementSequence;
};

struct DeclarationsNode {
	char *ident;
	struct TypeNode *typeNode;
	struct DeclarationsNode *declarations;
};

struct TypeNode {
	int type;
};

struct StatementSequenceNode {
	struct StatementNode *statement;
	struct StatementSequenceNode *statementSequence;
};

struct StatementNode {
	struct AssignmentNode *assignment;
	struct IfStatementNode *ifStatement;
	struct WhileStatementNode *whileStatement;
	struct WriteIntNode *writeInt;
};

struct AssignmentNode {
	char *ident;
	struct ExpressionNode *expression;
};

struct IfStatementNode {
	struct ExpressionNode *expression;
	struct StatementSequenceNode *statementSequence;
	struct ElseClauseNode *elseClause;
};

struct ElseClauseNode {
	struct StatementSequenceNode *statementSequence;
};

struct WhileStatementNode {
	struct ExpressionNode *expression;
	struct StatementSequenceNode *statementSequence;
};

struct WriteIntNode {
	struct ExpressionNode *expression;
};

struct ExpressionNode {
	struct SimpleExpressionNode **simpleExpression;
	char opt;
};

struct SimpleExpressionNode {
	struct TermNode **term;
	char opt;
};

struct TermNode {
	char opt;
	struct FactorNode **factor;
};

struct FactorNode {
	char *ident;
	int num;
	int boollit;
	struct ExpressionNode *expression;
};

/**
 * DONE
 * Returns weather the expression has type conflicts
 */
int ExpressionCheck(struct ExpressionNode* expressionNode, struct Entry *m) {
	// Check expression opt
	if (expressionNode->opt) {
		int LHS = expressionNode->simpleExpression[0]->term[0]->factor[0]->num ? 0 : 1;
		int RHS = expressionNode->simpleExpression[1]->term[0]->factor[0]->num ? 0 : 1;

		char *RHSi = expressionNode->simpleExpression[1]->term[0]->factor[0]->ident;
		char *LHSi = expressionNode->simpleExpression[0]->term[0]->factor[0]->ident;

		if (RHSi) {
			struct Entry *e = NULL;
			HASH_FIND_STR(m, RHSi, e);
			if (e != NULL)
				RHS = e->type;
		}
		if (LHSi) {
			struct Entry *e = NULL;
			HASH_FIND_STR(m, LHSi, e);
			if (e != NULL)
				LHS = e->type;
		}

		return LHS == RHS;
	} 
	else
		return 1;
	// Check simple expression opt
	if (expressionNode->simpleExpression[0]->opt) {
		int LHS = expressionNode->simpleExpression[0]->term[0]->factor[0]->num ? 0 : 1;
		int RHS = expressionNode->simpleExpression[0]->term[1]->factor[0]->num ? 0 : 1;

		char *LHSi = expressionNode->simpleExpression[0]->term[0]->factor[0]->ident;
		char *RHSi = expressionNode->simpleExpression[0]->term[1]->factor[0]->ident;

		if (RHSi) {
			struct Entry *e = NULL;
			HASH_FIND_STR(m, RHSi, e);
			if (e != NULL)
				RHS = e->type;
		}
		if (LHSi) {
			struct Entry *e = NULL;
			HASH_FIND_STR(m, LHSi, e);
			if (e != NULL)
				LHS = e->type;
		}

		return LHS == RHS;
	}
	else
		return 1;
	// Check term opt
	if (expressionNode->simpleExpression[0]->term[0]->opt) {
		int LHS = expressionNode->simpleExpression[0]->term[0]->factor[0]->num ? 0 : 1;
		int RHS = expressionNode->simpleExpression[0]->term[0]->factor[1]->num ? 0 : 1;

		char *LHSi = expressionNode->simpleExpression[0]->term[0]->factor[0]->ident;
		char *RHSi = expressionNode->simpleExpression[0]->term[0]->factor[1]->ident;

		if (RHSi) {
			struct Entry *e = NULL;
			HASH_FIND_STR(m, RHSi, e);
			if (e != NULL)
				RHS = e->type;
		}
		if (LHSi) {
			struct Entry *e = NULL;
			HASH_FIND_STR(m, LHSi, e);
			if (e != NULL)
				LHS = e->type;
		}

		return LHS == RHS;
	}
	else
		return 1;
}

/**
 * DONE
 * We assume the above expression checker has already occurred so we pull the
 * first terminal from the expression and find it's type
 */
int ExpressionMatchType(struct ExpressionNode *expressionNode, int type) {
	int fst = expressionNode->simpleExpression[0]->term[0]->factor[0]->num ? 0 : 1;
	return fst == type;
}

/**
 * DONE
 */
void ElseGenerator(struct ElseClauseNode *elseClauseNode) {
	printf("\telse {\n");
	printf("\t");
	StatementSequenceGenerator(elseClauseNode->statementSequence);
	printf("\t}\n");
}

/**
 * DONE
 */
void FactorGenerator(struct FactorNode *factorNode) {
	if (factorNode->expression)
		ExpressionGenerator(factorNode->expression);
	else if (factorNode->ident)
		printf("%s", factorNode->ident);
	else if (factorNode->boollit)
		printf("%d", factorNode->boollit == 2 ? 1 : 0);
	else if (factorNode->num)
		printf("%d", factorNode->num == -1 ? 0 : factorNode->num);
}

/**
 * DONE
 */
void TermGenerator(struct TermNode *termNode) {
	if (!termNode->opt) {
		FactorGenerator(termNode->factor[0]);
	}
	else {
		FactorGenerator(termNode->factor[0]);
		printf(" %c ", termNode->opt);
		FactorGenerator(termNode->factor[1]);
	}
}

/**
 * DONE
 */
void SimpleExpressionGenerator(struct SimpleExpressionNode *simpleExpressionNode) {
	if (!simpleExpressionNode->opt) {
		TermGenerator(simpleExpressionNode->term[0]);
	}
	else {
		TermGenerator(simpleExpressionNode->term[0]);
		printf(" %c ", simpleExpressionNode->opt);
		TermGenerator(simpleExpressionNode->term[1]);
	}
}

/**
 * DONE
 */
void ExpressionGenerator(struct ExpressionNode *expressionNode) {
	if (!expressionNode->opt) {
		SimpleExpressionGenerator(expressionNode->simpleExpression[0]);
	}
	else {
		SimpleExpressionGenerator(expressionNode->simpleExpression[0]);
		switch (expressionNode->opt) {
			case 'l':
				printf(" <= ");
				break;
			case 'g':
				printf(" >= ");
				break;
			case 'n':
				printf(" != ");
				break;
			default:
				printf(" %c ", expressionNode->opt);
				break;
		}
		SimpleExpressionGenerator(expressionNode->simpleExpression[1]);
	}
}

/**
 * DONE
 */
void WriteIntGenerator(struct WriteIntNode *writeIntNode) {
	printf("\tprintf(\"%s\", ", "%d");
	ExpressionGenerator(writeIntNode->expression);
	printf(");\n");
}

/**
 * DONE
 */
void WhileGenerator(struct WhileStatementNode *whileStatementNode) {
	printf("\twhile(");
	ExpressionGenerator(whileStatementNode->expression);
	printf(") {\n");
	printf("\t");
	StatementSequenceGenerator(whileStatementNode->statementSequence);
	printf("\t}\n");
}

/**
 * DONE
 */
void AssignmentGenerator(struct AssignmentNode *assignmentNode) {
	if (assignmentNode->expression) {
		printf("\t%s = ", assignmentNode->ident);
		ExpressionGenerator(assignmentNode->expression);
		printf(";\n");
	} else {
		printf("\tscanf(\"%s\", &%s);\n", "%d", assignmentNode->ident);
	}
}

/**
 * DONE
 */
void StatementGenerator(struct StatementNode *statementNode) {
	if (statementNode->assignment) {
		AssignmentGenerator(statementNode->assignment);
	}
	else if (statementNode->ifStatement) {
		IfGenerator(statementNode->ifStatement);
	}
	else if (statementNode->writeInt) {
		WriteIntGenerator(statementNode->writeInt);
	}
	else if (statementNode->whileStatement) {
		WhileGenerator(statementNode->whileStatement);
	}
}

/**
 * DONE
 */
void StatementSequenceGenerator(struct StatementSequenceNode *statementSequenceNode) {
	if (statementSequenceNode == NULL)
		return;
	StatementGenerator(statementSequenceNode->statement);
	StatementSequenceGenerator(statementSequenceNode->statementSequence);
}

/**
 * DONE
 */
void IfGenerator(struct IfStatementNode *ifStatementNode) {
	printf("\tif (");
	ExpressionGenerator(ifStatementNode->expression);
	printf(") {\n");
	printf("\t");
	StatementSequenceGenerator(ifStatementNode->statementSequence);
	printf("\t}\n");

	if (ifStatementNode->elseClause) {
		ElseGenerator(ifStatementNode->elseClause);
	}
}

/**
 * DONE
 */
void DeclarationsGenerator(struct DeclarationsNode *declarationsNode) {
    if (declarationsNode == NULL)
		return;
    printf("\tint %s;\n", declarationsNode->ident);
    DeclarationsGenerator(declarationsNode->declarations);
}

/**
 * This function generates the entire program.  once the program node is popped
 * the rest of the program is recognized theoretically we only ever need to call
 * this function in a.y
 */
void ProgramGenerator(struct ProgramNode *programNode) {
    printf("#include <stdio.h>\n");
    printf("int main(void) {\n");
    DeclarationsGenerator(programNode->declarations);
    StatementSequenceGenerator(programNode->statementSequence);
    printf("}\n");
}
