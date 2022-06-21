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
	int errcnt = 0;
	char errmsg[40];
	extern char *yytext;
	extern FILE *yyin;
	extern FILE *yyout;
	extern int yyparse();
	extern int lineno;
	int yydebug = 1;
	int t;
%}

%union{
int data_type;
char var_name[30];
}
%token HEADER MAIN LB RB LCB RCB SC COMA VAR EQ PLUS MINUS MUL DIV DO WHILE IF THEN ELSE PRINT SCAN LR GR LE GE EQQ NE OR AND INT RCHAR AMB INVS DT1 DT2 DT3 UCHAR INTEGER FLT 

%left PLUS MINUS
%left MUL DIV
%right EQ
%left OR AND
%left LE GE LT GT EQ NE

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
				insert($1,current_data_type,lineno);
			     }
	| VAR {
		insert($1,current_data_type,lineno);
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
	| FLOAT  { 
 			$$=$1;
			current_data_type=$1;
		 }
	| DOUBLE {      $$=$1;
			current_data_type=$1;}
	;


PROGRAM_STATEMENTS : PROGRAM_STATEMENT PROGRAM_STATEMENTS 
						  {
							printf("\n program statements successfully parsed\n");
						  }
			| PROGRAM_STATEMENT
			;

PROGRAM_STATEMENT : VAR EQ A_EXPN SC { $$ = lookupType($1); }	
					
			|ST {      printf("\n Input accepted);	}
			|ST2 {      printf("\n Input accepted);	}
			|ST3 {      printf("\n Input accepted);	}
                        |ST4 {      printf("\n Input accepted);	}
  			|ST4 {      printf("\n Input accepted);	}
			|
			;
S: ST  
		{      printf("\n Input accepted);	};
ST:   IF LB E RB THEN ST1 SC ELSE ST1 SC
      | IF LB E RB THEN ST1 SC
      ;
E: ST
   |A_EXPN
   ;
S1: ST2 {      printf("\n Input accepted);	};
ST2: WHILE LB A_EXPN RB LCB ST3 RCB 
ST3: ST3 ST3
     |A_EXPN SC
     ;
S2: ST3{      printf("\n Input accepted);	};
ST3: FOR LB A_EXPN SC A_EXPN SC A_EXPN RB BD
     ;
BD: LCB PROC RCB
    |A_EXPN SC
    |
    ;
PROC: PROC PROC
     |A_EXPN SC
     |ST3
     ;
ST4: PRINT LB INVS DE INVS DL RB SC
     |PRINT LB INVS II INVS RB SC
     ;
DE:  DE DE
    | DT1
    | DT2
    | DT3 
    |
    ;
II: | INTEGER
    | RCHAR
    | UCHAR
    | FLT 
    |
    ;
DL:COMA DL DL
   | A_EXPN
   | 
   ;
ST5: SCAN LB INVS DE2 INVS DL2 RB SC
     ;
DE2:  DT1
    | DT2
    | DT3 
    |
    ;
DL2:COMA AN DL3
    | COMA AN DL2
   ;
DL3: A_EXPN
    ;
A_EXPN		:A_EXPN PLUS A_EXPN  { $$=$1+$3;}
		|A_EXPN MINUS A_EXPN { $$=$1-$3;}
		|A_EXPN MUL A_EXPN   { $$=$1*$3;}
		|A_EXPN DIV A_EXPN   { $$=$1/$3;}
		|A_EXPN LE A_EXPN
		|A_EXPN GE A_EXPN
		|A_EXPN NE A_EXPN
		|A_EXPN OR A_EXPN
		|A_EXPN AND A_EXPN
		|A_EXPN EQQ A_EXPN
		|A_EXPN LT A_EXPN
		|A_EXPN GT A_EXPN
		|A_EXPN OR A_EXPN
		|A_EXPN AND A_EXPN
		| LB A_EXPN RB  { $$ = $2; }
		| VAR { $$ = lookupType($1); }
%%

int main( int argc,char *att[] )                            // USED FILE HANDLING FUNCTIONS AND IMPLEMENTATIONS OF C
{
   strcpy(errormsg,"type error\n");
   int i;
   if(att < 2) {
      printf("Usage: ./cfc Symbol Table \n");
      exit(0);
   }
   FILE *fp = fopen(att[1],"r");
   if(!fp) {
     printf("Unable to open file for reading\n");
     exit(0);
   }
   yyin = fp;

   fp = fopen("symtab.c","w+");                             // Linked to a seperate C file where symbol table is implemented using hash table      
   if(!fp) {
     printf("Unable to open file for writing\n");
     exit(0);
   }
int flag = yyparse();

   symtab_dump(fp);  
   lineno--;  
   printf("\nsemantic error cnt: %d \tlines of code: %d\n",errcnt,lineno);

   /* cleanup */
   fclose(fp);
   fclose(yyin);

   return flag;
}


yywrap()
{
   return(1);
}

int yyerror(char * msg)
{ fprintf(stderr,"%s: line %d: \n",msg,lineno);
  return 0;
}