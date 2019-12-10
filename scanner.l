%{
#include "parser.tab.h"
%}
separator  [ \t\n\r]
letter     [a-z]
digit      [0-9]
number     0|[1-9]{digit}*|-[1-9]{digit}*
ID         {letter}({letter}|{digit}|"-")*
bool-val   #[t|f]
%%
\n	{ return(0); /* EOF */ }
[ \t]+	{ /* do nothing */ }
[0-9]+	{ yylval.ival = atoi(yytext)+1; return(INUMBER); }
"+"|"("|")"	{ return(yytext[0]); }
.	{ return(yytext[0]); }
%%
