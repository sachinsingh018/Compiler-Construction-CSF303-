%{
	#include<stdio.h>
	#include<stdlib.h>
	#include<string.h>
	int yylex(void);
	int yyerror(const char *s);
	int success = 1;
	int current_data_type;
	int expn_type=-1;
	int temp;
	struct symbol_table{char var_name[30]; int type;}var_list[20];
	int var_count=-1;
	extern int lookup_in_table(char var[30]);
	extern void insert_to_table(char var[30], int type);
%}

%union{
int data_type;
char var_name[30];
}
%token HEADER MAIN LB RB LCB RCB SC COMA VAR EQ PLUS MINUS MUL DIV EXP UPLUS UMINUS

%left PLUS MINUS
%left MUL DIV

%token<data_type>INT
%token<data_type>CHAR
%token<data_type>FLOAT
%token<data_type>DOUBLE

%type<data_type>DATA_TYPE
%type<var_name>VAR
%start prm

%%
prm	: HEADER MAIN_TYPE MAIN LB RB LCB BODY RCB {
							printf("\n parsing successful\n");
						   }
BODY	: DECLARATION_STATEMENTS PROGRAM_STATEMENTS
DECLARATION_STATEMENTS : DECLARATION_STATEMENT DECLARATION_STATEMENTS 
						  {
							printf("\n Declaration section successfully parsed\n");
						  }
			| DECLARATION_STATEMENT
DECLARATION_STATEMENT: DATA_TYPE VAR_LIST SC {}
VAR_LIST : VAR COMA VAR_LIST {
				insert_to_table($1,current_data_type);
			     }
	| VAR {
		insert_to_table($1,current_data_type);
	      }

MAIN_TYPE : INT
DATA_TYPE : INT {
			$$=$1;
			current_data_type=$1;
		} 
	| CHAR  {
			$$=$1;
			current_data_type=$1;
		}
	| FLOAT {}
	| DOUBLE {}


PROGRAM_STATEMENTS : PROGRAM_STATEMENT PROGRAM_STATEMENTS 
						  {
							printf("\n program statements successfully parsed\n");
						  }
			| PROGRAM_STATEMENT

PROGRAM_STATEMENT : VAR EQ A_EXPN SC {	
					if((temp=lookup_in_table($1))!=-1)
					{
						if(expn_type==-1)
						{
							expn_type=temp;
						}else if(expn_type!=temp)
						{
							printf("\ntype mismatch in the expression\n");
							exit(0);
						}
					}else
					{
						printf("\n variable \"%s\" undeclared\n",$1);exit(0);
					}
					expn_type=-1;	
				     }
A_EXPN		:A_EXPN PLUS A_EXPN
		|A_EXPN MINUS A_EXPN
		|A_EXPN MUL A_EXPN
		|A_EXPN DIV A_EXPN
		| LB A_EXPN RB 
		| VAR {
			if((temp=lookup_in_table($1))!=-1)
			{
				if(expn_type==-1)
				{
					expn_type=temp;
				}else if(expn_type!=temp)
				{
					printf("\ntype mismatch in the expression\n");
					exit(0);
				}
			}else
			{
				printf("\n variable \"%s\" undeclared\n",$1);exit(0);
			}
		     }

%%

int lookup_in_table(char var[30])
{
	return -1;
}
void insert_to_table(char var[30], int type)
{
}
int main()
{
    yyparse();
/*    if(success)
    	printf("Parsing Successful\n");*/
    return 0;
}

int yyerror(const char *msg)
{
	extern int yylineno;
	printf("Parsing Failed\nLine Number: %d %s\n",yylineno,msg);
	success = 0;
	return 0;
}

