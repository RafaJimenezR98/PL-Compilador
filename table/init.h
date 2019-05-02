#ifndef INIT_H
#define INIT_H

#include <stdio.h>
#include <math.h>
#include <string.h>
#include <stdlib.h>

#include "sintactico.tab.h"

#include "../includes/macros.h"


/* Prototipo de una nueva funcion matematica */
extern double integer(double x), Azar();
/* Prototipos de funciones matematicas que "controlan" posibles errores" */
extern double Log(double x), Log10(double x), Exp(double x), Sqrt(double x),
              Atan2(double x, double y);

static struct{
              char *nombre;
	      double cval;
	      } constantes[] = {
	                    "pi",    3.14159265358979323846,
	                    "e",     2.71828182845904523536,
	                    "gamma", 0.57721566490153286060,
	                    "deg",   57.29577951308232087680,
	                    "phi",   1.61803398874989484820,
	                    0,       0
	                   };

static struct{   /* palabras clave */
              char *nombre;
	      int  kval;
	      } keywords[] = {
                  "si",              IF,
                  "entonces",        THEN,
			      "si_no",           ELSE,
                  "fin_si",          END_IF,
			      "mientras",        WHILE,
                  "hacer",           DO,
                  "fin_mientras",    END_WHILE,
                  "repetir",         REPEAT,
                  "hasta",           UNTIL,
                  "para",            FOR,
                  "desde",           SINCE,
                  "paso",            PASS,
                  "fin_para",        END_FOR,
			      "escribir",        PRINT,
                  "escribir_cadena", PRINT_STRING,
                  "leer",            READ,
                  "leer_cadena",     READ_STRING,
			      0,           0,
                             };

static struct {    /* Nombres predefinidos de funciones */
	       char *nombre;
	       double (*func)();
              } funciones0[] = {
                               "azar", Azar,
                                0, 0
                              },
                funciones1 [] = {
	                       "seno",   sin,
		               "coseno",   cos,
		               "atan",  atan,
		               "log",   Log,
		               "log10", Log10,
		               "exp",   Exp,
		               "raiz",  Sqrt,
		               "entero",   integer,
		               "abs",   fabs,
		               0,       0
		              },
              funciones2[] = {"atan2", Atan2,
                               0, 0
                            };
/* Inicializa la tabla de símbolos */
void init();

typedef struct Symbol { /* entrada en la tabla de simbolos */
	               char *nombre;
	               short tipo;  /* VAR, FUNCION, INDEFINIDA */
	               union {
					  char *cadena;
		              double val;        /* si es VAR */
		              double (*ptr)();   /* si es FUNCION */
		             } u;
                       struct Symbol * siguiente;
	              } Symbol;

/* Instala en la tabla de simbolos */
Symbol *install(char *s, int t, double d);


#endif
