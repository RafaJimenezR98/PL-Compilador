#
  Ejemplo 3
  Asignatura: Procesadores de Lenguajes
  Curso: 2018 - 2019
  Grupo: 2
#

@ Menu calculadora

repetir

 @ Opciones de calculadora

 _borrar;

 _lugar(10,10);
 escribir_cadena('1) Suma');

 _lugar(11,10);
 escribir_cadena('2) Resta');

 _lugar(12,10);
 escribir_cadena('3) Multiplicación');

 _lugar(13,10);
 escribir_cadena('4) Division');

 _lugar(14,10);
 escribir_cadena('5) Potencia');

 _lugar(16,10);
 escribir_cadena('0) Salir');

 _lugar(18,10);
 escribir_cadena(' Elige una opcion ');

 leer(opcion);

 escribir(opcion);

 _borrar;

 si (opcion  = 0)        @ Fin del programa
    entonces
        _lugar(10,10);
        escribir_cadena(' SALIENDO... ');

   si_no
       @ Calculadora
	si (opcion = 1) @ Suma
   	    entonces
                _lugar(10,10);
		          escribir_cadena(' Suma  ');

                _lugar(11,10);
		          escribir_cadena(' Introduce el PRIMER sumando ');
		          leer(N1);

                _borrar;

                _lugar(10,10);
                escribir_cadena(' Suma  ');

                _lugar(11,10);
                escribir(N1);
                _lugar(12, 10);
                escribir_cadena('+');
                _lugar(13,10);
                escribir_cadena('?');
                _lugar(15,10);
		          escribir_cadena(' Introduce el SEGUNDO sumando ');
                leer(N2);

                _borrar;

                _lugar(10,10); @ Se muestra el resultado por pantalla
                escribir(N1);
                _lugar(11,10);
                escribir_cadena('+');
                _lugar(12,10);
                escribir(N2);
                _lugar(13,10);
                escribir_cadena('=');
                N2 := N1 + N2; @ Resultado
                _lugar(15,10);
                escribir(N2);

	       si_no
          si (opcion = 2) @ Resta
      			entonces
                  _lugar(10,10);
                  escribir_cadena(' Resta  ');

                  _lugar(11,10);
                  escribir_cadena(' Introduce el PRIMER numero ');
                  leer(N1);

                  _borrar;

                  _lugar(10,10);
                  escribir_cadena(' Resta  ');

                  _lugar(11,10);
                  escribir(N1);
                  _lugar(12, 10);
                  escribir_cadena('-');
                  _lugar(13,10);
                  escribir_cadena('?');
                  _lugar(15,10);
                  escribir_cadena(' Introduce el SEGUNDO numero ');
                  leer(N2);

                  _borrar;

                  _lugar(10,10); @ Se muestra el resultado por pantalla
                  escribir(N1);
                  _lugar(11,10);
                  escribir_cadena('-');
                  _lugar(12,10);
                  escribir(N2);
                  _lugar(13,10);
                  escribir_cadena('=');
                  N2 := N1 - N2; @ Resultado
                  _lugar(15,10);
                  escribir(N2);

               si_no
               si (opcion = 3) @ Multiplicacion
            			entonces
                        _lugar(10,10);
                        escribir_cadena(' Multiplicacion  ');

                        _lugar(11,10);
                        escribir_cadena(' Introduce el PRIMER numero ');
                        leer(N1);

                        _borrar;

                        _lugar(10,10);
                        escribir_cadena(' Multiplicacion  ');

                        _lugar(11,10);
                        escribir(N1);
                        _lugar(12, 10);
                        escribir_cadena('*');
                        _lugar(13,10);
                        escribir_cadena('?');
                        _lugar(15,10);
                        escribir_cadena(' Introduce el SEGUNDO numero ');
                        leer(N2);

                        _borrar;

                        _lugar(10,10); @ Se muestra el resultado por pantalla
                        escribir(N1);
                        _lugar(11,10);
                        escribir_cadena('*');
                        _lugar(12,10);
                        escribir(N2);
                        _lugar(13,10);
                        escribir_cadena('=');
                        N2 := N1 * N2; @ Resultado
                        _lugar(15,10);
                        escribir(N2);

                     si_no
                     si (opcion = 4) @ Division
                  			entonces
                              _lugar(10,10);
                              escribir_cadena(' Division  ');

                              _lugar(11,10);
                              escribir_cadena(' Introduce el DIVIDENDO ');
                              leer(N1);

                              _borrar;

                              _lugar(10,10);
                              escribir_cadena(' Division  ');

                              _lugar(11,10);
                              escribir(N1);
                              _lugar(12, 10);
                              escribir_cadena('/');
                              _lugar(13,10);
                              escribir_cadena('?');
                              _lugar(15,10);
                              escribir_cadena(' Introduce el DIVISOR ');
                              leer(N2);

                              si (N2 = 0)
                                 entonces
                                    escribir_cadena('ERROR: DIVISION ENTRE 0');
                                 si_no

                                    _borrar;

                                    _lugar(10,10); @ Se muestra el resultado por pantalla
                                    escribir(N1);
                                    _lugar(11,10);
                                    escribir_cadena('/');
                                    _lugar(12,10);
                                    escribir(N2);
                                    _lugar(13,10);
                                    escribir_cadena('=');
                                    N2 := N1 / N2; @ Resultado
                                    _lugar(15,10);
                                    escribir(N2);
                                 fin_si;

                           si_no
                           si (opcion = 5) @ Potencia
                                 entonces
                                    _lugar(10,10);
                                    escribir_cadena(' Potencia  ');

                                    _lugar(11,10);
                                    escribir_cadena(' Introduce el PRIMER numero ');
                                    leer(N1);

                                    _borrar;

                                    _lugar(10,10);
                                    escribir_cadena(' Potencia  ');

                                    _lugar(11,10);
                                    escribir_cadena('?');
                                    _lugar(12, 10);
                                    escribir_cadena('^');
                                    _lugar(13,10);
                                    escribir(N1);
                                    _lugar(15,10);
                                    escribir_cadena(' Introduce la potencia ');
                                    leer(N2);

                                    _borrar;

                                    _lugar(10,10); @ Se muestra el resultado por pantalla
                                    escribir(N2);
                                    _lugar(11,10);
                                    escribir_cadena('^');
                                    _lugar(12,10);
                                    escribir(N1);
                                    _lugar(13,10);
                                    escribir_cadena('=');
                                    N2 := N1 ** N2; @ Resultado
                                    _lugar(15,10);
                                    escribir(N2);

                                 si_no
                                    _lugar(15,10);
                     			      escribir_cadena(' Opcion incorrecta ');
                                 fin_si;

                           fin_si;
                     fin_si;
               fin_si;
         fin_si;
   fin_si;

 _lugar(20,10);
 escribir_cadena(' Pulse ENTER para continuar  ');
 leer_cadena(enter);
 leer_cadena(enter);

hasta (opcion = 0);

@ Despedida final

_borrar;
_lugar(10,10);
escribir_cadena(' El programa ha finalizado corectamente ');
_lugar(10,0);
