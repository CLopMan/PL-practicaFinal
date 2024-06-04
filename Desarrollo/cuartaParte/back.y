/* Cesar Lopez Mantecon, Paula Subias Serrano, grupo 12 */
/* 100472092@alumnos.uc3m.es 100472119@alumnos.uc3m.es */
%{                          // SECCION 1 Declaraciones de C-Yacc

#include <stdio.h>
#include <ctype.h>            // declaraciones para tolower
#include <string.h>           // declaraciones para cadenas
#include <stdlib.h>           // declaraciones para exit ()

#define FF fflush(stdout);    // para forzar la impresion inmediata

typedef struct s_lista { // tabla de símbolos
    char lista[1024][1024];
    int values[1024];
    int i; 
} t_lista;


int yylex () ;
int yyerror () ;
char *mi_malloc (int) ;
char *gen_code (char *) ;
char *int_to_string (int) ;
char *char_to_string (char) ;

// mi tabla de simbolos
int search_local(t_lista l, char *var);
int insert(t_lista *l, char *var, int n);
int remove_all(t_lista *l);

char temp [2*2048] ;
char nombre_funcion[1024];

t_lista argumentos; 
t_lista var_local;
t_lista vec_local;

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
%token NOT
%token RETURN
%token FROM
%token MAKE
%token ARRAY
%token AREF


%right '='                    // minima preferencia
%left OR                      // 
%left AND                     //  
%left EQUAL NOTEQ             //  
%left '<' LEQ '>' GEQ         //  
%left '+' '-'                 // 
%left '*' '/' MOD                 // 
%left UNARY_SIGN              // maxima preferencia

%%                            // Seccion 3 Gramatica - Semantico

axioma:     '(' bloque ')' codigo   { printf ("\n"); } 
            ;

codigo:     '(' bloque ')' codigo   { sprintf(temp, "%s\n%s", $2.code, $4.code); $$.code = gen_code(temp); }
            | /* lambda */          { $$.code = ""; }
            ;

bloque:     sentencia               { $$ = $1 ; }
            | declaracion           { sprintf(temp, "%s", $1.code); $$.code = gen_code(temp); }
            | DEFUN 
                IDENTIF             { strcpy(nombre_funcion, $2.code); } 
                '(' func_arg ')' 
                codigo              {
                                      char asign_args[4*2048];
                                      char asign_aux[2*2048];
                                      strcpy(asign_args, "");
                                      int i; 
                                      for (i = 0; i < argumentos.i ; ++i) {
                                         sprintf(asign_aux, "arg_%s_%s !\n",nombre_funcion, argumentos.lista[i]);
                                         strcat(asign_args, asign_aux);
                                         
                                      } // asignacion de argumentos
 
                                      char variables_locales[4*2048];
                                      strcpy(variables_locales, "");
                                      for (i = 0; i < var_local.i ; ++i) {
                                          sprintf(asign_aux, "variable %s\n", var_local.lista[i]);
                                          strcat(variables_locales, asign_aux);
                                      } // declaracion de var_locales

                                      char vec_locales[4*2048];
                                      strcpy(vec_locales, "");
                                      for (i = 0; i < vec_local.i ; ++i) {
                                          sprintf(asign_aux, "variable %s %d cells allot\n", vec_local.lista[i], var_local.values[i]);
                                          strcat(vec_locales, asign_aux);
                                      } // declaracion de vec_locales
 
                                      char asign_local[2048];
                                      strcpy(asign_local, "");
                                      for (i = 0; i < var_local.i ; ++i) {
                                          sprintf(asign_aux, "%i %s !\n", var_local.values[i], var_local.lista[i]);
                                          strcat(asign_local, asign_aux);
                                      } // asignacion de var locales
 
                                      printf("%s%s%s: %s\n%s%s%s;\n", $5.code, variables_locales,vec_locales, $2.code, asign_args, asign_local, $7.code); 
                                      $$.code = gen_code(""); 
                                      strcpy(nombre_funcion, "");
                                      remove_all(&argumentos);
                                      remove_all(&var_local);
                                      remove_all(&vec_local);
                                     }

            | LOOP 
                WHILE 
                expresion 
                DO 
                codigo              { 
                                     sprintf(temp, "BEGIN\n %s WHILE\n %s REPEAT\n", $3.code, $5.code); 
                                     $$.code = gen_code(temp);
                                    } 
            | IF 
                expresion 
                '(' PROGN codigo')' 
                else                { 
                                     sprintf(temp, "%s IF\n %s %s THEN\n", $2.code, $5.code, $7.code); 
                                     $$.code = gen_code(temp);
                                    }

            ;

func_arg:    /* lambda */           { $$.code = ""; }
            | IDENTIF func_arg      { 
                                     sprintf(temp, "variable arg_%s_%s\n%s", nombre_funcion, $1.code, $2.code);
                                     $$.code = gen_code(temp);
                                     insert(&argumentos, $1.code, 0); // insertar en argumentos
                                    }
            ;

else:    /* lambda */               { $$.code = ""; }
        | '(' PROGN codigo')'       { sprintf(temp, "ELSE %s", $3.code); $$.code = gen_code(temp); }
        ;

sentencia:    SETF IDENTIF expresion  { 
                                        char aux[2048] = "";
                                        if (strcmp(nombre_funcion, "")) {
                                            if (search_local(var_local, $2.code)) {;}
                                            else if (search_local(argumentos, $2.code)) 
                                                {sprintf(aux, "arg_%s_", nombre_funcion);}
                                        }
                                        sprintf (temp, "%s %s%s !\n", $3.code, aux,$2.code) ; 
                                        $$.code = gen_code (temp) ; 
                                      }
            |  SETF vector expresion  {
                                        
                                        sprintf (temp, "%s %s !\n", $3.code,$2.code) ; 
                                        $$.code = gen_code (temp) ; 
                                      }
            | PRINT STRING            { sprintf(temp, ".\" %s\"", $2.code); $$.code = gen_code(temp); }
            | PRIN1 prin1_arg         { sprintf(temp, "%s", $2.code); $$.code = gen_code(temp); }
            | RETURN '-' FROM 
                IDENTIF expresion     { sprintf(temp, "%s\n exit", $5.code); $$.code = gen_code(temp); }
            | funcion                 { 
                                        // si estoy en el scope de una funcion
                                        if (strcmp(nombre_funcion, "")) {
                                            $$ = $1;
                                        } else {
                                            // caso @ (funcion)
                                            printf("%s\n", $1.code);
                                        }
                                      }
            ;

        
prin1_arg:    expresion               { sprintf(temp, "%s .", $1.code); $$.code = gen_code(temp); }
            | STRING                  { sprintf(temp, ".\" %s\"", $1.code); $$.code = gen_code(temp); }
            ;

expresion:    NUMBER                  { sprintf (temp, "%d", $1.value) ;$$.code = gen_code(temp); }
            | IDENTIF                 { 
                                        char aux[2048] = "";
                                        if (strcmp(nombre_funcion, "")) {
                                            if (search_local(var_local, $1.code)) {;}
                                            else if (search_local(argumentos, $1.code)) {
                                                sprintf(aux, "arg_%s_", nombre_funcion);
                                            }
                                        }
                                        sprintf (temp, "%s%s @", aux,$1.code) ; 
                                        $$.code = gen_code(temp);
                                      }
            |  vector                       { sprintf(temp, "%s @", $1.code); $$.code = gen_code(temp); }
            | '(' operacion ')'             { sprintf(temp, "%s", $2.code); $$.code = gen_code(temp); }
            | '(' NOT expresion ')'         { sprintf(temp, "%s 0=", $3.code); $$.code = gen_code(temp); }
            | '(' '+' expresion ')'         { sprintf(temp, "%s", $3.code);$$.code = gen_code(temp); }
            | '(' '-' expresion ')'         { sprintf(temp, "0 %s -", $3.code); $$.code = gen_code(temp); }
            ;

vector: '(' AREF IDENTIF expresion ')'      { 
                                             sprintf (temp, "%s %s cells +", $3.code, $4.code); 
                                             $$.code = gen_code(temp);
                                            }

funcion:    IDENTIF args                    {
                                             if (strcmp(nombre_funcion, $1.code) == 0) {
                                                sprintf(temp, "%s %s", $2.code, "RECURSE");
                                             } else {
                                                sprintf(temp, "%s %s", $2.code, $1.code); 
                                                $$.code = gen_code(temp); 
                                             }
                                             $$.code = gen_code(temp);
                                            }
            ;

args:   /* lambda */                        { $$.code = ""; }
        | expresion args                    { sprintf(temp, "%s %s", $1.code, $2.code); $$.code = gen_code(temp); }
        ;

operacion:    '+' expresion expresion       { sprintf(temp, "%s %s +", $2.code, $3.code); $$.code = gen_code(temp); }
            | '-' expresion expresion       { sprintf(temp, "%s %s -", $2.code, $3.code); $$.code = gen_code(temp); }
            | '*' expresion expresion       { sprintf(temp, "%s %s *", $2.code, $3.code); $$.code = gen_code(temp); }
            | '/' expresion expresion       { sprintf(temp, "%s %s /", $2.code, $3.code); $$.code = gen_code(temp); }
            | MOD expresion expresion       { sprintf(temp, "%s %s mod", $2.code, $3.code); $$.code = gen_code(temp); }
            | '<' expresion expresion       { sprintf(temp, "%s %s <", $2.code, $3.code); $$.code = gen_code(temp); }
            | '>' expresion expresion       { sprintf(temp, "%s %s >", $2.code, $3.code); $$.code = gen_code(temp); }
            | '=' expresion expresion       { sprintf(temp, "%s %s =", $2.code, $3.code); $$.code = gen_code(temp); }
            | AND expresion expresion       { sprintf(temp, "%s %s and", $2.code, $3.code); $$.code = gen_code(temp); }
            | OR expresion expresion        { sprintf(temp, "%s %s or", $2.code, $3.code); $$.code = gen_code(temp); }
            | GEQ expresion expresion       { sprintf(temp, "%s %s >=", $2.code, $3.code); $$.code = gen_code(temp); }
            | LEQ expresion expresion       { sprintf(temp, "%s %s <=", $2.code, $3.code); $$.code = gen_code(temp); }
            | NOTEQ expresion expresion     { sprintf(temp, "%s %s = 0=", $2.code, $3.code); $$.code = gen_code(temp); }
            | funcion                       { $$ = $1 ; }
            ;

declaracion:    SETQ IDENTIF NUMBER   {
                                        if (strcmp(nombre_funcion, "")) { 
                                            insert(&var_local, $2.code, $3.value);
                                            $$.code = gen_code ("");
                                        } else {
                                            printf ( "variable %s\n%d %s !\n", $2.code, $3.value, $2.code) ; 
                                            $$.code = gen_code (temp) ; 
                                        }
                                      }
                | SETQ IDENTIF 
                    '('
                    MAKE'-'ARRAY 
                    NUMBER
                    ')'               {
                                        if (strcmp(nombre_funcion, "")) { 
                                            insert(&vec_local, $2.code, $7.value);
                                            $$.code = gen_code ("");
                                        } else {
                                            printf ( "variable %s %d cells allot\n", $2.code, $7.value); 
                                            $$.code = gen_code (temp); 
                                        }  
                                      }
                ;


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
/**********************  Seccion de tabla de símbolos  *********************/
/***************************************************************************/

/**
* Busca un nombre en la tabla
*
*/
int search_local(t_lista l, char *var) {
    for (int i = 0; i < l.i; ++i) {
        if (strcmp(l.lista[i], var) == 0) { // se encuentra la variable
            return 1;
        }

    }
    return 0;
}

/**
* inserta un nombre en la lista
*
*/
int insert(t_lista *l, char *var, int n) {
    strcpy(&(l->lista[l->i][0]), var);
    l->values[l->i] = n;

    ++(l->i);
    return l->i;
}

/**
* vacia la lista
*/
int remove_all(t_lista *l) {
    l->i = 0; 
    return 0;
}



/***************************************************************************/
/********************** Seccion de Palabras Reservadas *********************/
/***************************************************************************/

typedef struct s_keyword { // para las palabras reservadas de C
    char *name ;
    int token ;
} t_keyword ;

t_keyword keywords [] = { // define las palabras reservadas y los
    // "main",        MAIN,           // y los token asociados
    "print",       PRINT,
    "mod",         MOD,
    "and",         AND,
    "or",          OR,
    "/=",          NOTEQ,
    "<=",          LEQ,
    ">=",          GEQ,
    "setq",        SETQ,
    "not",         NOT,
    "defun",       DEFUN,
    "prin1",       PRIN1,
    "setf",        SETF,
    "loop",        LOOP,
    "do",          DO,
    "while",       WHILE,
    "if",          IF,
    "progn",       PROGN,
    "return",      RETURN,
    "from",        FROM,
    "make",        MAKE,
    "array",       ARRAY,
    "aref",        AREF,
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

