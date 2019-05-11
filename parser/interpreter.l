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

extern int lineNumber; //!< External line counter

%}


/*! \name REGULAR DEFINITIONS  */

numero  [0-9]

letra [a-zA-Z]

numero1 {numero}+\.?

numero2 {numero}*\.{numero}+

identificador {letra}(_?({letra}|{numero}))*

/* palabras clave */

/* cadena "'"([^']|\\\')*"'" */


%x ERROR

%%

"leer"		{ return READ; }
"leer_cadena"		{ return READ_STRING; }

"escribir"		{ return PRINT; }
"escribir_cadena"		{ return PRINT_STRING; }

"si"		{ return IF; }
"entonces"		{ return THEN; }
"si_no"		{ return ELSE; }
"fin_si"		{ return END_IF; }

"mientras"   {  return WHILE; }
"hacer"    {  return DO; }
"fin_mientras"  {  return END_WHILE;   }

"repetir"    {  return REPEAT;  }
"hasta"     { return UNTIL;   }
"para"     {  return FOR;  }
"fin_para"     { return END_FOR; }
"desde"     {  return SINCE;   }
"paso"      { return  PASS;   }

[ \t] 	{ ; }

\n      {

  lineNumber++;
}

";"		{

			return SEMICOLON;
		}


","		{

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
								lp::NumericVariable *n = new lp::NumericVariable(identifier,VAR,INDEFINIDA,0.0);

								/* A pointer to the new NumericVariable is inserted into the table of symbols */
								table.installSymbol(n);

								return VAR;
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

"-:=" {
   return SUBSTRACT;
}
"+:=" {
   return ADD;
}
"*:=" {
   return MULTIPLY;
}
"/:=" {
   return DIVIDE;
}



"+"   {
   return SUMA;
}
"-"  {
   return RESTA;
}
"*"  {
   return PRODUCTO;
}
"/"  {
   return DIVISION;
}


"||"      {
   return CONCATENACION;
}

">="	{
   return MAYOR_IGUAL;
}
">"	{
   return MAYOR_QUE;
}
"<="	{
   return MENOR_IGUAL;
}
"<"	{
   return MENOR_QUE;
}
"="	{
   return IGUAL;
}
"<>"	{
   return DISTINTO;
}

"("     { return LPAREN; } 			/* NEW in example 3 */
")"	    { return RPAREN; } 			/* NEW in example 3 */

"++" {
   return INCREMENTO;
}
"--" {
   return DECREMENTO;
}

"@".*$ { }


"_mod"		{ return MODULO; }
"_div"		{ return DIVISION_ENTERA; }

"_o"		{ return O_LOGICO; }
"_y"		{ return Y_LOGICO; }
"_no"		{ return NEGACION; }

"_borrar"     { return BORRAR;  }
"_lugar"      { return LUGAR; }

"**"      {return POTENCIA;}

":=" 	{ return ASIGNACION; }		/* NEW in example 7 */

"!="	{ return DISTINTO; }		/* NEW in example 15 */


"&&"	{ return Y_LOGICO; }				/* NEW in example 15 */

"{"		{ return LETFCURLYBRACKET; } 	/* NEW in example 17 */

"}"		{ return RIGHTCURLYBRACKET; }	/* NEW in example 17 */



^# { /* The interpreter finishes when the symbol # is written at the beginning of the line */
	/* std::cout << CLEAR_SCREEN; */
	/*  PLACE(24,10); */
  	  std::cout <<  BIYELLOW;
   	  std::cout <<  ">>>>>>> End of program <<<<<<<";
 	  std::cout << std::endl;
   	  std::cout << RESET;
	 /* PLACE(25,1); */

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
