/* A Bison parser, made by GNU Bison 3.0.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2013 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

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

#ifndef YY_YY_INTERPRETER_TAB_H_INCLUDED
# define YY_YY_INTERPRETER_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    SEMICOLON = 258,
    COMMA = 259,
    LETFCURLYBRACKET = 260,
    RIGHTCURLYBRACKET = 261,
    ASIGNACION = 262,
    SUBSTRACT = 263,
    ADD = 264,
    MULTIPLY = 265,
    DIVIDE = 266,
    INCREMENTO = 267,
    DECREMENTO = 268,
    NUMBER = 269,
    BOOL = 270,
    STRING = 271,
    TOK_EMPTY_LINE = 272,
    IDENTIFIER = 273,
    VAR = 274,
    NUMERICVARIABLE = 275,
    STRINGVARIABLE = 276,
    INDEFINIDA = 277,
    CONSTANTE = 278,
    NUMERICCONSTANT = 279,
    BUILTIN = 280,
    IF = 281,
    THEN = 282,
    ELSE = 283,
    END_IF = 284,
    WHILE = 285,
    DO = 286,
    END_WHILE = 287,
    REPETIR = 288,
    UNTIL = 289,
    FOR = 290,
    DESDE = 291,
    PASS = 292,
    END_FOR = 293,
    PRINT = 294,
    PRINT_STRING = 295,
    READ = 296,
    READ_STRING = 297,
    BORRAR = 298,
    LUGAR = 299,
    RAND = 300,
    CONCATENACION = 301,
    O_LOGICO = 302,
    Y_LOGICO = 303,
    MAYOR_QUE = 304,
    MENOR_QUE = 305,
    MENOR_IGUAL = 306,
    MAYOR_IGUAL = 307,
    DISTINTO = 308,
    IGUAL = 309,
    NEGACION = 310,
    SUMA = 311,
    RESTA = 312,
    PRODUCTO = 313,
    DIVISION = 314,
    MODULO = 315,
    DIVISION_ENTERA = 316,
    LPAREN = 317,
    RPAREN = 318,
    UNARIO = 319,
    POTENCIA = 320
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE YYSTYPE;
union YYSTYPE
{
#line 135 "interpreter.y" /* yacc.c:1909  */

  char * identifier; 				 /* NEW in example 7 */
  double number;
  bool logic;						 /* NEW in example 15 */

  std::string *stringvariable;

  lp::ExpNode *expNode;  			 /* NEW in example 16 */
  std::list<lp::ExpNode *>  *parameters;    // New in example 16; NOTE: #include<list> must be in interpreter.l, init.cpp, interpreter.cpp
  std::list<lp::Statement *> *stmts; /* NEW in example 16 */
  lp::Statement *st;				 /* NEW in example 16 */
  lp::AST *prog;					 /* NEW in example 16 */

#line 134 "interpreter.tab.h" /* yacc.c:1909  */
};
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_INTERPRETER_TAB_H_INCLUDED  */
