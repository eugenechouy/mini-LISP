%{
        #include "ASTNode.h"
       
        std::stack<ASTType> type_stk;
        ASTNode *root;
        ASTNode* constructAST(ASTNode *exp1, ASTNode *exp2, ASTNode *exp3);
        ASTVal* ASTVisit(ASTNode *current);
        int calNumber(ASTNode *current);
        bool calLogic(ASTNode *current);
        
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
*/

%type<node> PROGRAM 
%type<node> STMT STMTS PRINT_STMT
%type<node> EXP EXPS 
%type<node> NUM_OP
%type<node> PLUS MINUS MULTIPLY DIVIDE MODULES GREATER SMALLER EQUAL

%token print_num print_bool
%token<intVal> _number
%token<boolVal> _bool_val
%token<id> _id

%left '+' '-' '*' '/' _mod '>' '<' '=' _and _or _not _define _fun _if

%%
PROGRAM         : STMT STMTS {
                    type_stk.push(AST_ROOT);
                    $$ = constructAST($1, $2, NULL);
                    root = $$;
                }
                ;
STMTS           : STMT STMTS {
                    type_stk.push(AST_ROOT);
                    $$ = constructAST($1, $2, NULL);
                }
                | { 
                    $$ = NULL; 
                }
                ;
/* STMT            : EXP | DEF_STMT | PRINT_STMT ; */
STMT            : EXP | PRINT_STMT ;

PRINT_STMT      : '(' print_num EXP ')' {
                    type_stk.push(AST_PNUMBER); 
                    $$ = constructAST($3, NULL, NULL);
                }
                | '(' print_bool EXP ')' {
                    type_stk.push(AST_PBOOLVAL); 
                    $$ = constructAST($3, NULL, NULL);
                }
                ;
EXPS            : EXP EXPS {
                    ASTNode *new_node = (ASTNode*)malloc(sizeof(ASTNode));
                    new_node->type = type_stk.top();
                    new_node->left = $1;
                    new_node->right = $2;
                    $$ = new_node;
                }
                | { 
                    $$ = NULL; 
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
                | NUM_OP
                ;
NUM_OP          : PLUS | MINUS | MULTIPLY | DIVIDE | MODULES | GREATER | SMALLER | EQUAL ;
        PLUS    : '(' '+' EXP EXP EXPS ')' { $$ = constructAST($3, $4, $5); };
        MINUS   : '(' '-' EXP EXP ')' { $$ = constructAST($3, $4, NULL); };
        MULTIPLY: '(' '*' EXP EXP EXPS ')' { $$ = constructAST($3, $4, $5); };
        DIVIDE  : '(' '/' EXP EXP ')' { $$ = constructAST($3, $4, NULL); };
        MODULES : '(' _mod EXP EXP ')' { $$ = constructAST($3, $4, NULL); };
        GREATER : '(' '>' EXP EXP ')' { $$ = constructAST($3, $4, NULL); };
        SMALLER : '(' '<' EXP EXP ')' { $$ = constructAST($3, $4, NULL); };
        EQUAL   : '(' '=' EXP EXP EXPS ')' { $$ = constructAST($3, $4, $5); };

/*
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

ASTNode* constructAST(ASTNode *exp1, ASTNode *exp2, ASTNode *exp3){
    ASTNode *new_node = (ASTNode*)malloc(sizeof(ASTNode));
    new_node->type = type_stk.top();
    new_node->left = exp1;
    if(exp3){
        ASTNode *new_node_right = (ASTNode*)malloc(sizeof(ASTNode));
        new_node_right->type = type_stk.top();
        new_node_right->left = exp2;
        new_node_right->right = exp3;
        new_node->right = new_node_right;
    } else {
        new_node->right = exp2;
    }
    type_stk.pop();
    return new_node;
}

int calNumber(ASTNode *current){
    if(!current) return 1   ;
    int ret;
    switch(current->type){
        case AST_PLUS:
            if(current->right)
                ret = calNumber(current->left) + calNumber(current->right);
            else
                ret = calNumber(current->left);
            break;
        case AST_MINUS:
            ret = calNumber(current->left) - calNumber(current->right);
            break;
        case AST_MULTIPLY:
            if(current->right)
                ret = calNumber(current->left) * calNumber(current->right);
            else
                ret = calNumber(current->left);
            break;
        case AST_DIVIDE:
            ret = calNumber(current->left) / calNumber(current->right);
            break;
        case AST_MODULES:
            ret = calNumber(current->left) % calNumber(current->right);
            break;
        case AST_NUMBER:
            ret = ((ASTNumber*)current)->number;
            break;
        case AST_SMALLER:
            ret = ( calNumber(current->left) < calNumber(current->right) ? 1 : 0 );
            break;
        case AST_GREATER:
            ret = ( calNumber(current->left) < calNumber(current->right) ? 0 : 1 );
            break;
        case AST_EQUAL:
            if(current->right)
                ret = ( calNumber(current->left) == calNumber(current->right) ? 1 : 0 );
            else 
                ret = 1;
            break;
    }
    return ret;
}

bool calLogic(ASTNode *current){
    bool ret;
    switch(current->type){
        case AST_GREATER:
        case AST_SMALLER:
        case AST_EQUAL:
            ret = calNumber(current);
            break;
        case AST_BOOLVAL:
            ret = ((ASTBoolVal*)current)->bool_val;
            break;
    }
}

ASTVal* ASTVisit(ASTNode *current){
    if(!current) return NULL;
    ASTVal *ret = (ASTVal*)malloc(sizeof(ASTVal));
    switch(current->type){
        case AST_ROOT:
            ASTVisit(current->left);
            ASTVisit(current->right);
            break;
        case AST_PNUMBER:
            ret = ASTVisit(current->left);
            std::cout << ret->number << "\n";
            break;
        case AST_PBOOLVAL:
            ret = ASTVisit(current->left);
            std::cout << (ret->bool_val ? "#t" : "#f" ) << "\n";
            break;
        case AST_PLUS:
        case AST_MINUS:
        case AST_MULTIPLY:
        case AST_DIVIDE:
        case AST_MODULES:
        case AST_NUMBER:
            ret->number = calNumber(current);
            std::cout << ret->number << "\n";
            break;
        case AST_GREATER:
        case AST_SMALLER:
        case AST_EQUAL:
        case AST_BOOLVAL:
            ret->bool_val = ((ASTBoolVal*)current)->bool_val;
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
        std::cout << "parse ok\n";
        ASTVisit(root);
        return(0);
}
