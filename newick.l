 /* Raúl Daramus Raica  NIA: 796882 */
%{
#include "y.tab.h"
%}
%%
Spain[^;:,()]* { yylval.datos_NODO.nombre = strdup(yytext); return(NOMBRES);} 
[a-zA-Z]+[^;:,()]* { yylval.datos_NODO.nombre = strdup(yytext); return(NOMBRE);} 
[0-9]*"."?[0-9]* { yylval.datos_NODO.altura = atof(yytext);return(ALTURA);}  
":" { return(DOS_PUNTOS);}
";" { return(PUNTO_COMA);}
"," { return(COMA);}
"(" { return(PAR_IZQ);}
")" { return(PAR_DCHA);}
'\n' { /* NO HACER NADA */}
[ \t] { /* NO HACER NADA */}
. { /* NO HACER NADA */}
%%
