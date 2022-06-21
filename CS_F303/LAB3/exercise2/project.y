%{
	#include<stdio.h>
	int yylex(void);
	int yyerror(const char *s);
	int success = 1;
%}

%token HEADER INT MAIN LB RB LCB RCB SC COMA VAR EQ OP
%start prm

%%
prm	: HEADER INT MAIN LB RB LCB BODY RCB {printf("Parsing successful..");}
BODY	: DECLARATION_STATEMENTS 
DECLARATION_STATEMENTS : DECLARATION_STATEMENT DECLARATION_STATEMENTS
			| DECLARATION_STATEMENT
DECLARATION_STATEMENT:INT VAR_LIST SC {}
VAR_LIST : VAR COMA VAR_LIST {/*This grammar confirms whether the variable names are seperated by commas or not*/}
	| VAR
%%

int main()
{
    yyparse();
 /*   if(success)
    	printf("Parsing Successful\n"); */
    return 0;
}

int yyerror(const char *msg)
{
	extern int yylineno;
	printf("Parsing Failed\nLine Number: %d %s\n",yylineno,msg);
	success = 0;
	return 0;
}

