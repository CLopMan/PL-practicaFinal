#include <stdio.h>
int igual;
int distinto;
int mayorque;
int menorque;
int mayoroigual;
int menoroigual;
int op_and;
int op_or;
int op_not;
int combo;

main() {
    int op1 = 1;
    int op2 = 0;

    igual = op1 == op2;
    distinto = op1 != op2;
    mayorque = op1 > op2;
    mayoroigual = op1 >= op2;
    menorque = op1 < op2;
    menoroigual = op1 <= op2;
    op_and = op1 && op2;
    op_or = op1 || op2;
    op_not = !op1;
    combo =  op1 != op2 > op1 && op2;
    
    printf("%d %d %d %d %d %d %d %d %d", igual, distinto, mayorque, mayoroigual, menorque, menoroigual, op_and, op_or, op_not);
}
//@ (main)
