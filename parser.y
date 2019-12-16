%{
        #include <stdio.h>
        #include <string.h>
        int yylex();
        void yyerror(const char *message);
%}
%union {

}

%type PROGRAM 
%type STMT STMTS DEF-STMT PRINT-STMT
%type EXP  
%type IF-EXP THAN-EXP ELSE-EXP
%type VARIABLE VARIABLES
%type NUM-OP LOGICAL-OP AND-OP OR-OP NOT-OP
%type FUN-EXP FUN-CALL FUN-ID FUN-BODY FUN-NAME PARAM PARAMS
%type PLUS MINUS MULTIPLY DIVIDE MODULES GREATER SMALLER EQUAL

%token print-num print-bool
%token number
%token bool-val

%left '+' '-' '*' '/' mod '>' '<' '=' and or not define id fun if

%%
PROGRAM         : STMT STMTS {

                }
                ;
STMTS           : STMT STMTS {

                }
                | {

                }
                ;
STMT            : EXP | DEF-STMT | PRINT-STMT {

                }
                ;
PRINT-STMT      : '(' print-num EXP ')' {

                }
                | '(' print-bool EXP ')' {

                }
                ;
EXPS            : EXP EXPS {

                }
                | {

                }
                ;
EXP             : bool-val | number | VARIABLE | NUM-OP | LOGICAL-OP | FUN-EXP | FUN-CALL | IF-EXP ;

NUM-OP          : PLUS | MINUS | MULTIPLY | DIVIDE | MODULES | GREATER | SMALLER | EQUAL ;
        PLUS    : '(' '+' EXP EXP EXPS ')' { };
        MINUS   : '(' '-' EXP EXP ')' { };
        MULTIPLY: '(' '*' EXP EXP EXPS ')' { };
        DIVIDE  : '(' '/' EXP EXP ')' { };
        MODULES : '(' mod EXP EXP ')' { };
        GREATER : '(' '>' EXP EXP ')' { };
        SMALLER : '(' '<' EXP EXP ')' { };
        EQUAL   : '(' '=' EXP EXP EXPS ')' { };
LOGICAL-OP      : AND-OP | OR-OP | NOT-OP ;
        AND-OP  : '(' and EXP EXP EXPS ')' { };
        OR-OP   : '(' or EXP EXP EXPS ')' { };
        NOT-OP  : '(' not EXP ')' { };
DEF-STMT        : '(' define VARIABLE EXP ')' {

                }
                ;
        VARIABLE: id { 

                }
                ;
        VARIABLES: VARIABLE VARIABLES {

                }
                | {

                }
                ;

FUN-EXP         : '(' fun FUN-ID FUN-BODY ')' {

                }
                ;
        FUN-ID  : '(' VARIABLE VARIABLES ')' {

                }
                ;
        FUN-BODY: EXP {

                }
                ;
        FUN-CALL: '(' FUN-EXP PARAM PARAMS ')' {

                }
                | '(' FUN-NAME PARAM PARAMS ')' {

                }
                ;
        FUN-NAME: id {

                }
                ;
        PARAM   : EXP {

                }
                ;
        PARAMS : PARAM PARAMS {

                }
                | {

                }
                ;
        LAST-EXP: EXP {

                }
                ;

IF-EXP          : '(' if TEST-EXP THAN-EXP ELSE-EXP ')'
        TEST-EXP: EXP {

                }
                ;
        THAN-EXP: EXP {

                }
                ;
        ELSE-EXP: EXP {

                }
                ;
%%

void yyerror (const char *message) {
        fprintf (stderr, "%s\n",message);
}

int main(int argc, char *argv[]) {
        yyparse();
        return(0);
}
