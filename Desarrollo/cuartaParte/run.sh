#!/bin/bash 

if [ $# -eq 0 ]; then
    printf "\033[0;31m[ERROR]\033[0m: no arguments supplied\n"
    printf "USAGE: bash run.sh <path_to_test>\n"
    exit 1
fi        

printf "\033[1;33mrunning test $1:\033[0m\n"

# compiling just in case 
make 

# frontent 
printf "\033[1;33mprimera fase: traduccion a código intermedio:\033[0m\n"
./trad < $1 > $1.lisp.out
printf "\033[1;33msegunda fase: traduccion a gforth:\033[0m\n"
./back < $1.lisp.out > $1.forth.out
printf "\033[1;33mtercera fase: ejecucion:\033[0m\n"
./gforth < $1.forth.out > $1.output.out
    
