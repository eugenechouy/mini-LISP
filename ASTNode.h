#ifndef ASTNODE_H
#define ASTNODE_H

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
    AST_DEFINE, AST_FUN, AST_IF
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

extern std::stack<ASTType> type_stk;

#endif