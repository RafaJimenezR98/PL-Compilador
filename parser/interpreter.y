/*!
  \file interpreter.y
  \brief Grammar file
*/


%{
#include <iostream>
#include <string>

/*******************************************/

/* pow */
#include <math.h>
/*******************************************/

/*******************************************/

/* Use for recovery of runtime errors */
#include <setjmp.h>
#include <signal.h>
/*******************************************/

/* Error recovery functions */
#include "../error/error.hpp"

/* Macros for the screen */
#include "../includes/macros.hpp"


/*******************************************/
/*

  AST class
  IMPORTANT: this file must be before init.hpp
*/
#include "../ast/ast.hpp"


/*******************************************/

/* Table of symbol */
#include "../table/table.hpp"
/*******************************************/

/*******************************************/
#include "../table/numericVariable.hpp"
/*******************************************/


#include "../table/logicalVariable.hpp"

/*******************************************/

#include "../table/numericConstant.hpp"
/*******************************************/

/*******************************************/
#include "../table/logicalConstant.hpp"
/*******************************************/

/*******************************************/
#include "../table/builtinParameter1.hpp"
/*******************************************/

/*******************************************/
#include "../table/builtinParameter0.hpp"
#include "../table/builtinParameter2.hpp"
/*******************************************/

#include "../table/stringVariable.hpp"


/*******************************************/
#include "../table/init.hpp"
/*******************************************/

/*!
	\brief  Lexical or scanner function
	\return int
	\note   C++ requires that yylex returns an int value
	\sa     yyparser
*/
int yylex();

extern int lineNumber; //!< External line counter

extern int control;


extern bool interactiveMode; //!< Control the interactive mode of execution of the interpreter


/***********************************************************/

extern std::string progname; //!<  Program name
/***********************************************************/

/*******************************************/

/*
 jhmp_buf
    This is an array type capable of storing the information of a calling environment to be restored later.
   This information is filled by calling macro setjmp and can be restored by calling function longjmp.
*/
jmp_buf begin; //!<  It enables recovery of runtime errors
/*******************************************/


/*******************************************/

extern lp::Table table; //!< Extern Table of Symbols

/*******************************************/

extern lp::AST *root; //!< External root of the abstract syntax tree AST

%}



/* In case of a syntactic error, more information is shown */
%error-verbose

/* Initial grammar symbol */
%start program

/*******************************************/
/* Data type YYSTYPE  */

%union {
  char * identifier; 				 
  double number;
  bool logic;						 

  std::string *stringvariable;

  lp::ExpNode *expNode;  			 
  std::list<lp::ExpNode *>  *parameters;   
  std::list<lp::Statement *> *stmts; 
  lp::Statement *st;				 
  lp::AST *prog;					 
}

/* Type of the non-terminal symbols */

%type <expNode> exp cond


%type <parameters> listOfExp  restOfListOfExp

%type <stmts> stmtlist


%type <st> stmt asgn print read if while dowhile for borrar lugar escribir_cadena leer_cadena

%type <prog> program

// Defined token

/* Minimum precedence */

/*******************************************/

%token SEMICOLON
/*******************************************/


%token COMMA

%token LETFCURLYBRACKET RIGHTCURLYBRACKET


%right ASIGNACION SUBSTRACT ADD MULTIPLY DIVIDE INCREMENTO DECREMENTO


/*******************************************/

%token <number> NUMBER
/*******************************************/

/*******************************************/

%token <logic> BOOL

%token <stringvariable> STRING

%token <sval> TOK_EMPTY_LINE
/*******************************************/

 /* %token <string> STRING */


%token <identifier> IDENTIFIER VAR NUMERICVARIABLE STRINGVARIABLE INDEFINIDA CONSTANTE NUMERICCONSTANT BUILTIN

%token       IF THEN ELSE END_IF
             WHILE DO END_WHILE
             REPETIR UNTIL
             FOR DESDE PASS END_FOR
             PRINT PRINT_STRING READ READ_STRING
             BORRAR LUGAR
             RAND CONCATENACION

/* Left associativity */

/*******************************************************/

%left O_LOGICO

%left Y_LOGICO

%nonassoc MAYOR_QUE MENOR_QUE MENOR_IGUAL MAYOR_IGUAL DISTINTO IGUAL

%left NEGACION
/*******************************************************/


%left SUMA RESTA


%left PRODUCTO DIVISION MODULO DIVISION_ENTERA

%left LPAREN RPAREN

%nonassoc  UNARIO

// Maximum precedence
%right POTENCIA


%%
//! \name Grammar rules


program : stmtlist
		  {
		    // Create a new AST
			$$ = new lp::AST($1);

			// Assign the AST to the root
			root = $$;

			// End of parsing
			//	return 1;
		  }
;

stmtlist:  /* empty: epsilon rule */
		  {
			// create a empty list of statements
			$$ = new std::list<lp::Statement *>();
		  }

        | stmtlist stmt
		  {
			// copy up the list and add the stmt to it
			$$ = $1;
			$$->push_back($2);

			// Control the interative mode of execution of the interpreter
			if ( (interactiveMode == true) && (control == 0) )
 			   $2->evaluate();
           }


        | stmtlist error
           {
			// just copy up the stmtlist when an error occurs
			$$ = $1;

			// The previous look-ahead token ought to be discarded with `yyclearin;'
			yyclearin;
           }
;


stmt: SEMICOLON  /* Empty statement: ";" */
	  {
		// Create a new empty statement node
		$$ = new lp::EmptyStmt();
	  }
	| asgn  SEMICOLON
	  {
		// Default action
		// $$ = $1;
	  }
	| print SEMICOLON
	  {
		// Default action
		// $$ = $1;
	  }
	| read SEMICOLON
	  {
		// Default action
		// $$ = $1;
	  }

		| escribir_cadena SEMICOLON
 	 {
 		// Default action
 		// $$ = $1;
 	 }
   | leer_cadena SEMICOLON
 	 {
 		// Default action
 		// $$ = $1;
 	 }
  | borrar SEMICOLON
  	 {
  		// Default action
  		// $$ = $1;
  	 }
  | lugar SEMICOLON
     	{
     		// Default action
     		// $$ = $1;
     	}
	| if
	 {
		// Default action
		// $$ = $1;
	 }
	| while
	 {
		// Default action
		// $$ = $1;
	 }
   | dowhile
 	 {
 		// Default action
 		// $$ = $1;
 	 }
   | for
 	 {
 		// Default action
 		// $$ = $1;
 	 }
;

SimboloControl: {control++;}
  ;


if:	/* Simple conditional statement */
	IF  SimboloControl cond THEN stmtlist END_IF
    {
		// Create a new if statement node
		$$ = new lp::IfStmt($3, $5);

    control--;
	}

	/* Compound conditional statement */
	| IF SimboloControl cond THEN stmtlist ELSE stmtlist END_IF
	 {
		// Create a new if statement node
		$$ = new lp::IfStmt($3, $5, $7);
    control--;
	 }
;


while:  WHILE SimboloControl cond DO stmtlist END_WHILE
		{
			// Create a new while statement node
			$$ = new lp::WhileStmt($3, $5);
      control--;
        }
;

dowhile:  REPETIR SimboloControl stmtlist UNTIL cond
		{
			// Create a new while statement node
			$$ = new lp::DoWhileStmt($5, $3);
      control--;
        }
;

for:  FOR SimboloControl VAR DESDE exp UNTIL exp PASS exp DO stmtlist END_FOR
    {
    // Create a new while statement node
      $$ = new lp::ForStmt($3, $5, $7, $9, $11);
      control--;
        }
    |  FOR SimboloControl VAR DESDE exp UNTIL exp DO stmtlist END_FOR
  		{
  			// Create a new while statement node
  			$$ = new lp::ForStmt($3, $5, $7, $9);
        control--;
          }
;


cond: 	LPAREN exp RPAREN
		{
			$$ = $2;
		}
;


asgn:   VAR ASIGNACION exp
		{
			// Create a new assignment node
			$$ = new lp::AssignmentStmt($1, $3);
		}

	|  VAR ASIGNACION asgn
		{
			// Create a new assignment node
			$$ = new lp::AssignmentStmt($1, (lp::AssignmentStmt *) $3);
		}


	| CONSTANTE ASIGNACION exp
		{
 			execerror("Semantic error in assignment: it is not allowed to modify a constant ", $1);
		}

	| CONSTANTE ASIGNACION asgn
		{
 			execerror("Semantic error in multiple assignment: it is not allowed to modify a constant ",$1);
		}
;


print:  PRINT LPAREN exp RPAREN
		{
			// Create a new print node
			 $$ = new lp::PrintStmt($3);
		}
;

escribir_cadena:  PRINT_STRING LPAREN exp RPAREN
		{
			// Create a new print node
			 $$ = new lp::PrintStringStmt($3);
		}
;

read:  READ LPAREN VAR RPAREN
		{
			// Create a new read node
			 $$ = new lp::ReadStmt($3);
		}


	| READ LPAREN CONSTANTE RPAREN
		{
 			execerror("Semantic error in \"read statement\": it is not allowed to modify a constant ",$3);
		}
;

leer_cadena:  READ_STRING LPAREN VAR RPAREN
		{
			// Create a new read node
			 $$ = new lp::ReadStringStmt($3);
		}
;

borrar: BORRAR
    {

      $$ = new lp::DeleteStmt();

    }

lugar: LUGAR LPAREN exp COMMA exp RPAREN
    {

      $$ = new lp::PlaceStmt($3, $5);

    }

exp:	NUMBER
		{
			// Create a new number node
			$$ = new lp::NumberNode($1);
		}

	| 	exp SUMA exp
		{
			// Create a new plus node
			 $$ = new lp::PlusNode($1, $3);
		 }

	| 	exp RESTA exp
      	{
			// Create a new minus node
			$$ = new lp::MinusNode($1, $3);
		}

	| 	exp PRODUCTO exp
		{
			// Create a new multiplication node
			$$ = new lp::MultiplicationNode($1, $3);
		}

	| 	exp DIVISION exp
		{
		  // Create a new division node
		  $$ = new lp::DivisionNode($1, $3);
	   }

  | 	exp DIVISION_ENTERA exp
   	{
   		 // Create a new division node
   		 $$ = new lp::DivisionEnteraNode($1, $3);
   	}

	| 	LPAREN exp RPAREN
       	{
		    // just copy up the expression node
			$$ = $2;
		 }

  	| 	SUMA exp %prec UNARIO
		{
		  // Create a new unary plus node
  		  $$ = new lp::UnaryPlusNode($2);
		}

	| 	RESTA exp %prec UNARIO
		{
		  // Create a new unary minus node
  		  $$ = new lp::UnaryMinusNode($2);
		}

	|	exp MODULO exp
		{
		  // Create a new modulo node

		  $$ = new lp::ModuloNode($1, $3);
       }

	|	exp POTENCIA exp
     	{
		  // Create a new power node
  		  $$ = new lp::PowerNode($1, $3);
		}
    |	exp CONCATENACION exp
       	{
  		  // Create a new power node
    		  $$ = new lp::ConcatNode($1, $3);
  		}

	 | VAR
		{
		  // Create a new variable node
		  $$ = new lp::VariableNode($1);
		}

	 | CONSTANTE
		{
		  // Create a new constant node
		  $$ = new lp::ConstantNode($1);

		}

    | 	STRING
  		{
  			// Create a new plus node
  			 $$ = new lp::StringNode($1);
  		 }

	| BUILTIN LPAREN listOfExp RPAREN
		{
			// Get the identifier in the table of symbols as Builtin
			lp::Builtin *f= (lp::Builtin *) table.getSymbol($1);

			// Check the number of parameters
			if (f->getNParameters() ==  (int) $3->size())
			{
				switch(f->getNParameters())
				{
					case 0:
						{
							// Create a new Builtin Function with 0 parameters node
							$$ = new lp::BuiltinFunctionNode_0($1);
						}
						break;

					case 1:
						{
							// Get the expression from the list of expressions
							lp::ExpNode *e = $3->front();

							// Create a new Builtin Function with 1 parameter node
							$$ = new lp::BuiltinFunctionNode_1($1,e);
						}
						break;

					case 2:
						{
							// Get the expressions from the list of expressions
							lp::ExpNode *e1 = $3->front();
							$3->pop_front();
							lp::ExpNode *e2 = $3->front();

							// Create a new Builtin Function with 2 parameters node
							$$ = new lp::BuiltinFunctionNode_2($1,e1,e2);
						}
						break;

					default:
				  			 execerror("Syntax error: too many parameters for function ", $1);
				}
			}
			else
	  			 execerror("Syntax error: incompatible number of parameters for function", $1);
		}

	| exp MAYOR_QUE exp
	 	{
		  // Create a new "greater than" node
 			$$ = new lp::GreaterThanNode($1,$3);
		}

	| exp MAYOR_IGUAL exp
	 	{
		  // Create a new "greater or equal" node
 			$$ = new lp::GreaterOrEqualNode($1,$3);
		}

	| exp MENOR_QUE exp
	 	{
		  // Create a new "less than" node
 			$$ = new lp::LessThanNode($1,$3);
		}

	| exp MENOR_IGUAL exp
	 	{
		  // Create a new "less or equal" node
 			$$ = new lp::LessOrEqualNode($1,$3);
		}

	| exp IGUAL exp
	 	{
		  // Create a new "equal" node
 			$$ = new lp::EqualNode($1,$3);
		}

    | exp DISTINTO exp
	 	{
		  // Create a new "not equal" node
 			$$ = new lp::NotEqualNode($1,$3);
		}

    | exp Y_LOGICO exp
	 	{
		  // Create a new "logic and" node
 			$$ = new lp::AndNode($1,$3);
		}

    | exp O_LOGICO exp
	 	{
		  // Create a new "logic or" node
 			$$ = new lp::OrNode($1,$3);
		}

    | NEGACION exp
	 	{
		  // Create a new "logic negation" node
 			$$ = new lp::NotNode($2);
		}
;


listOfExp:
			/* Empty list of numeric expressions */
			{
			    // Create a new list STL
				$$ = new std::list<lp::ExpNode *>();
			}

	|  exp restOfListOfExp
			{
				$$ = $2;

				// Insert the expression in the list of expressions
				$$->push_front($1);
			}
;

restOfListOfExp:
			/* Empty list of numeric expressions */
			{
			    // Create a new list STL
				$$ = new std::list<lp::ExpNode *>();
			}

		|	COMMA exp restOfListOfExp
			{
				// Get the list of expressions
				$$ = $3;

				// Insert the expression in the list of expressions
				$$->push_front($2);
			}
;



%%
