#calculo de pi
con la serie Leibniz y la de Nilakantha#

escribir_cadena('Numero de iteraciones:');
leer(it);

si (it <= 0)
entonces
    escribir_cadena('La iteracion no puede ser menor que cero');
si_no
    Leib := 0;
    Nila := 3;
    Nila_aux := 2;

    para i desde 0 hasta it-1 paso 1
    hacer
        Leib := Leib + ( ((-1) ** (i)) * (4/(2*i + 1)) ); 

        Nila := Nila + ( ((-1) ** (i)) * (4/(Nila_aux + (++Nila_aux) + (++Nila_aux))) ); 
    fin_para;

    escribir_cadena('Pi del lenguaje:');
    escribir(pi);
    escribir_cadena('\nPi calculado por Leibniz:');
    escribir(Leib);
    escribir_cadena('\nPi calculado por Nilakantha:');
    escribir(Nila);
fin_si;