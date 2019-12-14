%{
    #include "parser.tab.h" 
%}

%%
"add"           { return(ADD); }
"sub"           { return(SUB); }
"mul"           { return(MUL); }
"mod"           { return(MOD); }
"inc"           { return(INC); }
"dec"           { return(DEC); }
"load"          { return(LOAD); }
0|[-]?[1-9][0-9]*   { sscanf(yytext, "%d", &yylval.intVal); return(NUMBER); }
[ \t\n\r]       { }
%%
 