%{
        #include "ASTNode.h"
        std::stack<string> type_stk;
        ASTNode root;
        ASTNode* constructAST(ASTNode *exp1, ASTNode *exp2);

        extern "C" {
                extern int yylex();
                void yyerror(const char *message);
        }
%}
%union {
        int intVal;
        bool boolVal;
        string id;
}

/*
%type<intVal> PROGRAM 
%type<intVal> STMT STMTS DEF_STMT PRINT_STMT
%type<intVal> EXP EXPS 
%type<intVal> IF_EXP THAN_EXP ELSE_EXP
%type<intVal> VARIABLE VARIABLES
%type<intVal> NUM_OP LOGICAL_OP AND_OP OR_OP NOT_OP
%type<intVal> FUN_EXP FUN_CALL FUN_ID FUN_BODY FUN_NAME PARAM PARAMS
%type<intVal> PLUS MINUS MULTIPLY DIVIDE MODULES GREATER SMALLER EQUAL
*/

%type<ASTNode> PROGRAM 
%type<ASTNode> STMT STMTS PRINT_STMT
%type<ASTNode> EXP EXPS 

%token print_num print_bool
%token<intVal> number
%token<boolVal> bool_val
%token<id> id

%left '+' '-' '*' '/' mod '>' '<' '=' and or not define fun if

%%
PROGRAM         : STMT STMTS {
                        type_stk.push(AST_ROOT);
                        $$ = constructAST($1, $2);
                        root = $$;
                }
                ;
STMTS           : STMT STMTS {
                        type_stk.push(AST_ROOT);
                        $$ = constructAST($1, $2);
                }
                | {
                        type_stk.push(AST_NULL);
                        $$ = constructAST(NULL, NULL);
                }
                ;
/* STMT            : EXP | DEF_STMT | PRINT_STMT ; */
STMT            : PRINT_STMT ;

PRINT_STMT      : '(' print_num EXP ')' {
                        $$ = constructAST($3, NULL);
                }
                | '(' print_bool EXP ')' {
                        $$ = constructAST($3, NULL);
                }
                ;
EXPS            : EXP EXPS {

                }
                | {

                }
                ;
/* EXP             : bool_val | number | VARIABLE | NUM_OP | LOGICAL_OP | FUN_EXP | FUN_CALL | IF_EXP ; */
EXP             : bool_val {
                        ASTBoolVal *new_node = (ASTBoolVal *)malloc(sizeof(ASTBoolVal));
                        new_node->type = AST_BOOLVAL;
                        new_node->bool_val = $1;
                        $$ = (AST_NODE*)new_node;
                }
                | number {
                        ASTNumber *new_node = (ASTNumber *)malloc(sizeof(ASTNumber));
                        new_node->type = AST_NUMBER;
                        new_node->number = $1;
                        $$ = (AST_NODE*)new_node;
                }
                ;

/*
NUM_OP          : PLUS | MINUS | MULTIPLY | DIVIDE | MODULES | GREATER | SMALLER | EQUAL ;
        PLUS    : '(' '+' EXP EXP EXPS ')' { };
        MINUS   : '(' '-' EXP EXP ')' { };
        MULTIPLY: '(' '*' EXP EXP EXPS ')' { };
        DIVIDE  : '(' '/' EXP EXP ')' { };
        MODULES : '(' mod EXP EXP ')' { };
        GREATER : '(' '>' EXP EXP ')' { };
        SMALLER : '(' '<' EXP EXP ')' { };
        EQUAL   : '(' '=' EXP EXP EXPS ')' { };
LOGICAL_OP      : AND_OP | OR_OP | NOT_OP ;
        AND_OP  : '(' and EXP EXP EXPS ')' { };
        OR_OP   : '(' or EXP EXP EXPS ')' { };
        NOT_OP  : '(' not EXP ')' { };
DEF_STMT        : '(' define VARIABLE EXP ')' {

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

FUN_EXP         : '(' fun FUN_ID FUN_BODY ')' {

                }
                ;
        FUN_ID  : '(' VARIABLE VARIABLES ')' {

                }
                ;
        FUN_BODY: EXP {

                }
                ;
        FUN_CALL: '(' FUN_EXP PARAM PARAMS ')' {

                }
                | '(' FUN_NAME PARAM PARAMS ')' {

                }
                ;
        FUN_NAME: id {

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
        LAST_EXP: EXP {

                }
                ;

IF_EXP          : '(' if TEST_EXP THAN_EXP ELSE_EXP ')'
        TEST_EXP: EXP {

                }
                ;
        THAN_EXP: EXP {

                }
                ;
        ELSE_EXP: EXP {

                }
                ;
*/
%%

ASTNode* constructAST(ASTNode *exp1, ASTNode *exp2){
        ASTNode *new_node = (ASTNode *)malloc(sizeof(ASTNode));
        new_node->type = type_stk.top();
        type_stk.pop();
        new_node->left = exp1;
        new_node->right = exp2;
        return new_node;
}

void yyerror(const char *message) {
        fprintf (stderr, "%s\n",message);
}

int main(int argc, char *argv[]) {
        yyparse();
        return(0);
}
