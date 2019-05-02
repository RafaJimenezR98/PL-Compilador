%{
#include <ctype.h>
#include "../include/macros.h"
#include "../code/code.h"
#include "sintactico.tab.h"
extern char *progname;
extern int lineno;
%}
/* definiciones regulares */
numero        [0-9]
letra         [a-zA-Z]
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

cadena "'"([^']|\\\')*"'"

%x ESTADO_COMENTARIO

%%
[ \t] { ; } /* saltar los espacios y los tabuladores */

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

{cadena} {  yylval.sym=install_cadena("", CHAR, yytext);
            return CHAR;}

":="      {return ASIGNACION;}
"**"      {return POTENCIA;}

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

"++" {return INCREMENTO;}
"--" {return DECREMENTO;}

"@".*$ { }
"#" {BEGIN ESTADO_COMENTARIO;}
<ESTADO_COMENTARIO>"#" {BEGIN 0;}
<ESTADO_COMENTARIO>. { }
<ESTADO_COMENTARIO>[\n] {lineno++;}

\n      {lineno++;} /* no se devuelve nada, contin�a el analisis l�xico */
.       {return yytext[0];}
