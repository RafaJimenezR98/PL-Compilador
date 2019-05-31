#
  Ejemplo 1
  Asignatura: Procesadores de Lenguajes
  Curso: 2018 - 2019
  Grupo: 2
#

@ Pide argumentos por linea de comandos
escribir_cadena('Numero total de elementos para la media: ');
leer(nTotal);

media:=0;

para i desde 1 hasta nTotal hacer

    escribir_cadena('Introduce el numero ');
    escribir(i);
    escribir_cadena(' de la media: ');

    leer(numero);

    @ Guarda el valor de la media
    media := media + numero;
fin_para

media := media / nTotal;

@ Muestra el resultado final
escribir_cadena('RESULTADO FINAL: ');
escribir(media);

