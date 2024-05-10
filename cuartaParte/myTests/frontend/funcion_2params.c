suma (int a, int b) {
    return a + b;
}

division (int a, int b) {
    int resto;
    if (b == 0) {
        puts("division entre 0");
        return 1;
    }
    resto = a % b;
    printf(" ", "resto: ", resto);
    return a/b;

}

main () {
    int r_suma;
    int r_div1;
    int r_div2;
    r_suma = suma(1, -2);
    r_div1 = division(1, 0);
    r_div2 = division(4, 2);
    printf("f", r_suma, r_div1, r_div2);
    return 0;
}

//@ (main)
