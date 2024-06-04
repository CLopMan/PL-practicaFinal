int abc  = 1;
int b = 0;
int a = 0;

fib (int n) {
    int abc = 1;
    int i = 0;
    int c;
    int v[40];
    b = 1; 
    if (n < 5) {
        v[31] = fib(10);
    }
    //@ (prin1 abc)
    for (i = 0; i < n; i = 1 + i) {
        c = b + abc;
        abc = b; 
        b = c; 
    }
    return c;
}

main() {
    int control = 1;
    
    if (3 > 1) {
        puts("TRUE");
    } 
    // Comentario
    if (! (1 < 0)) {
        b = 1;
    } else {
        puts("FALSE");
    }
    
    while (control < 10) {
        control = control * 2;
    }
    puts("FIN");
    puts("---");

    if (! (1 < 0)) {
        b = 1;
        a = fib(2);
    } else {
        puts("FALSE");
    }
    return 0;


}
//@ (main)
