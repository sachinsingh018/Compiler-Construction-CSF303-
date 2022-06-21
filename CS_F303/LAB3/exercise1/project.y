%{
	#include<stdio.h>
	int yylex(void);
	int yyerror(const char *s);
	int success = 1;
	char unmatched_token[40];
	extern char*yytext;
%}

%token SC COMA VAR EQ OP HEADER INT MAIN LB RB LCB RCB 
%start prm

%%
prm	: HEADER INT MAIN LB RB LCB RCB 
%%

int main()
{
    yyparse();
    if(success)
    	printf("Parsing Successful\n");
    return 0;
}

int yyerror(const char *msg)
{
	extern int yylineno;
	
	printf("Parsing Failed\nLine Number: %d %s unmatched token %s\n",yylineno,msg,unmatched_token);
	success = 0;
	return 0;
}

