f1 (int a) {
    a = a + 1;
    return a;
}

main () {
    int out = 4;
    out = f1(out);
    f1(out); 
    printf("%s", out);
    return 0;
}
//@ (main)
