/*Program to print +, -, *, /, +, numbers, newline. Program also strips of whitespaces. Anything apart from this is printed as mystery character*/ 
%{
#include<stdio.h>
%}
%%
"+" { printf("plus\n"); }
"-" { printf("MINUS\n"); }
"*" { printf("TIMES\n"); }
"/" { printf("DIVIDE\n"); }
"|" { printf("ABS\n"); }
[0-9]+ { printf("NUMBER %s\n", yytext); }
\n { printf("NEWLINE\n"); }
[ \t] {printf("Blank"); }
. { printf("Mystery character %s\n", yytext); }
%%
main(int argc, char **argv)
{
        yylex();
}
