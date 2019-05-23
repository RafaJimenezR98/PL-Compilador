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
#include "../table/stringVariable.hpp"

extern lp::Table table; //!< External Table of Symbols
/*********************************************/

extern int lineNumber; //!< External line counter

%}


/*! \name REGULAR DEFINITIONS  */

numero  [0-9]

letra [a-zA-Z]

numero1 {numero}+\.?

numero2 {numero}*\.{numero}+

comentario #([^']|\\\')*#

STRING "'"([^']|\\\')*"'"

identificador {letra}(_?({letra}|{numero}))*

identificador_mal1 {letra}(__+({letra}|{numero}))+
identificador_mal2 (_|{numero})(_?({letra}|{numero}))+
identificador_mal3 {letra}(_?({letra}|{numero}))*_+
identificador_mal4 (_|{numero})+{letra}(__+({letra}|{numero}))+
identificador_mal5 {letra}(__+({letra}|{numero}))*_+
identificador_mal6 (_|{numero})("__"+({letra}|{numero}))+_+
identificador_mal7 _+
identificador_mal8 (_|{numero})(_?({letra}|{numero}))+_

/* palabras clave */

modulo (?i:_mod)
division_entera (?i:_div)

o_logico (?i:_o)
y_logico (?i:_y)
negacion (?i:_no)

leer (?i:leer)
leer_cadena (?i:leer_cadena)

escribir (?i:escribir)
escribir_cadena (?i:escribir_cadena)

si (?i:si)
entonces (?i:entonces)
si_no (?i:si_no)
fin_si (?i:fin_si)

mientras (?i:mientras)
hacer (?i:hacer)
fin_mientras (?i:fin_mientras)

repetir (?i:repetir)
hasta (?i:hasta)

para (?i:para)
desde (?i:desde)
/* hasta (?i:hasta) */
paso (?i:paso)
fin_para (?i:fin_para)

borrar (?i:_borrar)
lugar (?i:_lugar)

concatenacion (||)

%x ERROR

%%

{leer}		{ return READ; }
{leer_cadena}		{ return READ_STRING; }

{escribir}		{ return PRINT; }
{escribir_cadena}		{ return PRINT_STRING; }

{si}		{ return IF; }
{entonces}		{ return THEN; }
{si_no}		{ return ELSE; }
{fin_si}		{ return END_IF; }

{mientras}   {  return WHILE; }
{hacer}    {  return DO; }
{fin_mientras}  {  return END_WHILE;   }

{repetir}    {  return REPETIR;  }
{hasta}     { return UNTIL;   }

{para}     {  return FOR;  }
{desde}     {  return DESDE;   }
{fin_para}     { return END_FOR; }

{paso}      { return  PASS;   }

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
						 /* NEborrar (?i:_borrar)
lugar (?i:_lugar)W in example 7 */
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

{modulo}		{ return MODULO; }
{division_entera}		{ return DIVISION_ENTERA; }

{o_logico}		{ return O_LOGICO; }
{y_logico}		{ return Y_LOGICO; }
{negacion}		{ return NEGACION; }

{borrar}     { return BORRAR;  }
{lugar}      { return LUGAR; }

{comentario} { }

{identificador_mal6} {execerror("identificador mal escrito. No empieza por una letra, tiene varias _ seguidas y termina en _", yytext);}
{identificador_mal5} {execerror("identificador mal escrito. Varias _ seguidas y termina en _", yytext);}
{identificador_mal4} {execerror("identificador mal escrito. No empieza por una letra y tiene varias _ seguidas", yytext);}
{identificador_mal8} {execerror("identificador mal escrito. No empieza por una letra y termina en _", yytext);}
{identificador_mal3} {execerror("identificador mal escrito. Termina en _", yytext);}
{identificador_mal2} {execerror("identificador mal escrito. No empieza por una letra", yytext);}
{identificador_mal1} {execerror("identificador mal escrito. Varias _ seguidas", yytext);}
{identificador_mal7} {execerror("identificador mal escrito. Solo se escribe _", yytext);}

"**"      {return POTENCIA;}

":=" 	{ return ASIGNACION; }		/* NEW in example 7 */

"!="	{ return DISTINTO; }		/* NEW in example 15 */


"&&"	{ return Y_LOGICO; }				/* NEW in example 15 */

"{"		{ return LETFCURLYBRACKET; } 	/* NEW in example 17 */

"}"		{ return RIGHTCURLYBRACKET; }	/* NEW in example 17 */

{STRING}        {
			for(int i = 0; yytext[i] != '\0'; i++)
                	{
				yytext[i] = yytext[i+1];
			}
			yytext[strlen(yytext)-1]='\0';

			int j= 0;
			int k = 0;
			int a = 0;

			for(int i = 0; yytext[i] != '\0'; i++)
                	{
				if(yytext[i]=='\\' && yytext[i+1]=='\'')
				{
					yytext[i]=yytext[i+1];


					if(yytext[i] != '\0')
					{
						k++;
						i++;
						a++;
					}
				}
				yytext[j] = yytext[k];
				j++;
				k++;
			}

			if(a != 0)
				yytext[strlen(yytext)-2]='\0';
			yylval.stringvariable = new std::string (yytext);
			return STRING;
		}

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
