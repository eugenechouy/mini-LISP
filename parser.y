%{
        #include "ASTNode.h"
        std::stack<ASTType> type_stk;
        ASTNode *root;
        ASTNode* constructAST(ASTNode *exp1, ASTNode *exp2);
        ASTVal* ASTVisit(ASTNode *current);

        extern "C" {
            extern int yylex();
            void yyerror(const char *message);
        }
%}
%union {
    int intVal;
    bool boolVal;
    char* id;
    ASTNode *node;
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

%type<node> PROGRAM 
%type<node> STMT STMTS PRINT_STMT
%type<node> EXP EXPS 

%token print_num print_bool
%token<intVal> _number
%token<boolVal> _bool_val
%token<id> _id

%left '+' '-' '*' '/' _mod '>' '<' '=' _and _or _not _define _fun _if

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
/* EXP             : _bool_val | _number | VARIABLE | NUM_OP | LOGICAL_OP | FUN_EXP | FUN_CALL | IF_EXP ; */
EXP             : _bool_val {
                    ASTBoolVal *new_node = (ASTBoolVal*)malloc(sizeof(ASTBoolVal));
                    new_node->type = AST_BOOLVAL;
                    new_node->bool_val = $1;
                    $$ = (ASTNode*)new_node;
                }
                | _number {
                    ASTNumber *new_node = (ASTNumber*)malloc(sizeof(ASTNumber));
                    new_node->type = AST_NUMBER;
                    new_node->number = $1;
                    $$ = (ASTNode*)new_node;
                }
                ;

/*
NUM_OP          : PLUS | MINUS | MULTIPLY | DIVIDE | MODULES | GREATER | SMALLER | EQUAL ;
        PLUS    : '(' '+' EXP EXP EXPS ')' { };
        MINUS   : '(' '-' EXP EXP ')' { };
        MULTIPLY: '(' '*' EXP EXP EXPS ')' { };
        DIVIDE  : '(' '/' EXP EXP ')' { };
        MODULES : '(' _mod EXP EXP ')' { };
        GREATER : '(' '>' EXP EXP ')' { };
        SMALLER : '(' '<' EXP EXP ')' { };
        EQUAL   : '(' '=' EXP EXP EXPS ')' { };
LOGICAL_OP      : AND_OP | OR_OP | NOT_OP ;
        AND_OP  : '(' _and EXP EXP EXPS ')' { };
        OR_OP   : '(' _or EXP EXP EXPS ')' { };
        NOT_OP  : '(' _not EXP ')' { };
DEF_STMT        : '(' _define VARIABLE EXP ')' {

                }
                ;
        VARIABLE: _id { 

                }
                ;
        VARIABLES: VARIABLE VARIABLES {

                }
                | {

                }
                ;

FUN_EXP         : '(' _fun FUN_ID FUN_BODY ')' {

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
        FUN_NAME: _id {

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

IF_EXP          : '(' _if TEST_EXP THAN_EXP ELSE_EXP ')'
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
        ASTNode *new_node = (ASTNode*)malloc(sizeof(ASTNode));
        new_node->type = type_stk.top();
        type_stk.pop();
        new_node->left = exp1;
        new_node->right = exp2;
        return new_node;
}

ASTVal* ASTVisit(ASTNode *current){
    ASTVal *ret = (ASTVal*)malloc(sizeof(ASTVal));
    switch(current->type){
        case AST_ROOT:
            ASTVisit(current->left);
            ASTVisit(current->right);
            break;
        case AST_NULL:
            break;
        case AST_NUMBER:
            ret->number = ((ASTNumber*)current)->number;
            break;
        case AST_BOOLVAL:
            ret->bool_val = ((ASTBoolVal*)current)->bool_val;
            break;
        case AST_PNUMBER:
            ret = ASTVisit(current->left);
            std::cout << ret->number << "\n";
            break;
        case AST_PBOOLVAL:
            ret = ASTVisit(current->left);
            std::cout << (ret->bool_val ? "#t" : "#f" ) << "\n";
            break;
        default:
            std::cout << "error!\n";
    }
    return ret;
}

void yyerror(const char *message) {
        fprintf (stderr, "%s\n",message);
}

int main(int argc, char *argv[]) {
        yyparse();
        ASTVisit(root);
        return(0);
}
