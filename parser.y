%{
    #include "ASTTree.hh"
    
    ASTNode *root;
    std::stack<ASTType> type_stk;
    std::map<std::string, ASTNode*> global_id_map;

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

%type<node> PROGRAM 
%type<node> STMT STMTS PRINT_STMT DEF_STMT
%type<node> EXP EXPS 
%type<node> NUM_OP LOGICAL_OP 
%type<node> PLUS MINUS MULTIPLY DIVIDE MODULES GREATER SMALLER EQUAL
%type<node> AND_OP OR_OP NOT_OP
%type<node> VARIABLE VARIABLES
%type<node> PARAM PARAMS
%type<node> FUN_EXP FUN_CALL FUN_ID FUN_BODY FUN_NAME
%type<node> IF_EXP TEST_EXP THAN_EXP ELSE_EXP

%token<intVal> _number
%token<boolVal> _bool_val
%token<id> _id
%token print_num print_bool _define _fun _if

%left '>' '<' '='
%left '+' '-' 
%left '*' '/' _mod 
%left _and _or _not
%left '(' ')' 

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
                    $$ = NULL; 
                }
                ;
STMT            : EXP | DEF_STMT | PRINT_STMT ;

PRINT_STMT      : '(' print_num EXP ')' {
                    type_stk.push(AST_PNUMBER); 
                    $$ = constructAST($3, NULL);
                }
                | '(' print_bool EXP ')' {
                    type_stk.push(AST_PBOOLVAL); 
                    $$ = constructAST($3, NULL);
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
                | NUM_OP | LOGICAL_OP | VARIABLE | FUN_EXP | FUN_CALL | IF_EXP
                ;
NUM_OP          : PLUS | MINUS | MULTIPLY | DIVIDE | MODULES | GREATER | SMALLER | EQUAL ;
        PLUS    : '(' '+' EXP EXP EXPS ')' { $$ = constructAST($3, $4, $5); };
        MINUS   : '(' '-' EXP EXP ')' { $$ = constructAST($3, $4); };
        MULTIPLY: '(' '*' EXP EXP EXPS ')' { $$ = constructAST($3, $4, $5); };
        DIVIDE  : '(' '/' EXP EXP ')' { $$ = constructAST($3, $4); };
        MODULES : '(' _mod EXP EXP ')' { $$ = constructAST($3, $4); };
        GREATER : '(' '>' EXP EXP ')' { $$ = constructAST($3, $4); };
        SMALLER : '(' '<' EXP EXP ')' { $$ = constructAST($3, $4); };
        EQUAL   : '(' '=' EXP EXP EXPS ')' { $$ = constructAST($3, $4, $5); };

LOGICAL_OP      : AND_OP | OR_OP | NOT_OP ;
        AND_OP  : '(' _and EXP EXP EXPS ')' { $$ = constructAST($3, $4, $5); };
        OR_OP   : '(' _or EXP EXP EXPS ')' { $$ = constructAST($3, $4, $5); };
        NOT_OP  : '(' _not EXP ')' { $$ = constructAST($3, NULL); };

DEF_STMT        : '(' _define VARIABLE EXP ')' {
                    $$ = constructAST($3, $4);
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
                    $$ = constructAST($3, $4);
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
                    $$ = constructAST($2, $3);

                }
                | '(' FUN_NAME PARAMS ')' {
                    type_stk.push(AST_FUN_CALL);
                    $$ = constructAST($2, $3);
                }
                ;
        FUN_NAME: VARIABLE 
                ;
        PARAM   : EXP 
                ;
        PARAMS : PARAM PARAMS {
                    type_stk.push(AST_NUMBER);
                    $$ = constructAST($1, $2);
                }
                | {
                    $$ = NULL;
                }
                ;
        LAST_EXP: EXP 
                ;
        VARIABLES: VARIABLE VARIABLES {
                    type_stk.push(AST_ID);
                    $$ = constructAST($1, $2);
                }
                | {
                    $$ = NULL;
                }
                ;
IF_EXP          : '(' _if TEST_EXP THAN_EXP ELSE_EXP ')' {
                    ASTIf *new_node = (ASTIf*)malloc(sizeof(ASTIf));
                    new_node->type = type_stk.top();
                    new_node->deter = $3;
                    new_node->left = $4;
                    new_node->right = $5;
                    type_stk.pop();
                    $$ = (ASTNode*)new_node;
                }
                ;
        TEST_EXP: EXP 
                ;
        THAN_EXP: EXP 
                ;
        ELSE_EXP: EXP 
                ;
%%

void yyerror(const char *message) {
    fprintf (stderr, "%s\n",message);
}

int main(int argc, char *argv[]) {
    yyparse();  
    ASTVisit(root, global_id_map);
    return(0);
}
