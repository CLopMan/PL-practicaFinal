/* César López Mantecón, Paula Subías Serrano, grupo 12 */
/* 100472092@alumnos.uc3m.es 100472119@alumnos.uc3m.es */
%{                          // SECCION 1 Declaraciones de C-Yacc

#include <stdio.h>
#include <ctype.h>            // declaraciones para tolower
#include <string.h>           // declaraciones para cadenas
#include <stdlib.h>           // declaraciones para exit ()

#define FF fflush(stdout);    // para forzar la impresion inmediata

int yylex () ;
int yyerror () ;
char *mi_malloc (int) ;
char *gen_code (char *) ;
char *int_to_string (int) ;
char *char_to_string (char) ;

char temp [2048] ;

// Definitions for explicit attributes

typedef struct s_attr {
        int value ;
        char *code ;
} t_attr ;

#define YYSTYPE t_attr

%}

// Definitions for explicit attributes

%token NUMBER        
%token IDENTIF       // Identificador=variable
%token STRING
%token MAIN          // identifica el comienzo del proc. main
%token WHILE         // identifica el bucle main
%token PRINT        // identifica la impresion
%token SETQ
%token DEFUN
%token PRIN1
%token SETF
%token DO
%token LOOP
%token IF
%token PROGN


%right '='                    // minima preferencia
%left OR                      // 
%left AND                     //  
%left EQUAL NOTEQ             //  
%left '<' LEQ '>' GEQ         //  
%left '+' '-'                 // 
%left '*' '/'                 // 
%left UNARY_SIGN              // maxima preferencia

%%                            // Seccion 3 Gramatica - Semantico

axioma:     '(' bloque ')' codigo      { printf ("%s\n%s", $2.code,$4.code); } 
            ;

codigo:     '(' bloque ')' codigo { sprintf(temp, "%s\n%s", $2.code, $4.code); 
                                    $$.code = gen_code(temp); }
            | /* lambda */        { $$.code = ""; }
            ;

bloque:     sentencia    { $$ = $1 ; }
            | declaracion  { sprintf(temp, "%s", $1.code); 
                            $$.code = gen_code(temp); }
            | DEFUN IDENTIF '(' ')'  codigo    { sprintf(temp, ": %s\n%s;", $2.code, $5.code); 
                                                        $$.code = gen_code(temp); }
            | LOOP WHILE expresion DO codigo    { sprintf(temp, "BEGIN %s WHILE %s REPEAT", $3.code, $5.code); 
                                                    $$.code = gen_code(temp);} 
            | IF expresion '(' PROGN codigo')' else        { sprintf(temp, "%s IF %s %s THEN", $2.code, $5.code, $7.code); 
                                                            $$.code = gen_code(temp);}

            ;

else:    /* lambda */  { $$.code = ""; }
        | '(' PROGN codigo')' { sprintf(temp, "ELSE %s", $3.code); 
                                $$.code = gen_code(temp);}
        ;

sentencia:    SETF IDENTIF expresion                         {sprintf (temp, "%s %s !", $3.code, $2.code) ; 
                                                                    $$.code = gen_code (temp) ; }
            | PRINT STRING                                       {sprintf(temp, ".\" %s\"", $2.code); 
                                                                    $$.code = gen_code(temp); }
            | IDENTIF                                              {sprintf(temp, "%s", $1.code);
                                                                    $$.code = gen_code(temp);}
            | PRIN1 prin1_arg                                          {sprintf(temp, "%s", $2.code); 
                                                                    $$.code = gen_code(temp); }
            ;

        
prin1_arg:   expresion                           {sprintf(temp, "%s .", $1.code); 
                                            $$.code = gen_code(temp); }
        | STRING                            {sprintf(temp, ".\" %s\"", $1.code); 
                                            $$.code = gen_code(temp); }
        ;

expresion:    NUMBER   { sprintf (temp, "%d", $1.value) ;
                        $$.code = gen_code(temp); }
            | IDENTIF   {sprintf(temp, "%s @", $1.code);
                        $$.code = gen_code(temp); }
            | '(' operacion ')' {sprintf(temp, "%s", $2.code); 
                                $$.code = gen_code(temp); }
            ;

operacion:    '+' expresion expresion { sprintf(temp, "%s %s +", $2.code, $3.code); 
                                        $$.code = gen_code(temp); }
            | '-' expresion expresion { sprintf(temp, "%s %s -", $2.code, $3.code);
                                        $$.code = gen_code(temp); }
            | '*' expresion expresion { sprintf(temp, "%s %s *", $2.code, $3.code);
                                        $$.code = gen_code(temp); }
            | '/' expresion expresion { sprintf(temp, "%s %s /", $2.code, $3.code);
                                        $$.code = gen_code(temp); }
            | '<' expresion expresion { sprintf(temp, "%s %s <", $2.code, $3.code);
                                        $$.code = gen_code(temp); }
            | '>' expresion expresion { sprintf(temp, "%s %s >", $2.code, $3.code);
                                        $$.code = gen_code(temp); }
            | '=' expresion expresion { sprintf(temp, "%s %s =", $2.code, $3.code);
                                        $$.code = gen_code(temp); }
            ;

declaracion:    SETQ IDENTIF NUMBER                                     {sprintf (temp, "variable %s\n%d %s !", $2.code, $3.value, $2.code) ; 
                                                                           $$.code = gen_code (temp) ; }
                ;

/*vector: SETQ IDENTIF '(' MAKE-ARRAY NUMBER')' */

%%                            // SECCION 4    Codigo en C

int n_line = 1 ;

int yyerror (mensaje)
char *mensaje ;
{
    fprintf (stderr, "%s en la linea %d\n", mensaje, n_line) ;
    printf ( "\n") ;	// bye
}

char *int_to_string (int n)
{
    sprintf (temp, "%d", n) ;
    return gen_code (temp) ;
}

char *char_to_string (char c)
{
    sprintf (temp, "%c", c) ;
    return gen_code (temp) ;
}

char *my_malloc (int nbytes)       // reserva n bytes de memoria dinamica
{
    char *p ;
    static long int nb = 0;        // sirven para contabilizar la memoria
    static int nv = 0 ;            // solicitada en total

    p = malloc (nbytes) ;
    if (p == NULL) {
        fprintf (stderr, "No queda memoria para %d bytes mas\n", nbytes) ;
        fprintf (stderr, "Reservados %ld bytes en %d llamadas\n", nb, nv) ;
        exit (0) ;
    }
    nb += (long) nbytes ;
    nv++ ;

    return p ;
}


/***************************************************************************/
/********************** Seccion de Palabras Reservadas *********************/
/***************************************************************************/

typedef struct s_keyword { // para las palabras reservadas de C
    char *name ;
    int token ;
} t_keyword ;

t_keyword keywords [] = { // define las palabras reservadas y los
    "main",        MAIN,           // y los token asociados
    "print",      PRINT,
    "and",          AND,
    "or",          OR,
    "/=",          NOTEQ,
    "<=",          LEQ,
    ">=",          GEQ,
    "setq",        SETQ,
    "defun",       DEFUN,
    "prin1",       PRIN1,
    "setf",        SETF,
    "loop",        LOOP,
    "do",          DO,
    "while",       WHILE,
    "if",          IF,
    "progn",       PROGN,
    NULL,          0               // para marcar el fin de la tabla
} ;

t_keyword *search_keyword (char *symbol_name)
{                                  // Busca n_s en la tabla de pal. res.
                                   // y devuelve puntero a registro (simbolo)
    int i ;
    t_keyword *sim ;

    i = 0 ;
    sim = keywords ;
    while (sim [i].name != NULL) {
	    if (strcmp (sim [i].name, symbol_name) == 0) {
		                             // strcmp(a, b) devuelve == 0 si a==b
            return &(sim [i]) ;
        }
        i++ ;
    }

    return NULL ;
}

 
/***************************************************************************/
/******************* Seccion del Analizador Lexicografico ******************/
/***************************************************************************/

char *gen_code (char *name)     // copia el argumento a un
{                                      // string en memoria dinamica
    char *p ;
    int l ;
	
    l = strlen (name)+1 ;
    p = (char *) my_malloc (l) ;
    strcpy (p, name) ;
	
    return p ;
}


int yylex ()
{
    int i ;
    unsigned char c ;
    unsigned char cc ;
    char ops_expandibles [] = "!<=>|%/&+-*" ;
    char temp_str [256] ;
    t_keyword *symbol ;

    do {
        c = getchar () ;

        if (c == '#') {	// Ignora las lineas que empiezan por #  (#define, #include)
            do {		//	OJO que puede funcionar mal si una linea contiene #
                c = getchar () ;
            } while (c != '\n') ;
        }

        if (c == '/') {	// Si la linea contiene un / puede ser inicio de comentario
            cc = getchar () ;
            if (cc != '/') {   // Si el siguiente char es /  es un comentario, pero...
                ungetc (cc, stdin) ;
            } else {
                c = getchar () ;	// ...
                if (c == '@') {	// Si es la secuencia //@  ==> transcribimos la linea
                    do {		// Se trata de codigo inline (Codigo embebido en C)
                        c = getchar () ;
                        putchar (c) ;
                    } while (c != '\n') ;
                } else {		// ==> comentario, ignorar la linea
                    while (c != '\n') {
                        c = getchar () ;
                    }
                }
            }
        } else if (c == '\\') c = getchar () ;
		
        if (c == '\n')
            n_line++ ;

    } while (c == ' ' || c == '\n' || c == 10 || c == 13 || c == '\t') ;

    if (c == '\"') {
        i = 0 ;
        do {
            c = getchar () ;
            temp_str [i++] = c ;
        } while (c != '\"' && i < 255) ;
        if (i == 256) {
            printf ("AVISO: string con mas de 255 caracteres en linea %d\n", n_line) ;
        }		 	// habria que leer hasta el siguiente " , pero, y si falta?
        temp_str [--i] = '\0' ;
        yylval.code = gen_code (temp_str) ;
        return (STRING) ;
    }

    if (c == '.' || (c >= '0' && c <= '9')) {
        ungetc (c, stdin) ;
        scanf ("%d", &yylval.value) ;
//         printf ("\nDEV: NUMBER %d\n", yylval.value) ;        // PARA DEPURAR
        return NUMBER ;
    }

    if ((c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z')) {
        i = 0 ;
        while (((c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') ||
            (c >= '0' && c <= '9') || c == '_') && i < 255) {
            temp_str [i++] = tolower (c) ;
            c = getchar () ;
        }
        temp_str [i] = '\0' ;
        ungetc (c, stdin) ;

        yylval.code = gen_code (temp_str) ;
        symbol = search_keyword (yylval.code) ;
        if (symbol == NULL) {    // no es palabra reservada -> identificador antes vrariabre
//               printf ("\nDEV: IDENTIF %s\n", yylval.code) ;    // PARA DEPURAR
            return (IDENTIF) ;
        } else {
//               printf ("\nDEV: OTRO %s\n", yylval.code) ;       // PARA DEPURAR
            return (symbol->token) ;
        }
    }

    if (strchr (ops_expandibles, c) != NULL) { // busca c en ops_expandibles
        cc = getchar () ;
        sprintf (temp_str, "%c%c", (char) c, (char) cc) ;
        symbol = search_keyword (temp_str) ;
        if (symbol == NULL) {
            ungetc (cc, stdin) ;
            yylval.code = NULL ;
            return (c) ;
        } else {
            yylval.code = gen_code (temp_str) ; // aunque no se use
            return (symbol->token) ;
        }
    }

//    printf ("\nDEV: LITERAL %d #%c#\n", (int) c, c) ;      // PARA DEPURAR
    if (c == EOF || c == 255 || c == 26) {
//         printf ("tEOF ") ;                                // PARA DEPURAR
        return (0) ;
    }

    return c ;
}


int main ()
{
    yyparse () ;
}



/*
(defun f1 (a b)
    (print a)
    (setf b (* 2 b))
    (setf a (+ b a))
    (return-from f1 a)
)

variable f1-param_a 

f1 ( a b )

variable f1-param_a
variable b 
: f1 ( a b )

b !
a !
  +; 


 
4
5
: f1 ....

destroy f1... 
;
*/