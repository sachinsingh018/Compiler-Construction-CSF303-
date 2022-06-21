/* Program to add line numbers 
 to a given file*/
%{ 
int line_number = 1;  // initializing line number to 1 
%} 
  
/* simple name definitions to simplify 
the scanner specification name  
definition of line*/
line .*\n     
  
%% 
{line} { printf("%10d %s", line_number++, yytext); }  
  
 /* whenever a line is encountered increment count*/
  
 /* 10 specifies the padding from left side to  
                    present the line numbers*/
   
 /* yytext The text of the matched pattern is stored 
                           in this variable (char*)*/
%% 
  
int yywrap(){}  
  
int main(int argc, char*argv[]) 
{ 
extern FILE *yyin;    // yyin as pointer of File type 
  
yyin = fopen("input.c","r");  /* yyin points to the file  
                                   testtest.c and opens it 
                                   in read mode.*/
  
yylex();   // The function that starts the analysis. 
  
return 0; 
}
