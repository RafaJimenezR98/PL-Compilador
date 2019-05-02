@programa que ejecuta n iteraciones de fibonacci

escribir_cadena('Numero de iteraciones:');
leer(it);

si(it < 0)
entonces
    escribir_cadena('La iteracion no puede ser menor que cero');
si_no
    fib_pri:=0;
    fib_seg:=1;
    fib:=0;

    si(it = 1)
    entonces
        fib:=1;
    fin_si;

    para i desde 2 hasta it paso 1
    hacer
        fib := fib_seg + fib_pri;
        fib_pri := fib_seg;
        fib_seg := fib;
    fin_para; 

    escribir_cadena('Fibonacci:');
    escribir(fib);
fin_si;