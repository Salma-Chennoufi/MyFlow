%{
    #include <stdio.h>
    #include <stdlib.h>
%}

/* Définition des tokens */
id [a-zA-Z][a-zA-Z0-9_]*
nb [0-9]+
espace ( |\t|\n|\r)+

/* Mots-clés du langage */
kw PROGRAM|IMPORTS|END[ ]IMPORTS|CONSTANTS|TYPES|VARIABLES|SUBPROGRAMS|BEGIN|END|const|var|func|proc|type|return|array|record|enum|pointer|END[ ]IF|IF|THEN|ELSE|ELSIF|CASE|OF|OTHERWISE|END[ ]CASE|SWITCH|END[ ]SWITCH|DEFAULT|FOR|END[ ]FOR|TO|STEP|WHILE|END[ ]WHILE|DO|REPEAT|UNTIL|FOREACH|IN|BREAK|END[ ]FOREACH|CONTINUE|FLOOR|CEIL|CONCAT|INPUT|OUTPUT|PRINT|PRINTLN|TRY|END[ ]TRY|CATCH|FINALLY|THROW|THROWS|end|to|begin|END[ ]CONSTANTS|END[ ]TYPES|END[ ]VARIABLES|END[ ]SUBPROGRAMS|MODULE|END[ ]MODULE|EXPORT

/* Littéraux */
str \"[^\"]*\"|\'[^\']*\'
real {nb}\.{nb}
boolean true|false

/* Types de base */
typeDeBase char|str|integer|real|double|boolean|string|void|null

/* Séparateurs */
separateur [,:\.\[\]\{\}]

/* Opérateurs */
op_arith [+\-*/]|\+\+|\-\-|DIV|MOD|POW|SQRT|ABS
op_log AND|OR|NOT|XOR
op_comp >|>=|<|<=|<>|==|===
op_affect :=|\+=|\-=|\*=|\/=|=
op_string CONCAT|LEN|SUBSTR
op_char ORD|CHR
op_adr [@^]
op_ref \^


/* Commentaires standards - la règle la plus spécifique d'abord */
comment \/\/.*|/\*.*\*\//

/* Commentaires intelligents - plus spécifique que les commentaires standards */
comment_intelligent \/\*\*[ \t]*@([^*]|\*[^/])*\*\/

/* Balises individuelles - ne seront matchées que si elles sont en dehors des commentaires intelligents complets */
balise_desc @desc[^\n@]*
balise_param @param[^\n@]*
balise_return @return[^\n@]*
balise_example @example[^\n@]*
balise_author @author[^\n@]*

/* Marqueurs de début et de fin de commentaire */
debut_comment \/\*\*[ \t]*@
fin_comment \*\/

finIns ;
ExpDoc flow[ ]doc[ ]generate[ ][a-zA-Z0-9]+\.flow[ ]\-\-format=[a-zA-Z]+[ ]\-\-output=[a-zA-Z0-9]+

%%
{comment_intelligent} { 
    printf("Commentaire Intelligent: %s\n", yytext); 
    /* Cette règle doit être avant les règles de commentaires standards */
}

{comment}       { printf("Commentaire Simple: %s\n", yytext); }

{balise_desc}       { printf("Balise Description: %s\n", yytext); }
{balise_param}      { printf("Balise Paramètre: %s\n", yytext); }
{balise_return}     { printf("Balise Retour: %s\n", yytext); }
{balise_example}    { printf("Balise Exemple: %s\n", yytext); }
{balise_author}     { printf("Balise Auteur: %s\n", yytext); }

{debut_comment}     { printf("Début de commentaire intelligent: %s\n", yytext); }
{fin_comment}       { printf("Fin de commentaire: %s\n", yytext); }

{espace}      { /* Ignorer les espaces */ }

{kw}          { printf("Mot clé: %s\n", yytext); }
{typeDeBase}  { printf("Type de base: %s\n", yytext); }
{nb}          { printf("Nombre entier: %s\n", yytext); }
{real}        { printf("Nombre réel: %s\n", yytext); }
{str}         { printf("Chaîne: %s\n", yytext); }
{boolean}     { printf("Booléen: %s\n", yytext); }

{separateur}  { printf("Séparateur: %s\n", yytext); }
{finIns}      { printf("Fin d'instruction: %c\n", yytext[0]); }
{op_arith}    { printf("Opérateur arithmétique: %s\n", yytext); }
{op_log}      { printf("Opérateur logique: %s\n", yytext); }
{op_comp}     { printf("Opérateur de comparaison: %s\n", yytext); }
{op_affect}   { printf("Opérateur d'affectation: %s\n", yytext); }
{op_string}   { printf("Opérateur de chaîne: %s\n", yytext); }
{op_char}     { printf("Opérateur de caractère: %s\n", yytext); }
{op_ref}      { printf("Opérateur de référence: %s\n", yytext); }
{op_adr}      { printf("Opérateur d'adresse: %s\n", yytext); }

{ExpDoc}      { printf("Outil de generation simple: %s\n", yytext); }

{id}          { printf("Identifiant: %s\n", yytext); }
.             { printf("Erreur: caractère inconnu '%s'\n", yytext); }

%%

int main() {
    yylex();
    return 0;
}

int yywrap() {
    return 1;
}