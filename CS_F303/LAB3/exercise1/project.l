%option yylineno

%{
	#include<stdio.h>
	#include"y.tab.h"
	#include<math.h>
	#include<string.h>
	extern char unmatched_token[];
%}

%%
"#include<stdio.h>" {return HEADER;}
"int"	{return INT;}
"main"	{return MAIN;}
"("	{return LB;}
")"	{return RB;}
"{"	{return LCB;}
"}"	{return RCB;}
[\n\t ]+  {/*new line or space*/}
. {strcpy(unmatched_token,yytext);}
%%


int yywrap(void)
{
    return 1;
}
