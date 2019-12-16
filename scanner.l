%{
    #include "parser.tab.h"
%}
separator  [ \t\n\r]
letter     [a-z]
digit      [0-9]
number     0|[1-9]{digit}*|-[1-9]{digit}*
id         {letter}({letter}|{digit}|"-")*
bool-val   #[t|f]

%%
{number}    { return(number); }
{id}        { return(id); }
{bool-val}  { return(bool-val); }

'+'         { return(yytext[0]); }
'-'         { return(yytext[0]); }
'*'         { return(yytext[0]); }
'/'         { return(yytext[0]); }
'>'         { return(yytext[0]); }
'<'         { return(yytext[0]); }
'='         { return(yytext[0]); }
"mod"       { return(mod); }

"and"       { return(and); }
"or"        { return(or); }
"not"       { return(not); }

"define"    { return(define); }
"fun"       { return(fun); }
"if"        { return(if); }

"print-num" { return(print-num); }
"print-bool"{ return(print-bool); }

<<EOF>>     {}
.           { return(yytext[0]); }
%%
