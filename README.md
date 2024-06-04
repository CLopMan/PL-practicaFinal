# PL-practicaFinal
This project aims to create a program that translates a subset of the C programming language to Forth, with Lisp serving as an intermediate language. It also accepts some embed code using the structure `//@<lisp code>` or `//@//@<forth code>`.

The project was developed during several weeks. You can check the final programm in the "final" folder. 

Course: third (2023-2024)
## Requirements
The project was develop using [bison](https://www.gnu.org/software/bison/) version 3.8.2 and [gcc](https://gcc.gnu.org/) version 13.3.1.

In addition, [CLisp](https://clisp.sourceforge.io/) and [Gforth](https://gforth.org/) were used as interpreters of Lisp and Forth language.

## How to use the program
Althoug some bash scripts were included for running tests, the general use of this project is the following: 
1. Compile the translator either using `make` or compiling through the following commands: 
```
bison back.y
bison trad.y
gcc -g -Wall trad.tab.c -o trad
gcc -g -Wall back.tab.c -o back
```
2. Translate: 
```
./trad < your_c_code.c | ./back
```
# Authors 
- [CLopMan](https://github.com/CLopMan)
- [PaulaUc3m](https://github.com/PaulaUc3m)
