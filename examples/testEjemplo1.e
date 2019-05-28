#
  Ejemplo 1
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
 escribir_cadena('0) Salir');

 _lugar(15,10);
 escribir_cadena(' Elige una opcion ');

 leer(opcion);

escribir(opcion);

 _borrar;

 si (opcion  = 0)        @ Fin del programa
    entonces
        _lugar(10,10);
        escribir_cadena(nombre);
        escribir_cadena(': gracias por usar el intérprete ipe.exe ');

   si_no
       @ Factorial de un número
	si (opcion = 1)
   	    entonces
                _lugar(10,10);
		escribir_cadena(' Factorial de un numero  ');

                _lugar(11,10);
		escribir_cadena(' Introduce un numero entero ');
		leer(N);

        	factorial := 1;

       		para i desde 2 hasta N paso 1 hacer
	            factorial := factorial * i;
        	fin_para;

        	@ Resultado
	        _lugar(15,10);
		escribir_cadena(' El factorial de ');
		escribir(N);
		escribir_cadena(' es ');
		escribir(factorial);

   	@ Máximo común divisor
	si_no
		si (opcion = 2)
			entonces
				_lugar(10,10);
				escribir_cadena(' Máximo común divisor de dos números ');

				_lugar(11,10);
                		escribir_cadena(' Algoritmo de Euclides ');

                		_lugar(12,10);
                		escribir_cadena(' Escribe el primer número ');
                		leer(a);

                  		_lugar(13,10);
                  		escribir_cadena(' Escribe el segundo número ');
                  		leer(b);

                  		@ Se ordenan los números
				si (a < b)
					entonces
						auxiliar := a;
						a := b;
						b := auxiliar;
				fin_si;

					@ Se guardan los valores originales
					A1 := a;
					B1 := b;

					@ Se aplica el método de Euclides
					resto  := a _mod b;

					mientras (resto <> 0) hacer
						a :=  b;
						b := resto;
						resto := a _mod b;
					fin_mientras;

					@ Se muestra el resultado
					_lugar(15,10);
					escribir_cadena(' Máximo común divisor de ');
					escribir(A1);
					escribir_cadena(' y ');
					escribir(B1);
					escribir_cadena(' es ---> ');
					escribir(b);

			@ Resto de opciones
 			si_no
				_lugar(15,10);
			    	escribir_cadena(' Opcion incorrecta ');

 			fin_si;
  	fin_si;

  fin_si;

 _lugar(40,10);
 escribir_cadena('\n Pulse una tecla para continuar --> ');
 leer_cadena(pausa);

hasta (opcion = 0);

@ Despedida final

_borrar;
_lugar(10,10);
escribir_cadena('El programa ha concluido');
