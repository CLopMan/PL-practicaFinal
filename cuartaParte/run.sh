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
./trad4 < $1 > $1.lisp.out
./back4 < $1.lisp.out > $1.forth.out
./gforth < $1.forth.out
    
