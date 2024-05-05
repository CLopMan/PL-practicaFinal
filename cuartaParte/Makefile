all: 
	bison trad4.y
	bison back4.y
	gcc -o trad4 trad4.tab.c
	gcc -o back4 back4.tab.c
	@rm *.tab.c
	@printf "\n\033[;32m\033[1mcompilation complete\033[0m\n"
