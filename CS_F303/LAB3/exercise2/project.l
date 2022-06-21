%option yylineno

%{
	#include<stdio.h>
	#include"y.tab.h"
	#include<math.h>
	extern int yyerror(const char *msg);

%}

%%
"#include<stdio.h>" {return HEADER;}
"int"	{return INT;}
"main"	{return MAIN;}
"("	{return LB;}
")"	{return RB;}
"{"	{return LCB;}
"}"	{return RCB;}
","	{return COMA;}
";"	{return SC;}
[a-z]+  {return VAR;}
[\n\t ]+  {/*new line or space characters*/}
. {printf("unexpected character sequence %s",yytext); exit(0);}
%%

int yywrap(void)
{
    return 1;
}
