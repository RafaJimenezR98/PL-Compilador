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
    LETFCURLYBRACKET = 259,
    RIGHTCURLYBRACKET = 260,
    ASIGNACION = 261,
    SUBSTRACT = 262,
    ADD = 263,
    MULTIPLY = 264,
    DIVIDE = 265,
    INCREMENTO = 266,
    DECREMENTO = 267,
    COMMA = 268,
    NUMBER = 269,
    BOOL = 270,
    IDENTIFIER = 271,
    VAR = 272,
    NUMERICVARIABLE = 273,
    STRINGVARIABLE = 274,
    INDEFINIDA = 275,
    CONSTANTE = 276,
    NUMERICCONSTANT = 277,
    BUILTIN = 278,
    STRING = 279,
    IF = 280,
    THEN = 281,
    ELSE = 282,
    END_IF = 283,
    WHILE = 284,
    DO = 285,
    END_WHILE = 286,
    REPETIR = 287,
    UNTIL = 288,
    FOR = 289,
    DESDE = 290,
    PASS = 291,
    END_FOR = 292,
    PRINT = 293,
    PRINT_STRING = 294,
    READ = 295,
    READ_STRING = 296,
    BORRAR = 297,
    LUGAR = 298,
    RAND = 299,
    CONCATENACION = 300,
    O_LOGICO = 301,
    Y_LOGICO = 302,
    MAYOR_QUE = 303,
    MENOR_QUE = 304,
    MENOR_IGUAL = 305,
    MAYOR_IGUAL = 306,
    DISTINTO = 307,
    IGUAL = 308,
    NEGACION = 309,
    SUMA = 310,
    RESTA = 311,
    PRODUCTO = 312,
    DIVISION = 313,
    MODULO = 314,
    DIVISION_ENTERA = 315,
    LPAREN = 316,
    RPAREN = 317,
    UNARIO = 318,
    POTENCIA = 319
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE YYSTYPE;
union YYSTYPE
{
#line 133 "interpreter.y" /* yacc.c:1909  */

  char * identifier; 				 /* NEW in example 7 */
  double number;
  bool logic;						 /* NEW in example 15 */

  //std::string stringvariable;

  lp::ExpNode *expNode;  			 /* NEW in example 16 */
  std::list<lp::ExpNode *>  *parameters;    // New in example 16; NOTE: #include<list> must be in interpreter.l, init.cpp, interpreter.cpp
  std::list<lp::Statement *> *stmts; /* NEW in example 16 */
  lp::Statement *st;				 /* NEW in example 16 */
  lp::AST *prog;					 /* NEW in example 16 */

#line 133 "interpreter.tab.h" /* yacc.c:1909  */
};
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_INTERPRETER_TAB_H_INCLUDED  */
