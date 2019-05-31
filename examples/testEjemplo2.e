#
  Ejemplo 2
  Asignatura: Procesadores de Lenguajes
  Curso: 2018 - 2019
  Grupo: 2
#

@ Sucesion de Fibonaci

prv := 0;
pre := 1;

_borrar;
_lugar(10,10);
escribir_cadena (' Se mostraran los n primeros terminos de la sucesion de Fibonacci ');
_lugar(11,10);
escribir_cadena (' valor de n --> ');
leer(n);

_borrar;

si (n < 1)
   entonces

   _lugar(10,10);
   escribir_cadena (' ERROR: El numero n debe ser mayor que 0 ');
   _lugar(11,10);
   escribir_cadena (' SALIENDO.... ');
   _lugar(12,0);

   si_no

   fila := 5;

   i := 1;
   mientras (i <= n)
      hacer

      si (i = 1) @ Caso base
         entonces
            trm := i;
         si_no

            trm := prv + pre; @ Se calcula el siguiente
            prv := pre;
            pre := trm;

         fin_si;

      _lugar(fila,10);
      escribir (trm);

      @ mostrar := i _mod 10; @ Para mostrarlos de 10 en 10
      @ si (mostrar = 0)
         @ entonces
            @ escribir_cadena( ' Pulse ENTER para mostrar los siguientes terminos ' );
            @ leer_cadena(pausa);
            @ _borrar;
         @ fin_si;

      fila := fila + 1;
      i := i + 1;
      fin_mientras;

      _lugar(fila+1,10);
      escribir_cadena (' El programa ha finalizado corectamente ');
      _lugar(fila+2,0);

   fin_si;
