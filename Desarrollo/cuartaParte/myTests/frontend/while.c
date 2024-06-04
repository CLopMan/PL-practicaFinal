int i = 0;

main() {
    int control = 1;

    while (control < 10) {
        control = control * 2;
    }

    while (3 > 10) {
        puts("Esto no se va a ejecutar");
    }

    while (!i) {
        puts("una iteracion");
        i = (40 % 2 == 0);
    }
}
//@ (main)
