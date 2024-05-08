int a = 0; 

cuadrado(int n) {
    return n*n;
}

main() {
    int b = 0;
    a = cuadrado(2 + 3);
    b = a + cuadrado(2);
    printf("%d", a);
    printf("%d", b);
    return 0;
}
//@ (main)
