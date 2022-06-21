/*Definition Section*/
%{
#include<stdio.h>
%}


/*Rule Section*/

%%
\/\/(.*) {/*Single line comment*/};					

\/\*(.*\n)*.*\*\/  {/*Regular expression for multi line comment*/};			
%%

/*call the yywrap function*/
int yywrap()
{
return 1;
}



/*Auxiliary function*/
/*Driver function*/

int main()
{
yyin=fopen("input.c","r");
yyout=fopen("out.c","w");
/*call the yylex function.*/
yylex();
return 0;
}
