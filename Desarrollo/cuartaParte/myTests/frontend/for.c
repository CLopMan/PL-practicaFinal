int b = 1;

main() {
    int abc = 1;
    int i;
    int c;

    for (i = 0; i < 10; i = 1 + i) {
        printf("Ascendente: %d", i);
        c = b + abc;
        abc = i + b; 
        }

    for (i = 10; i > 0; i = 1 - i) {
        printf("Descendente: %d", i);
        c = b + abc;
        abc = i + b; 
        }
}
//@ (main)
