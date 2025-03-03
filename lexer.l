%{
    #include <stdio.h>
    #include <stdlib.h>
%}
id [a-zA-Z][a-zA-Z0-9]*
nb [0-9]+
kw var|array|type|record|enum|pointer|end|to|const|proc|begin|func|return
typeDeBase char|integer|real|double|boolean|string|void
separateur ","|":"|"."|"["|"]"|"{"|"}"
%%
{kw} printf("mot cle: %s\n", yytext);
{typeDeBase} printf("type de base: %s\n", yytext);
{nb} printf("nb: %d\n", atoi(yytext));
{id} printf("id: %s\n", yytext);
{separateur} printf("separateur: %s\n", yytext);
";" printf("fin d'instruction: %c\n", yytext[0]);
"=" printf("operateur de declaration: %c\n", yytext[0]);
. printf("error: %s inconnu\n", yytext); 
%%
int main(){
    yylex();
    return 0;
}
int yywrap() { 
    return 1; 
}