%{										/* 2017A7PS0083U SACHIN SINGH */
	#include<stdio.h>
	#include<stdlib.h>							/* CC LAB ASSIGNMENT  */
	#include<string.h>

	int yylex(void);
	int yyerror(const char *s);
	int success = 1;
	int current_data_type;
  char text [30];
	int expn_type=-1;
	int temp;

  struct symbol_table {
    char var_name [30];
    int type;
    int isArray;
  };

  struct node {
    struct symbol_table var_list [20];
    struct node *prev;    
  };

  struct node* head = NULL;

  extern void create_new_table ();
  extern void delete_table ();
	extern int lookup_in_table (char var[30]);
	extern void insert_to_table (char var[30], int type, int isArray);
  extern int hash (char var[30]);
%}

%union{
	int data_type;
	char var_name[30];
  char text[30];
}

%token HEADER MAIN VAR NUM SCANF PRINTF AND
%token LB RB LCB RCB LSB RSB 
%token SC COMA QUES COLN QUOTE
%token EQ PLUS MINUS MUL DIV EXP UPLUS UMINUS MOD 
%token LT GT LTE GTE NEQ LEQ LAND LOR NOT 
%token IF ELSE WHILE DO FOR

%left PLUS MINUS
%left MUL DIV MOD
%right EXP
%left UPLUS UMINUS

%token<data_type>INT
%token<data_type>CHAR
%token<data_type>FLOAT
%token<data_type>DOUBLE
%token<text> LITERAL

%type<data_type>DATA_TYPE
%type<var_name>VAR
%type<text>PLACEHOLDER

%start PROGRAM

%%

PROGRAM	: HEADERS MAIN_TYPE MAIN LB RB LCB BODY RCB
          {
					  printf("parsing successful\n");
					}

HEADERS : HEADER HEADERS
	    	| HEADER

BODY	: DECLARATION_STATEMENTS PROGRAM_STATEMENTS BODY
    	| DECLARATION_STATEMENTS PROGRAM_STATEMENTS

DECLARATION_STATEMENTS : DECLARATION_STATEMENT DECLARATION_STATEMENTS 
                          {
                            //printf("\n Declaration section successfully parsed\n");
                          }
                  			| DECLARATION_STATEMENT

DECLARATION_STATEMENT : DATA_TYPE VAR_LIST SC

VAR_LIST : VAR COMA VAR_LIST 
            {
				      insert_to_table($1,current_data_type,0);
			      }
          | VAR LSB NUM RSB
            {
		          insert_to_table($1,current_data_type,1);
			      }
          | VAR LSB VAR RSB
            {
              insert_to_table($1,current_data_type,1);
            }
	        | VAR
            {
		          insert_to_table($1,current_data_type,0);
	          }


MAIN_TYPE : INT

DATA_TYPE : INT 
            {
			        $$=$1;
			        current_data_type=$1;
		        } 
          | CHAR
            {
              $$=$1;
              current_data_type=$1;
            }
          | FLOAT
            {
              $$=$1;
              current_data_type=$1;
            }
          | DOUBLE
            {
              $$=$1;
              current_data_type=$1;
            }

PROGRAM_STATEMENTS : PROGRAM_STATEMENT PROGRAM_STATEMENTS 
                      {
                        printf("\n program statements successfully parsed\n");
                      }
			              | PROGRAM_STATEMENT

PROGRAM_STATEMENT : VAR LSB NUM RSB EQ A_EXPN SC
                    {                                      	
                      if ((temp=lookup_in_table($1)) != -1)
                      {
                        if (expn_type == -1)
                        {
                          expn_type=temp;
                        }
                        else if (expn_type != temp)
                        {
                          printf("ERROR - type mismatch in the expression\n");
                          exit(0);
                        }
                      }
                      else
                      {
                        printf("ERROR - variable \"%s\" undeclared\n",$1);exit(0);
                      }
                      expn_type=-1;                      
                    }
                  | VAR EQ A_EXPN SC 
                    {	
                      if ((temp=lookup_in_table($1)) != -1)
                      {
                        if (expn_type == -1)
                        {
                          expn_type=temp;
                        }
                        else if (expn_type != temp)
                        {
                          printf("ERROR - type mismatch in the expression\n");
                          exit(0);
                        }
                      }
                      else
                      {
                        printf("ERROR - variable \"%s\" undeclared\n",$1);exit(0);
                      }
                      expn_type=-1;
				            }
                  | CONDITIONAL
                  | LOOP
                  | FUNCTION

FUNCTION : READ
          | WRITE

READ : SCANF LB PLACEHOLDER COMA AND VAR LSB NUM RSB RB SC
      | SCANF LB PLACEHOLDER COMA AND VAR LSB VAR RSB RB SC
      | SCANF LB PLACEHOLDER COMA VAR RB SC
      | SCANF LB PLACEHOLDER COMA AND VAR RB SC


WRITE : PRINTF LB PLACEHOLDER COMA VAR LSB NUM RSB RB SC
      | PRINTF LB PLACEHOLDER COMA VAR LSB VAR RSB RB SC
      | PRINTF LB PLACEHOLDER COMA VAR RB SC
      | PRINTF LB PLACEHOLDER RB SC

PLACEHOLDER : LITERAL
              {
                strcpy(text,$1);
              }

CONDITIONAL : IF LB CLOG_EXPN RB LCB PROGRAM_STATEMENT RCB ELSE LCB PROGRAM_STATEMENT RCB				
            | IF LB CLOG_EXPN RB LCB PROGRAM_STATEMENT RCB				
            | LB CLOG_EXPN RB QUES LCB LOOP_BODY RCB COLN LCB LOOP_BODY RCB
				
LOOP : WHILE LB CLOG_EXPN RB LCB LOOP_BODY RCB
      | DO LCB LOOP_BODY RCB WHILE LB CLOG_EXPN RB
      | FOR LB PROGRAM_STATEMENT CLOG_EXPN SC A_EXPN RB LCB LOOP_BODY RCB

LOOP_BODY : BODY
          | PROGRAM_STATEMENTS BODY
          | PROGRAM_STATEMENTS

CLOG_EXPN : SLOG_EXPN BCMP SLOG_EXPN
          | SLOG_EXPN

BCMP : LAND 
      | LOR

SLOG_EXPN	: NOT LB SLOG_EXPN RB 
          | VAR BLOG VAR
          | VAR BLOG NUM

BLOG : GTE
      | LTE
      | GT
      | LT
      | NEQ
      | LEQ 

A_EXPN : A_EXPN PLUS A_EXPN
        | A_EXPN MINUS A_EXPN
        | A_EXPN MUL A_EXPN
        | A_EXPN DIV A_EXPN
        | A_EXPN MOD A_EXPN
        | A_EXPN EXP A_EXPN
        | A_EXPN UPLUS
        | A_EXPN UMINUS
        | LB A_EXPN RB 
        | NUM
        | VAR LSB NUM RSB
        | VAR LSB VAR RSB
        | VAR 
          {  
            if ((temp=lookup_in_table($1)) != -1)
            {
              if (expn_type == -1)
              {
                expn_type=temp;
              }
              else if (expn_type != temp)
              {
                printf("ERROR - type mismatch in the expression\n");
                exit(0);
              }
            }
            else
            {
              printf("ERROR - variable \"%s\" undeclared\n",$1);exit(0);
            }
          }

%%

void create_new_table () {

    struct node* new_node = (struct node*) malloc(sizeof(struct node));

    if (head == NULL) {        
        new_node->prev = NULL;        
    }
    else {    
        new_node->prev = head;        
    }

    head = new_node;

    for (int i=0; i<20; i++) {
        head->var_list[i].type = -1;      
    }    

}

void delete_table () {

    if (head->prev == NULL) {
        free(head);
        head = NULL;
    }

    else {
        struct node* temp = head;    
        head = head->prev;    
        free(temp);
    }   

}

void insert_to_table (char var[30], int type, int isArray) {

    int index = hash(var);

    while (head->var_list[index].type != -1) {
        index = (index + 1) % 20;
    } 
    
    strcpy(head->var_list[index].var_name,var);
    head->var_list[index].type = type;
    head->var_list[index].isArray = isArray;

}

int lookup_in_table (char var[30]) {

    int index = hash(var);
    struct node* iterator = head;    

    while (iterator != NULL) {

        while (iterator->var_list[index].type != -1) {

            if (strcmp(iterator->var_list[index].var_name,var) == 0) {
                return iterator->var_list[index].type;                
            }

            index = (index + 1) % 20;
        }

        iterator = iterator->prev;
    }

    return -1;
}

int hash (char var[30]) {
   
    long long int hash = 7;

    for (int i = 0; i < strlen(var); i++) {
        hash = hash*31 + (int) var[i];
    }

    hash = hash % 20;    
    return hash;

}

int main() {

    yyparse();
    // if(success)
    //   printf("Parsing Successful\n");
    return 0;

}

int yyerror(const char *msg) {

	extern int yylineno;
	printf("Parsing Failed\nLine Number: %d %s\n",yylineno,msg);
	success = 0;
	return 0;

}
