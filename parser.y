%{
        #include <stdio.h>
        #include <string.h>
        int yylex();
        void yyerror(const char *message);
%}
%union {

}

%%
PROGRAM : STMT STMTS {

        }
STMTS   : STMT STMTS {

        }
%%

void yyerror (const char *message)
{
        fprintf (stderr, "%s\n",message);
}

int main(int argc, char *argv[]) {
        yyparse();
        return(0);
}
