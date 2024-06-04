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

main() {
    int a = 4, b = 1;
    int result; 
    puts("DIVISION    -");
    result = division(suma(a, b), 5); // a b suma b a division division
    printf("s", "a = ", a, " b = ", b, " result = ", result);
    result = division(a + b, 5*result); // a b suma b a division division
    printf("s", "a = ", a, " b = ", b, " result = ", result);
    return 0;
}
//@ (main)
