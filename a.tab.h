/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton interface for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     PROGRAM_TOK = 258,
     BEGIN_TOK = 259,
     END_TOK = 260,
     VAR_TOK = 261,
     AS_TOK = 262,
     SC_TOK = 263,
     INT_TOK = 264,
     BOOL_TOK = 265,
     ASGN_TOK = 266,
     READINT_TOK = 267,
     IF_TOK = 268,
     THEN_TOK = 269,
     ELSE_TOK = 270,
     DO_TOK = 271,
     WHILE_TOK = 272,
     WRITEINT_TOK = 273,
     OP4_TOK = 274,
     OP3_TOK = 275,
     OP2_TOK = 276,
     LP_TOK = 277,
     RP_TOK = 278,
     BOOLLIT_TOK = 279,
     NUM_TOK = 280,
     IDENT_TOK = 281
   };
#endif
/* Tokens.  */
#define PROGRAM_TOK 258
#define BEGIN_TOK 259
#define END_TOK 260
#define VAR_TOK 261
#define AS_TOK 262
#define SC_TOK 263
#define INT_TOK 264
#define BOOL_TOK 265
#define ASGN_TOK 266
#define READINT_TOK 267
#define IF_TOK 268
#define THEN_TOK 269
#define ELSE_TOK 270
#define DO_TOK 271
#define WHILE_TOK 272
#define WRITEINT_TOK 273
#define OP4_TOK 274
#define OP3_TOK 275
#define OP2_TOK 276
#define LP_TOK 277
#define RP_TOK 278
#define BOOLLIT_TOK 279
#define NUM_TOK 280
#define IDENT_TOK 281




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 22 "a.y"
{
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
}
/* Line 1529 of yacc.c.  */
#line 122 "a.tab.h"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

