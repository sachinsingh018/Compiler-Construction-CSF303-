%option yylineno

%{
	#include<stdio.h>
	#include<string.h>
	#include"y.tab.h"
	#include<math.h>
	extern int var_count;

%}

%%
"#include<stdio.h>" {return HEADER;}
"for"    {return FOR;}
"do"      {return DO;}
"while"   {return WHILE;}
"if" 	{return IF;}
"then" 	{return THEN;}
"else"	{return ELSE;}
"printf" {return PRINT;}
"scanf" {return SCAN;}
"<"         {return LT;}
">"         {return GT;}
"<="         {return LE;}
">="         {return GE;}
"=="         {return EQQ;}
"!="          {return NE;}
"||"         { return OR;}
"&&"         {return AND;}
"int"	{yylval.data_type=0;return INT;}
"char" {yylval.data_type=1; return CHAR;}
"main" {return MAIN;}
"("	{return LB;}
")"	{return RB;}
"{"	{return LCB;}
"}"	{return RCB;}
","	{return COMA;}
";"	{return SC;}
" & "   {return AN;}
" " "   { return INVS; }
" %d "   {return DT1; }
" %c "   {return DT2; }
" %f "   {return DT3; }
[+] {return PLUS;}
[-] {return MINUS;}
[*] {return MUL;}
[/] {return DIV;}
"="	{return EQ;}
[a-z]+  {strcpy(yylval.var_name,yytext);return RCHAR;}
[A-Z]+  {strcpy(yylval.var_name,yytext);return UCHAR;}
[\n\t ]+  {/*new line or space*/}
[0-9]+    {yylval=atoi(yytext); return INTEGER;}
^[-+]?[0-9]*[.][0-9]+   {yylval=atoi(yytext); return FLT;}
. {printf("invalid character sequence %s\n",yytext); exit(0);}
[\n\t ]+  {/*new line or space*/}
. {printf("invalid character sequence %s\n",yytext); exit(0);}
%%


int yywrap(void)
{
    return 1;
}
