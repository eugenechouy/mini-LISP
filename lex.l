%{
    #include "parser.tab.h"
    extern std::stack<string> type_stk;
%}
separator  [ \t\n\r]
letter     [a-z]
digit      [0-9]
number     0|[1-9]{digit}*|-[1-9]{digit}*
id         {letter}({letter}|{digit}|"-")*
bool-val   #[t|f]

%%
<<EOF>>     {}
{separator} {}

"+"         { return(yytext[0]); }
"-"         { return(yytext[0]); }
"*"         { return(yytext[0]); }
"/"         { return(yytext[0]); }
">"         { return(yytext[0]); }
"<"         { return(yytext[0]); }
"="         { return(yytext[0]); }
"mod"       { return(mod); }

"and"       { return(and); }
"or"        { return(or); }
"not"       { return(not); }

"define"    { return(define); }
"fun"       { return(fun); }
"if"        { return(if); }

"print-num"  { type_stk.push("PRINT-NUM"); return(print-num); }
"print-bool" { type_stk.push("PRINT-BOOL"); return(print-bool); }

{number}    { sscanf(yytext, "%d", &yylval.intVal); return(number); }
{id}        { sscanf(yytext, "%s", &yylval.id); return(id); }
{bool-val}  { if(yytext[1] == 't') yylval.boolVal = true; 
              else yylval.boolVal = false; 
              return(bool-val); 
            }

.           { return(yytext[0]); }
%%
