#ifndef ASTNODE_HH
#define ASTNODE_HH

#include <iostream>
#include <string>
#include <stack>
#include <map>
#include <cstdio>

enum ASTType {
    AST_ROOT,
    AST_BOOLVAL, AST_NUMBER, AST_ID, 
    AST_PNUMBER, AST_PBOOLVAL,
    AST_PLUS, AST_MINUS, AST_MULTIPLY, AST_DIVIDE, AST_MODULES, AST_GREATER, AST_SMALLER, AST_EQUAL,
    AST_AND, AST_OR, AST_NOT,
    AST_DEFINE, AST_FUN, AST_IF,
    AST_FUN_DEF_CALL, AST_FUN_CALL, AST_FUN_BODY
};

class ASTNode {
public:
    ASTType type;
    ASTNode *left, *right;
};

class ASTVal : public ASTNode{
public:
    int number;
    bool bool_val;
    std::string id;
};

class ASTNumber : public ASTNode{
public:
    int number;
};

class ASTBoolVal : public ASTNode{
public:
    bool bool_val;
};

class ASTId : public ASTNode{
public:
    std::string id;
};

class ASTIf : public ASTNode{
public:
    ASTNode *deter;
};

extern std::stack<ASTType> type_stk;
extern std::map<std::string, ASTNode*> global_id_map;

ASTNode* constructAST(ASTNode *exp1, ASTNode *exp2, ASTNode *exp3);
ASTNode* constructAST(ASTNode *exp1, ASTNode *exp2);
ASTVal* ASTVisit(ASTNode *current, std::map<std::string, ASTNode*> &local_id_map);

#endif