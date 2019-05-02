#include <math.h>
#include <stdio.h>

//#include "../code/code.h"
#include "init.h"

#include "sintactico.tab.h"

/************************************************************************/
/** Nombre: install                                                    **/
/** Labor que desarrolla: Inserta una palabra en la tabla de simbolos, **/
/**        indicando el token que le corresponde y su valor inicial.   **/
/**        Devuelve un puntero al nodo que contiene a la palabra.      **/
/** Tipo de resultado: Puntero a la tabla de simbolos "Symbol *"       **/
/** Parametros:                                                        **/
/**  Nombre: s                                                         **/
/**	Tipo:   cadena de caracteres o puntero a char  "char *"        **/
/**     Mision: suministra el nombre de la palabra a insertar.         **/
/**  Nombre: t                                                         **/
/**	Tipo:   entero "int"                                           **/
/**     Mision: indica el token de la palabra.                         **/
/**  Nombre: d                                                         **/
/**	Tipo:   real de doble precision "double"                       **/
/**     Mision: suministra un valor inicial.                           **/
/************************************************************************/
Symbol *install(char *s, int t, double d)
{
 Symbol *sp;
 char *emalloc();

 //guardar el nombre
 sp=(Symbol *) emalloc(sizeof(Symbol));
 sp->nombre=emalloc(strlen(s)+1); /* +1 para el caracter nulo '\0' */
 strcpy(sp->nombre,s);

 //guardar tipo
 sp->tipo=t;

 //guardar el numero
 sp->u.val=d;

 //guardar el siguiente
 sp->siguiente=symlist;
 symlist=sp;
 return sp;
}

/************************************************************************/
/** Nombre: init                                                       **/
/** Labor que desarrolla: Inserta  en la tabla de simbolos las         **/
/**        constantes y las funciones  que se encuentran en las        **/
/**        variables globales "consts" y "funciones"                   **/
/** Tipo de resultado: entero "int" (tipo por defecto)                 **/
/** Parametros: Ninguno.                                               **/
/************************************************************************/
void init()
{
 int i;
 Symbol *s;

 for (i=0; constantes[i].nombre; i++)
       install(constantes[i].nombre,CONSTANTE,constantes[i].cval);

 for (i=0; keywords[i].nombre; i++)
       install(keywords[i].nombre,keywords[i].kval,0.0);

 for (i=0; funciones0[i].nombre; i++)
     {
      s=install(funciones0[i].nombre,FUNCION0_PREDEFINIDA,0.0);
      s->u.ptr=funciones0[i].func;
     }
 for (i=0; funciones1[i].nombre; i++)
     {
      s=install(funciones1[i].nombre,FUNCION1_PREDEFINIDA,0.0);
      s->u.ptr=funciones1[i].func;
     }
 for (i=0; funciones2[i].nombre; i++)
     {
      s=install(funciones2[i].nombre,FUNCION2_PREDEFINIDA,0.0);
      s->u.ptr=funciones2[i].func;
     }
}
