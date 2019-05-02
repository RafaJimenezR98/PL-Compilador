/*

 Ejemplo 9

  Se ha ampliado el ejemplo 8 para permitir
  - operadores relacionales y l�gicos
  - sentencia condicional: if
  - sentencia iterativa: while
  - ejecutar las sentencias contenidas en un fichero indicado en la l�nea de comandos
    Por ejemplo:
       > ./ejemplo9.exe factorial.txt
*/

%{
#include <stdio.h>
#include <math.h>
#include <time.h>
#include <stdlib.h>
#include <string.h>

#include "../code/code.h"

#include "../include/macros.h"

#define code2(c1,c2)           code(c1); code(c2)
#define code3(c1,c2,c3)        code(c1); code(c2); code(c3)
#define code4(c1,c2,c3,c4)     code(c1); code(c2); code(c3); code(c4)
#define code5(c1,c2,c3,c4,c5)  code(c1); code(c2); code(c3); code(c4); code(c5);
%}

%union{
       Symbol *sym;    /* puntero a la tabla de simbolos */
       Inst *inst;     /* instruccion de maquina */
}

%token <sym> CHAR NUMBER VAR CONSTANTE INDEFINIDA
             FUNCION0_PREDEFINIDA FUNCION1_PREDEFINIDA FUNCION2_PREDEFINIDA
             IF THEN ELSE END_IF
             WHILE DO END_WHILE
             REPEAT UNTIL
             FOR SINCE PASS END_FOR
             PRINT PRINT_STRING READ READ_STRING
             BORRAR LUGAR
             RAND
%type <inst> stmt asgn var_asig expr stmtlist cond if while repeat for end
%right ASIGNACION SUBSTRACT ADD MULTIPLY DIVIDE INCREMENTO DECREMENTO
%left O_LOGICO
%left Y_LOGICO
%left MAYOR_QUE MENOR_QUE MENOR_IGUAL MAYOR_IGUAL DISTINTO IGUAL
%left CONCATENACION
%left '+' '-'
%left '*' '/' MODULO DIVISION_ENTERA POTENCIA
%left UNARIO NEGACION
%%

list :    /* nada: epsilon produccion */
        | list stmt  ';' {code(STOP); return 1;}
        | list error ';'   {yyerrok;}
        ;

stmt :    /* nada: epsilon produccion */  {$$=progp;}
        | asgn          {code(pop2);}
	| PRINT expr    {code(escribir); $$ = $2;}
	| PRINT_STRING expr   {code(escribir_cadena); $$ = $2;}
        | READ '(' VAR ')'    {code2(leervariable,(Inst)$3);}
        | READ_STRING '(' VAR ')'    {code2(leervariable_cadena,(Inst)$3);}
        | BORRAR                {code(borrar);}
        | LUGAR '(' expr ',' expr ')'   {code(lugar); $$=$3;}
        | while cond DO stmtlist END_WHILE end
                  {
                   ($1)[1]=(Inst)$4; /* cuerpo del bucle */
                   ($1)[2]=(Inst)$6; /* siguiente instruccion al bucle */
                  }
        | if cond THEN stmtlist END_IF end /* proposicion if sin parte else */
                  {
                   ($1)[1]=(Inst)$4; /* cuerpo del if */
                   ($1)[3]=(Inst)$6; /* siguiente instruccion al if */
                  }
        | if cond THEN stmtlist end ELSE stmtlist END_IF end /* proposicion if con parte else */
                  {
                   ($1)[1]=(Inst)$4; /* cuerpo del if */
                   ($1)[2]=(Inst)$7; /* cuerpo del else */
                   ($1)[3]=(Inst)$9; /* siguiente instruccion al if-else */
                  }
        | repeat stmtlist UNTIL cond end
                {
                 ($1)[1]=(Inst)$2;
                 ($1)[2]=(Inst)$4;
                 ($1)[3]=(Inst)$5;
                }
        | for var_asig SINCE expr end UNTIL expr end PASS expr end DO stmtlist END_FOR end
                  {
                   ($1)[1]=(Inst)$7;
                   ($1)[2]=(Inst)$10;
                   ($1)[3]=(Inst)$13;
                   ($1)[4]=(Inst)$15;
                  }
        ;


asgn :    VAR ASIGNACION expr { $$=$3; code3(varpush,(Inst)$1,assign);}
        | VAR ADD expr { $$=code3(varpush,(Inst)$1,add);}
        | VAR SUBSTRACT expr { $$=code3(varpush,(Inst)$1,substract);}
        | VAR MULTIPLY expr { $$=code3(varpush,(Inst)$1,multiply);}
        | VAR DIVIDE expr { $$=code3(varpush,(Inst)$1,divide);}
        | INCREMENTO VAR {$$=code3(varpush, (Inst)$2, preincremento);}
        | VAR INCREMENTO {$$=code3(varpush, (Inst)$1, postincremento);}
        | DECREMENTO VAR {$$=code3(varpush, (Inst)$2, predecremento);}
        | VAR DECREMENTO {$$=code3(varpush, (Inst)$1, postdecremento);}
        | CONSTANTE ASIGNACION expr
          {execerror(" NO se pueden asignar datos a constantes ",$1->nombre);}
	;

cond :    '(' expr ')' {code(STOP); $$ =$2;}
        ;

var_asig :  VAR {code((Inst)$1); $$=progp;}
        ;

while:    WHILE      {$$= code3(whilecode,STOP,STOP);}
        ;

if:       IF         {$$= code(ifcode); code3(STOP,STOP,STOP);}
        ;

repeat:   REPEAT     {$$= code4(repeatcode,STOP,STOP,STOP);}
        ;

for:    FOR       {$$= code5(forcode,STOP,STOP,STOP,STOP);}
        ;

end :    /* nada: produccion epsilon */  {code(STOP); $$ = progp;}
        ;

stmtlist:  /* nada: prodcuccion epsilon */ {$$=progp;}
        | stmtlist stmt ';'
        ;

expr :    NUMBER     		{$$=code2(constpush,(Inst)$1);}
        | RAND                  {$$=code(randpush);}
        | CHAR                  {$$=code2(charpush,(Inst)$1);}
        | VAR        		{$$=code3(varpush,(Inst)$1,eval);}
        | CONSTANTE      	{$$=code3(varpush,(Inst)$1,eval);}
        | asgn
        | FUNCION0_PREDEFINIDA '(' ')'      {code2(funcion0,(Inst)$1->u.ptr);}
        | FUNCION1_PREDEFINIDA '(' expr ')' {$$=$3;code2(funcion1,(Inst)$1->u.ptr);}
        | FUNCION2_PREDEFINIDA '(' expr ',' expr ')'
                                            {$$=$3;code2(funcion2,(Inst)$1->u.ptr);}
        | '(' expr ')'  	{$$ = $2;}
        | expr '+' expr 	{code(sumar);}
        | expr '-' expr 	{code(restar);}
        | expr '*' expr 	{code(multiplicar);}
        | expr '/' expr 	{code(dividir);}
        | expr MODULO expr      {code(modulo);}
        | expr DIVISION_ENTERA expr {code(div_entera);}
        | expr POTENCIA expr 	{code(potencia);}
        | expr CONCATENACION expr {code(concatenacion);}
        |'-' expr %prec UNARIO 	{$$=$2; code(negativo);}
        |'+' expr %prec UNARIO 	{$$=$2; code(positivo);}
        | expr MAYOR_QUE expr 	{code(mayor_que);}
        | expr MAYOR_IGUAL expr {code(mayor_igual);}
        | expr MENOR_QUE expr 	{code(menor_que);}
        | expr MENOR_IGUAL expr {code(menor_igual);}
        | expr IGUAL expr 	{code(igual);}
        | expr DISTINTO expr 	{code(distinto);}
        | expr Y_LOGICO expr 	{code(y_logico);}
        | expr O_LOGICO expr 	{code(o_logico);}
        | NEGACION expr 	{$$=$2; code(negacion);}
      	;

%%

#include <stdio.h>
#include <ctype.h>
#include <signal.h>
#include <setjmp.h>

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

void yyerror(char *s)
{
 warning(s,(char *) 0);
}

void warning(char *s, char *t)
{
 fprintf(stderr," ** %s : %s", progname,s);
 if (t) fprintf(stderr," ---> %s ",t);
 fprintf(stderr,"  (linea %d)\n",lineno);
}

void execerror(s,t) /* recuperacion de errores durante la ejecucion */
char *s,*t;
{
 warning(s,t);
  longjmp(begin,0);
}

void fpecatch()     /*  atrapa errores de punto flotante */
{
 execerror("error de punto flotante ",(char *)0);
}
