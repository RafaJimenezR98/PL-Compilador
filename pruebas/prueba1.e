#ejemplo 1
juego de adivinar el numero#

num := (_rand _mod 10) + 1; @numero secreto

repetir
    escribir_cadena('Di numero');
    leer(res);

    escribir_cadena('\n');

    si(res = num)
    entonces
        escribir_cadena('Correcto!');
    si_no
        si(res < num)
        entonces
            escribir_cadena('El numero es mayor');
        si_no
            escribir_cadena('El numero es menor');
        fin_si;
    fin_si;

    escribir_cadena('\n');

hasta(res = num);