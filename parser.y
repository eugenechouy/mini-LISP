%{
        #include "ASTNode.h"
       
        std::stack<ASTType> type_stk;
        std::map<std::string, ASTNode*> global_id_map;
        ASTNode *root;
        ASTNode* constructAST(ASTNode *exp1, ASTNode *exp2, ASTNode *exp3);
        ASTVal* ASTVisit(ASTNode *current, std::map<std::string, ASTNode*> &local_id_map);
        ASTVal* ASTFun(ASTNode *fun_exp, ASTNode *param, std::map<std::string, ASTNode*> &local_id_map);
        int calNumber(ASTNode *current, std::map<std::string, ASTNode*> &local_id_map);
        bool calLogic(ASTNode *current, std::map<std::string, ASTNode*> &local_id_map);
        void defineID(ASTNode *current);
        
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
%type<intVal> NUM_OP LOGICAL_OP 
%type<intVal> FUN_EXP FUN_CALL FUN_ID FUN_BODY FUN_NAME PARAM PARAMS
*/

%type<node> PROGRAM 
%type<node> STMT STMTS PRINT_STMT DEF_STMT
%type<node> EXP EXPS 
%type<node> NUM_OP LOGICAL_OP 
%type<node> PLUS MINUS MULTIPLY DIVIDE MODULES GREATER SMALLER EQUAL
%type<node> AND_OP OR_OP NOT_OP
%type<node> VARIABLE VARIABLES
%type<node> PARAM PARAMS
%type<node> FUN_EXP FUN_CALL FUN_ID FUN_BODY FUN_NAME

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
STMT            : EXP | DEF_STMT | PRINT_STMT ;

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
/* EXP             :  | IF_EXP ; */
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
                | NUM_OP | LOGICAL_OP | VARIABLE | FUN_EXP | FUN_CALL
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

LOGICAL_OP      : AND_OP | OR_OP | NOT_OP ;
        AND_OP  : '(' _and EXP EXP EXPS ')' { $$ = constructAST($3, $4, $5); };
        OR_OP   : '(' _or EXP EXP EXPS ')' { $$ = constructAST($3, $4, $5); };
        NOT_OP  : '(' _not EXP ')' { $$ = constructAST($3, NULL, NULL); };

DEF_STMT        : '(' _define VARIABLE EXP ')' {
                    $$ = constructAST($3, $4, NULL);
                }
                ;
        VARIABLE: _id { 
                    ASTId *new_node = (ASTId*)malloc(sizeof(ASTId));
                    new_node->type = AST_ID;
                    new_node->id = std::string($1);
                    $$ = (ASTNode*)new_node;
                }
                ;

FUN_EXP         : '(' _fun FUN_ID FUN_BODY ')' {
                    $$ = constructAST($3, $4, NULL);
                }
                ;
        FUN_ID  : '(' VARIABLES ')' {
                    $$ = $2;
                }
                ;
        FUN_BODY: EXP 
                ;
        FUN_CALL: '(' FUN_EXP PARAMS ')' {
                    type_stk.push(AST_FUN_DEF_CALL);
                    $$ = constructAST($2, $3, NULL);

                }
                | '(' FUN_NAME PARAMS ')' {
                    type_stk.push(AST_FUN_CALL);
                    $$ = constructAST($2, $3, NULL);
                }
                ;
        FUN_NAME: VARIABLE 
                ;
        PARAM   : EXP 
                ;
        PARAMS : PARAM PARAMS {
                    type_stk.push(AST_NUMBER);
                    $$ = constructAST($1, $2, NULL);
                }
                | {
                    $$ = NULL;
                }
                ;
        LAST_EXP: EXP 
                ;
        VARIABLES: VARIABLE VARIABLES {
                    type_stk.push(AST_ID);
                    $$ = constructAST($1, $2, NULL);
                }
                | {
                    $$ = NULL;
                }
                ;

/*
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

int calNumber(ASTNode *current, std::map<std::string, ASTNode*> &local_id_map){
    if(!current) return 1;
    int ret;
    switch(current->type){
        case AST_PLUS:
            if(current->right)
                ret = calNumber(current->left, local_id_map) + calNumber(current->right, local_id_map);
            else
                ret = calNumber(current->left, local_id_map);
            break;
        case AST_MINUS:
            ret = calNumber(current->left, local_id_map) - calNumber(current->right, local_id_map);
            break;
        case AST_MULTIPLY:
            if(current->right)
                ret = calNumber(current->left, local_id_map) * calNumber(current->right, local_id_map);
            else
                ret = calNumber(current->left, local_id_map);
            break;
        case AST_DIVIDE:
            ret = calNumber(current->left, local_id_map) / calNumber(current->right, local_id_map);
            break;
        case AST_MODULES:
            ret = calNumber(current->left, local_id_map) % calNumber(current->right, local_id_map);
            break;
        case AST_NUMBER:
            ret = ((ASTNumber*)current)->number;
            break;
        case AST_SMALLER:
            ret = ( calNumber(current->left, local_id_map) < calNumber(current->right, local_id_map) ? 1 : 0 );
            break;
        case AST_GREATER:
            ret = ( calNumber(current->left, local_id_map) < calNumber(current->right, local_id_map) ? 0 : 1 );
            break;
        case AST_ID:
            ret = ASTVisit(current, local_id_map)->number;
            break;
    }
    return ret;
}

bool calLogic(ASTNode *current, std::map<std::string, ASTNode*> &local_id_map){
    if(!current) return true;
    bool ret;
    switch(current->type){
        case AST_AND:
            ret = calLogic(current->left, local_id_map) && calLogic(current->right, local_id_map);
            break;
        case AST_OR:
            if(current->right)
                ret = calLogic(current->left, local_id_map) || calLogic(current->right, local_id_map);
            else 
                ret = calLogic(current->left, local_id_map);
            break;
        case AST_NOT:
            ret = !calLogic(current->left, local_id_map);
            break;
        case AST_GREATER:
        case AST_SMALLER:
            ret = calNumber(current, local_id_map);
            break;
        case AST_EQUAL:
            if(current->right){
                if(calNumber(current->left, local_id_map) == calNumber(current->right->left, local_id_map))
                    ret = calLogic(current->right, local_id_map);
                else 
                    ret = false;
            }
            else
                ret = true;
            break;
        case AST_BOOLVAL:
            ret = ((ASTBoolVal*)current)->bool_val;
            break;
        case AST_ID:
            ret = ASTVisit(current, local_id_map)->bool_val;
            break;
    }
    return ret;
}

void defineID(ASTNode *current){
    std::string defID = ((ASTId*)current->left)->id;
    if(global_id_map[defID]){
        std::cout << "Redefined id: " << defID << "\n";
        exit(0);
    }
    else 
        global_id_map[defID] = current->right;
}

ASTVal* ASTFun(ASTNode *fun_exp, ASTNode *param, std::map<std::string, ASTNode*> &local_id_map){
    ASTNode *fun_id = fun_exp->left;
    ASTNode *fun_body = fun_exp->right;
    ASTNode *param_tmp = param;
    std::map<std::string, ASTNode*> new_id_map = local_id_map;
    std::stack<ASTNode*> param_stk;
    std::stack<std::string> id_stk;
    if(!param)
        return ASTVisit(fun_body, new_id_map);
    
    while(param_tmp){
        ASTNode *tmp = (ASTNode *)ASTVisit(param_tmp->left, new_id_map);
        param_stk.push(tmp);
        param_tmp = param_tmp->right;
    }
    while(fun_id){
        id_stk.push(((ASTId*)fun_id->left)->id);
        fun_id = fun_id->right;
    }

    if(param_stk.size() == id_stk.size()) {
        while(param_stk.size()){
            new_id_map[id_stk.top()] = param_stk.top();
            id_stk.pop();
            param_stk.pop();
        }
    }
    else {
        std::cout << "parameter numbers not match: need " << id_stk.size() << " but " << param_stk.size()  << "\n";
        exit(0);
    }
    return ASTVisit(fun_body, new_id_map);
}

ASTVal* ASTVisit(ASTNode *current, std::map<std::string, ASTNode*> &local_id_map){
    if(!current) return NULL;
    ASTVal *ret = (ASTVal*)malloc(sizeof(ASTVal));
    switch(current->type){
        case AST_ROOT:
            ASTVisit(current->left, local_id_map);
            ASTVisit(current->right, local_id_map);
            break;
        case AST_PNUMBER:
            ret = ASTVisit(current->left, local_id_map);
            std::cout << ret->number << "\n";
            break;
        case AST_PBOOLVAL:
            ret = ASTVisit(current->left, local_id_map);
            std::cout << (ret->bool_val ? "#t" : "#f" ) << "\n";
            break;
        case AST_PLUS:
        case AST_MINUS:
        case AST_MULTIPLY:
        case AST_DIVIDE:
        case AST_MODULES:
        case AST_NUMBER:
            ret->type = AST_NUMBER;
            ret->number = calNumber(current, local_id_map);
            break;
        case AST_GREATER:
        case AST_SMALLER:
        case AST_EQUAL:
        case AST_AND:
        case AST_OR:
        case AST_NOT:
        case AST_BOOLVAL:
            ret->type = AST_BOOLVAL;
            ret->bool_val = calLogic(current, local_id_map);
            break;
        case AST_DEFINE:
            defineID(current);
            break;
        case AST_ID:
            if(!local_id_map[((ASTId*)current)->id])
                std::cout << "Undefined id: " << ((ASTId*)current)->id << "\n";
            else
                ret = ASTVisit(local_id_map[((ASTId*)current)->id], local_id_map);
            break;
        case AST_FUN:
            ret = ASTFun(current->left, NULL, local_id_map);
            break;
        case AST_FUN_DEF_CALL:
            ret = ASTFun(current->left, current->right, local_id_map);
            break;
        case AST_FUN_CALL:
            if(!local_id_map[((ASTId*)current->left)->id])
                std::cout << "Undefined function name: " << ((ASTId*)current)->id << "\n";
            else
                ret = ASTFun(local_id_map[((ASTId*)current->left)->id], current->right, local_id_map);
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
    ASTVisit(root, global_id_map);
    return(0);
}
