/*A program that counts the number of characters, words and lines in a file*/
%{
#include<stdio.h>
int chars = 0;
int words = 0;
int lines = 0;
%}
%%
[a-zA-Z]+ { words++; chars += strlen(yytext); }
\n { chars++; lines++; }
. { chars++; }
%%
main(int argc, char **argv)
{
yylex();
printf(" Number of lines=%d\n Number of words=%d\n Number of characters=%d\n",lines, words, chars);
}
