/*!
  \file interpreter.cpp
  \brief Main program
*/

/*!
 \mainpage Flex and Bison: example 17
 \author
 \date     2018 - 4 - 26
 \version  1.0
 \note Novelties
	+ AST: intermidiate code
	+ New statements: if, while, block
*/

#include <stdio.h>
#include <math.h>
#include <time.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <signal.h>
#include <setjmp.h>

#include "code/code.h"

#include "./parser/interpreter.tab.h"

/* Depuracion
 1: habilitada
 0: no habilitada

 Se debe usar
  bison --debug ...
o
  bison -t
*/
int yydebug=0;

/* Nombre del programa */
char *progname;

/* Contador de l�neas */
int lineno = 1;

/* Permite la recuperaci�n de errores */
jmp_buf begin;

/* Dispositivo de entrada est�ndar de yylex() */
extern FILE * yyin;

int main(int argc, char *argv[])
{

 srand(time(NULL));

 /* Si se invoca el int�rprete con un fichero de entrada */
 /* entonces se establece como dispositivo de entrada para yylex() */
 if (argc == 2){
  if(argv[1][strlen(argv[1])-2]!='.' || argv[1][strlen(argv[1])-1]!='e'){
   printf("Error. Extension incorrecta. La extension es \".e\"\n");
   exit(-1);
  }

  yyin = fopen(argv[1],"r");

  if(!yyin){
   printf("Error. No existe el fichero.\n");
   exit(-1);
  }
 }

 progname=argv[0];

 /* inicializacion de la tabla de simbolos */
 init();

/* Establece un estado viable para continuar despues de un error */
 setjmp(begin);

 /* Establece cual va a ser la funcion para tratar errores de punto flotante */
 signal(SIGFPE,fpecatch); /* Excepcion de punto flotante*/

/* initcode inicializa el vector de intrucciones y la pila del interprete */
 for (initcode(); yyparse(); initcode()) execute(prog);

 return 0;

}
