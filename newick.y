 /* Raúl Daramus Raica  NIA: 796882 */
%{
#include <stdio.h>
#include <string.h>
char * arbol_RAIZ = ".";
float MAX_altura;
float MAX_alturaS;
int num_NODOS = 0;
int num_ESP = 0;
int num_Hojas;
int num_Hojas_ESP = 0;
int num_Padres = 0;
int num_Padres_ESP = 0;
%}
%union {
struct nodo {
	char * nombre;					
	float altura; 					
	float altura_ESP; 				
	int es_ESP; 					/* Si es un nodo marcado con Spain, es_ESP = 1; si no, es_ESP= 0 */
} datos_NODO;
}
%start arbol
/* TOKENS */
%token PAR_IZQ PAR_DCHA DOS_PUNTOS PUNTO_COMA COMA 
%token<datos_NODO> NOMBRE NOMBRES ALTURA
/* NO TERMINALES */
%type<datos_NODO> arbol lista nodo_SUB arbol_SUB
%%
arbol: /* nada */  					{}
	|  arbol_SUB PUNTO_COMA			{
										MAX_altura = $1.altura;
										MAX_alturaS = $1.altura_ESP;
										num_Hojas = num_NODOS - num_Padres;
										num_Hojas_ESP = num_ESP - num_Padres_ESP;
										printf("AT: %.2f\n",MAX_altura);
               		 					printf("RA: %s\n",arbol_RAIZ); 
               		 					printf("NA: %d\n",num_NODOS);
               		 					printf("NAE: %d\n",num_ESP);
               		 					printf("NH: %d\n",num_Hojas);
               		 					printf("NHE: %d\n",num_Hojas_ESP);
               		 					printf("ATE: %.2f\n",MAX_alturaS);
              						}
  	;
arbol_SUB:  
	 nodo_SUB						{	arbol_RAIZ = strdup($1.nombre); 
										$$.altura = $1.altura; 

										if($1.es_ESP == 1){
											$$.altura_ESP = $1.altura_ESP;
											$$.es_ESP = 1;
										} 
										else{
											$$.es_ESP = 0;
											$$.altura_ESP = 0.0;
										}
									}
	| PAR_IZQ lista PAR_DCHA nodo_SUB  {	arbol_RAIZ = strdup($4.nombre); 
											num_Padres = num_Padres + 1 ; 
											
											if($4.es_ESP == 1) { 
												num_Padres_ESP = num_Padres_ESP + 1; 
											}
											
											$$.altura = $2.altura + $4.altura;
											
											if($2.es_ESP == 1){
												$$.es_ESP = 1;
												$$.altura_ESP = $2.altura_ESP + $4.altura_ESP;
											} 
											else{
												$$.es_ESP = 0;
												$$.altura_ESP = 0.0;
											}
									    }
	;
nodo_SUB: /* nada */ 				{	$$.nombre = ""; 
										$$.altura = 1.0; 
										$$.altura_ESP = 1.0; 
										$$.es_ESP = 0; 
										num_NODOS = num_NODOS + 1 ;			      			  		  
									}
	| NOMBRE 						{	$$.nombre = strdup($1.nombre); 
										$$.altura = 1.0; 
										$$.altura_ESP = 1.0; 
										$$.es_ESP = 0; 
										num_NODOS = num_NODOS + 1; 			  		  
									}	
	| NOMBRES						{	$$.nombre = strdup($1.nombre); 
										$$.altura = 1.0; 
										$$.altura_ESP = 1.0; 
										$$.es_ESP = 1; 
										num_NODOS = num_NODOS + 1 ;
										num_ESP = num_ESP + 1;	  		  
									}
	| NOMBRE DOS_PUNTOS ALTURA 		{	$$.nombre = strdup($1.nombre); 
										$$.altura = $3.altura; 
										$$.altura_ESP = $3.altura; 
										$$.es_ESP = 0; 
										num_NODOS = num_NODOS + 1; 		 
									}
	| NOMBRES DOS_PUNTOS ALTURA		{	$$.nombre = strdup($1.nombre); 
										$$.altura = $3.altura; 
										$$.altura_ESP = $3.altura; 
										$$.es_ESP = 1; 
										num_NODOS = num_NODOS + 1;
										num_ESP = num_ESP + 1 ;
									}
	| DOS_PUNTOS ALTURA  			{	$$.nombre = ""; 
										$$.altura = $2.altura; 
										$$.altura_ESP = $2.altura; 
										$$.es_ESP = 0; 
										num_NODOS = num_NODOS + 1;		  
									}
	;	
lista: arbol_SUB					{	$$.altura = $1.altura; 
										
										if($1.es_ESP == 1){
											$$.altura_ESP = $1.altura_ESP;
											$$.es_ESP = 1;
										} 
										else{
											$$.es_ESP = 0;
											$$.altura_ESP = 0.0;
										}
									}
	| arbol_SUB COMA lista			{		if($1.altura > $3.altura){
												$$.altura = $1.altura;
											} 
										
											else{
												$$.altura = $3.altura;
											}

											if($1.es_ESP == 1 || $3.es_ESP == 1){
												$$.es_ESP = 1;

												if($1.es_ESP == 1 && $3.es_ESP == 0){
													$$.altura_ESP = $1.altura_ESP;
												} 

												else if($1.es_ESP == 0 && $3.es_ESP == 1){
													$$.altura_ESP = $3.altura_ESP;
												} 

												else{

													if($1.altura_ESP > $3.altura_ESP){
														$$.altura_ESP = $1.altura_ESP;
													} 

													else{
														$$.altura_ESP = $3.altura_ESP;
													}
												}
											} 
										
											else {
												$$.es_ESP = 0;
												$$.altura_ESP = 0.0;
											}
									}
	;
%%
int yyerror(char* s){
	printf("%s\n", s);
	return -1; 
}
int main(){
	int error = yyparse();
	return error;
}

