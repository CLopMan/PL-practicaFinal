all: 
	bison trad.y
	bison back.y
	gcc -g -Wall -o trad trad.tab.c
	gcc -g -Wall -o back back.tab.c
	@rm *.tab.c
	@printf "\n\033[;32m\033[1mcompilation complete\033[0m\n"
