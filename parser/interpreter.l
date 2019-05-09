/*!
  \file interpreter.l
  \brief Lexical or scanner file
*/
%{
#include <iostream>

/*********************/
/* NEW in example 4 */
/* atof */
#include <stdlib.h>
/*********************/

/* Macros for the screen */
#include "../includes/macros.hpp"

/*********************/
/*
  NEW in example 16
  AST class
  IMPORTANT: must be written before interpreter.tab.h
*/
#include "../ast/ast.hpp"
/*********************/

/*  interpreter.tab.h contains the numeric values of the tokens produced by the parser */
#include "interpreter.tab.h"

/********************/
/* NEW in example 3 */
#include "../error/error.hpp"
/********************/


/*********************************************/
/* NEW in example 7 */
/* Table of symbols */
#include "../table/table.hpp"

#include "../table/numericVariable.hpp"

extern lp::Table table; //!< External Table of Symbols
/*********************************************/

extern int lineno; //!< External line counter

%}


/*! \name REGULAR DEFINITIONS  */

numero  [0-9]

letra [a-zA-Z]

numero1 {numero}+\.?

numero2 {numero}*\.{numero}+

identificador {letra}(_?({letra}|{numero}))*
identificador_mal_escrito1 {letra}(__+({letra}|{numero}))+
identificador_mal_escrito2 (_|{numero})(_?({letra}|{numero}))+
identificador_mal_escrito3 {letra}(_?({letra}|{numero}))*_+
identificador_mal_escrito4 (_|{numero})+{letra}(__+({letra}|{numero}))+
identificador_mal_escrito5 {letra}(__+({letra}|{numero}))*_+
identificador_mal_escrito6 (_|{numero})("__"+({letra}|{numero}))+_+
identificador_mal_escrito7 _+
identificador_mal_escrito8 (_|{numero})(_?({letra}|{numero}))+_

/* palabras clave */
modulo (?i:_mod)
division_entera (?i:_div)
o_logico (?i:_o)
y_logico (?i:_y)
negacion (?i:_no)
borrar (?i:_borrar)
lugar (?i:_lugar)
rand  (?i:_rand)

//cadena "'"([^']|\\\')*"'"

%x ESTADO_COMENTARIO

%%

{modulo} {return MODULO;}
{division_entera} {return DIVISION_ENTERA;}
{o_logico} {return O_LOGICO;}
{y_logico} {return Y_LOGICO;}
{negacion} {return NEGACION;}
{borrar} {return BORRAR;}
{lugar} {return LUGAR;}
{rand}  {return RAND;}

{numero}+\.?|{numero}*\.{numero}+ {double d;
                                   sscanf(yytext,"%lf",&d);
                                 /* Instala el numero en la tabla de simbolos */
				   yylval.sym=install("",NUMBER,d);
				   return NUMBER;}

{identificador_mal_escrito6} {execerror("identificador mal escrito. No empieza por una letra, tiene varias _ seguidas y termina en _", yytext);}
{identificador_mal_escrito5} {execerror("identificador mal escrito. Varias _ seguidas y termina en _", yytext);}
{identificador_mal_escrito4} {execerror("identificador mal escrito. No empieza por una letra y tiene varias _ seguidas", yytext);}
{identificador_mal_escrito8} {execerror("identificador mal escrito. No empieza por una letra y termina en _", yytext);}
{identificador_mal_escrito3} {execerror("identificador mal escrito. Termina en _", yytext);}
{identificador_mal_escrito2} {execerror("identificador mal escrito. No empieza por una letra", yytext);}
{identificador_mal_escrito1} {execerror("identificador mal escrito. Varias _ seguidas", yytext);}
{identificador_mal_escrito7} {execerror("identificador mal escrito. Solo se escribe _", yytext);}

{identificador} { Symbol *s;
                   for(int i=0; i<strlen(yytext); i++){
                     yytext[i] = tolower(yytext[i]);
                   }

                   if ((s=lookup(yytext)) == 0)
                               s = install (yytext, INDEFINIDA, 0.0);
                    yylval.sym = s;
                    return s->tipo == INDEFINIDA ? VAR : s->tipo;}

/* NEW in example 3 */
/* STATE  */
%x ERROR

/*! \name REGULAR EXPRESSIONS  */
%%

[ \t] 	{ ; }    /* skip white space and tabular */

\n      {
			/* Line counter */
           	lineNumber++;

			/* MODIFIED in example 3 */
			/* COMMENTED in example 5 */
        	/* return NEWLINE; */
        }

";"		{
			/* NEW in example 5 */
			return SEMICOLON;
		}


","		{
			/* NEW in example 14 */
			return COMMA;
		}

{numero1}|{numero2}  {
					  /* MODIFIED in example 4 */
					  /* Conversion of type and sending of the numerical value to the parser */
					   yylval.number = atof(yytext);

                       return NUMBER;
                      }


{identificador}   		 {
						 /* NEW in example 7 */
						 std::string identifier(yytext);

						/*
                          strdup() function returns a pointer to a new string
                          which  is a duplicate of the string yytext
                        */
						  yylval.identifier =  strdup(yytext);

						/* If the identifier is not in the table of symbols then it is inserted */
						 if (table.lookupSymbol(identifier) == false)
							{
								/*
								 The identifier is inserted into the symbol table
								 as undefined Variable with value 0.0
								*/
								lp::NumericVariable *n = new lp::NumericVariable(identifier,VARIABLE,UNDEFINED,0.0);

								/* A pointer to the new NumericVariable is inserted into the table of symbols */
								table.installSymbol(n);

								return VARIABLE;
							}

						/* MODIFIED in example 11 */
						/*
							If the identifier is in the table of symbols then its token is returned
								The identifier can be a variable or a numeric constant
						*/
						else
							{
								lp::Symbol	*s = table.getSymbol(identifier);

/*
								std::cout << "lex: "<< s->getName()
										  << "token " << s->getToken()
  										  << std::endl;
*/

								/*  If the identifier is in the table then its token is returned  */
								return s->getToken();
							}
                     }

"-:=" {return SUBSTRACT;}
"+:=" {return ADD;}
"*:=" {return MULTIPLY;}
"/:=" {return DIVIDE;}

"||"      {return CONCATENACION;}

">="	{return MAYOR_IGUAL;}
">"	{return MAYOR_QUE;}
"<="	{return MENOR_IGUAL;}
"<"	{return MENOR_QUE;}
"="	{return IGUAL;}
"<>"	{return DISTINTO;}

"("     { return LPAREN; } 			/* NEW in example 3 */
")"	    { return RPAREN; } 			/* NEW in example 3 */

"++" {return INCREMENTO;}
"--" {return DECREMENTO;}

"@".*$ { }
"#" {BEGIN ESTADO_COMENTARIO;}
<ESTADO_COMENTARIO>"#" {BEGIN 0;}
<ESTADO_COMENTARIO>. { }
<ESTADO_COMENTARIO>[\n] {lineno++;}

\n      {lineno++;} /* no se devuelve nada, contin�a el analisis l�xico */
.       {return yytext[0];}


"_mod"		{ return MODULO; }
"_div"		{ return DIVISION_ENTERA; }

"_o"		{ return O_LOGICO; }
"_y"		{ return Y_LOGICO; }
"_no"		{ return NEGACION; }

"leer"		{ return READ; }
"leer_cadena"		{ return READ_STRING; }

"escribir"		{ return PRINT; }
"escribir_cadena"		{ return PRINT_STRING; }

"si"		{ return IF; }
"entonces"		{ return THEN; }
"si_no"		{ return ELSE; }
"fin_si"		{ return END_IF; }

"**"      {return POTENCIA;}

":=" 	{ return ASIGNACION; }		/* NEW in example 7 */

"!="	{ return DISTINTO; }		/* NEW in example 15 */


"&&"	{ return Y_LOGICO; }				/* NEW in example 15 */

"{"		{ return LETFCURLYBRACKET; } 	/* NEW in example 17 */

"}"		{ return RIGHTCURLYBRACKET; }	/* NEW in example 17 */



^# { /* The interpreter finishes when the symbol # is written at the beginning of the line */
	// std::cout << CLEAR_SCREEN;
	//  PLACE(24,10);
  	  std::cout <<  BIYELLOW;
   	  std::cout <<  ">>>>>>> End of program <<<<<<<";
 	  std::cout << std::endl;
   	  std::cout << RESET;
	 // PLACE(25,1);

  	  return 0;
	}

<<EOF>> { /* The interpreter finishes when finds the end of file character */
		/*  PLACE(24,10);
	  	  std::cout <<  BICYAN;
	   	  std::cout <<  ">>>>>>> End of file <<<<<<<";
	 	  std::cout << std::endl;
	   	  std::cout << RESET;
		  PLACE(25,1);
		*/
	  	  return 0;
	}


.								{
									/* Any other character */
									/* MODIFIIED in example 3 */
									/* Change to error state */
									BEGIN(ERROR);

									/*
										The current value of yytext
										will be concatenated with the next character
									*/
									yymore();
								}

<ERROR>[^0-9+\-*/()\^% \t\n\;a-zA-Z=<>!&]	{ /* MODIFIED in examples 5, 7, 15 */
								  /* NEW in example 3 */
								  /*
									The current value of yytext
									will be concatenated with the next character
								  */
									yymore();
								}

<ERROR>(.|\n)                {
								/* NEW in example 3 */
								/* Rewind one position */
								yyless(yyleng-1);

								/* Display the error message */
								warning("Lexical error", yytext);

								/* Restore the initial state */
   								BEGIN(INITIAL);
							}
%%
