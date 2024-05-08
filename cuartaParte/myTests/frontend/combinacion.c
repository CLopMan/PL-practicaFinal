int abc  = 1;
int b = 0;
int n = 0;

fib (int n) {
    int abc = 1;
    int i = 0;
    int c;
    b = 1; 
    //@ (prin1 abc)
    for (i = 0; i < n; i = 1 + i) {
        c = b + abc;
        abc = b; 
        b = c; 
    }
    return c;
}

main() {
    //int v[32];
    int control = 1;
    
    //v[31] = fib(10);

    if (3 > 1) {
        puts("TRUE");
    } 

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
    //printf("HOLA", v[31]);
    if (! (1 < 0)) {
        b = 1;
    } else {
        puts("FALSE");
    }
    return 0;


}
//@ (main)
