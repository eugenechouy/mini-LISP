#ifndef ASTNODE_H
#define ASTNODE_H

#include <iostream>
#include <string>
#include <stack>
#include <cstdio>

enum ASTType {
    AST_ROOT, AST_NULL, 
    AST_BOOLVAL, AST_NUMBER,
    AST_PNUMBER, AST_PBOOLVAL,
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
};

class ASTNumber : public ASTNode{
public:
    int number;
};

class ASTBoolVal : public ASTNode{
public:
    bool bool_val;
};


#endif