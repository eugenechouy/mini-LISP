%{
    #include "parser.tab.h" 
    int position = 0;
%}

%%
[0-9]+              { position+=yyleng; sscanf(yytext, "%d", &yylval.intVal); return(NUMBER); }
"+"|"-"|"*"         { position+=yyleng; yylval.intVal=position; return(yytext[0]); }
"("|")"|"["|"]"|"," { position+=yyleng; return(yytext[0]); }
"^T"                { position+=yyleng; return(TRANS); }    
[ \t]+              { position+=yyleng; }
[\n\r]              { return(yytext[0]); }
%%
 