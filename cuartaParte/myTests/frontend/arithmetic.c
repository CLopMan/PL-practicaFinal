int suma;
int resta;
int mult;
int div;
int modulo;
int unario;

main() {
    int op1 = 6;
    int op2 = 3;

    suma = op1 + (op2);
    resta = (op1 - op2) * 3;
    mult = op1 * op2;
    div = op1 / op2;
    modulo = op1 % op2;
    unario = -op1;
    
    printf("%d %d %d %d %d",suma, resta, mult, div, modulo);
}
//@ (main)
