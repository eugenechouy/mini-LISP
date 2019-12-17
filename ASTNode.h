#ifndef ASTNODE_H
#define ASTNODE_H

#include <iostream>
#include <string>
#include <stack>
#include <cstdio>

enum ASTType {
    AST_ROOT, AST_NULL, 
    AST_BOOLVAL, AST_NUMBER
};

class ASTNode {
public:
    std::ASTType type;
    ASTNode *left, *right;
};

class ASTNumber : ASTNode{
public:
    int number;
};

class ASTBoolVal : ASTNode{
public:
    int bool_val;
};


#endif