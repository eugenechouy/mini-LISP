%{
    #include "ASTNode.h"
    #include "parser.tab.hh"
    extern std::stack<ASTType> type_stk;

    extern "C" {
        extern int yylex();
    }
%}
separator  [ \t\n\r]
letter     [a-z]
digit      [0-9]
number     0|[1-9]{digit}*|-[1-9]{digit}*
id         {letter}({letter}|{digit}|"-")*
bool-val   #[t|f]

%%
<<EOF>>     { return 0; }
{separator} {}

"+"         { return(yytext[0]); }
"-"         { return(yytext[0]); }
"*"         { return(yytext[0]); }
"/"         { return(yytext[0]); }
">"         { return(yytext[0]); }
"<"         { return(yytext[0]); }
"="         { return(yytext[0]); }
"mod"       { return(_mod); }

"and"       { return(_and); }
"or"        { return(_or); }
"not"       { return(_not); }

"define"    { return(_define); }
"fun"       { return(_fun); }
"if"        { return(_if); }

"print-num"  { type_stk.push(AST_PNUMBER); return(print_num); }
"print-bool" { type_stk.push(AST_PBOOLVAL); return(print_bool); }

{number}    { sscanf(yytext, "%d", &yylval.intVal); return(_number); }
{id}        { sscanf(yytext, "%s", yylval.id); return(_id); }
{bool-val}  { if(yytext[1] == 't') yylval.boolVal = true; 
              else yylval.boolVal = false; 
              return(_bool_val); 
            }

.           { return(yytext[0]); }
%%
