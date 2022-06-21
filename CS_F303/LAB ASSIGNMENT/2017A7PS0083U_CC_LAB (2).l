%option yylineno

%{
  #include<stdio.h>
  #include<string.h>
  #include"y.tab.h"
  #include<math.h>
  extern int var_count;
%}

%%

#include<[a-z]+.h> {return HEADER;}
#include<(\/[a-z]+)+\/[a-z]+.h> {return HEADER;}

"int" {yylval.data_type=0; return INT;}
"char" {yylval.data_type=1; return CHAR;}
"float" {yylval.data_type=2; return FLOAT;}
"double" {yylval.data_type=3; return DOUBLE;}

"main" {return MAIN;}

"scanf" {return SCANF;}
"printf" {return PRINTF;}
"if" {return IF;}
"else" {return ELSE;}
"while" {return WHILE;}
"do" {return DO;}
"for" {return FOR;}

"?" {return QUES;}
"\"" {return QUOTE;}
":" {return COLN;}
"("	{return LB;}
")"	{return RB;}
"{"	{create_new_table(); return LCB;}
"}"	{delete_table(); return RCB;}
"[" {return LSB;}
"]" {return RSB;}
","	{return COMA;}
";"	{return SC;}
"<"	{return LT;}
">"	{return GT;}
"<=" {return LTE;}
">=" {return GTE;}
"!=" {return NEQ;}
"==" {return LEQ;}
"!" {return NOT;}
"&&" {return LAND;}
"&" {return AND;}
"||" {return LOR;}
"++" {return UPLUS;}
"--" {return UMINUS;}

[\^] {return EXP;}
[+] {return PLUS;}
[-] {return MINUS;}
[%] {return MOD;}
[*] {return MUL;}
[/] {return DIV;}
"="	{return EQ;}

\".*\" {strcpy(yylval.text,yytext);return LITERAL;}
[a-zA-Z]+[0-9]* {strcpy(yylval.var_name,yytext);return VAR;}
[0-9]* {return NUM;}
[\n\t ]+ {/*new line or space*/}

. {printf("invalid character sequence %s\n",yytext); exit(0);}

%%


int yywrap(void)
{
    return 1;
}