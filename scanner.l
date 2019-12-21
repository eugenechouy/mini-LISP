%{
    #include "ASTTree.hh"
    #include "parser.tab.hh"

    extern "C" {
        int yylex();
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

"+"         { type_stk.push(AST_PLUS); return(yytext[0]); }
"-"         { type_stk.push(AST_MINUS); return(yytext[0]); }
"*"         { type_stk.push(AST_MULTIPLY); return(yytext[0]); }
"/"         { type_stk.push(AST_DIVIDE); return(yytext[0]); }
">"         { type_stk.push(AST_GREATER); return(yytext[0]); }
"<"         { type_stk.push(AST_SMALLER); return(yytext[0]); }
"="         { type_stk.push(AST_EQUAL); return(yytext[0]); }
"mod"       { type_stk.push(AST_MODULES); return(_mod); }

"and"       { type_stk.push(AST_AND); return(_and); }
"or"        { type_stk.push(AST_OR); return(_or); }
"not"       { type_stk.push(AST_NOT); return(_not); }

"define"        { type_stk.push(AST_DEFINE); return(_define); }
"fun"|"lambda"  { type_stk.push(AST_FUN); return(_fun); }
"if"            { type_stk.push(AST_IF); return(_if); }

"print-num"  { type_stk.push(AST_PNUMBER); return(print_num); }
"print-bool" { type_stk.push(AST_PBOOLVAL); return(print_bool); }

{number}    { sscanf(yytext, "%d", &yylval.intVal); return(_number); }
{id}        { yylval.id = strdup(yytext); return(_id); }
{bool-val}  { if(yytext[1] == 't') yylval.boolVal = true; 
              else yylval.boolVal = false; 
              return(_bool_val); 
            }

.           { return(yytext[0]); }
%%
