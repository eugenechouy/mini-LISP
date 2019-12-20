# mini-LISP

## Type Definiation

* Boolean: **#t** for true and **#f** for false
* Number: Signed integer from −( 2^31 ) to 2^31
* Function

## Operation

| Name | Symbol | Example |
| ---- | - | ----------- |
| Plus | + | (+ 1 2) => 3 |
| Minus| - | (- 1 2) => -1 |
| Multiply | * | (* 2 3) => 6 |
| Divide | / | (/ 6 3) => 2 |
| Modulus | mod| (mod 8 3) => 2 |
| Greater | > | (> 1 2) => #f |
| Smaller | < | (< 1 2) => #t |
| Equal | = | (= 1 2) => #f |
| And | and | (and #t #f) => #f |
| Or | or | (or #t #f) => #t |
| Not | not | (not #t) => #f |
| | define |
| | fun |
| | if |

## Lexical Details

```
separator  [ \t\n\r]
letter     [a-z]
digit      [0-9]
number     0|[1-9]{digit}*|-[1-9]{digit}*
ID         {letter}({letter}|{digit}|"-")*
bool-val   #[t|f]
```

## Grammar and Behavior

1. Program
```
PROGRAM : STMT STMTS
STMTS   : STMT STMTS | {}
STMT    : EXP | DEF-STMT | PRINT-STMT
```

2. Print
```
PRINT_STMT : '(' print_num EXP ')' 
           | '(' print_bool EXP ')'
```

3. Expression
```
EXPS  : EXP EXPS | {}
EXP   : bool_val | number | VARIABLE | NUM_OP | LOGICAL_OP | FUN_EXP | FUN_CALL | IF_EXP 
```

4. Numerical Operations 

```
NUM_OP : PLUS | MINUS | MULTIPLY | DIVIDE | MODULES | GREATER | SMALLER | EQUAL
```

5. Logical Operations

```
LOGICAL_OP : AND_OP | OR_OP | NOT_OP
```

6. Define statement

```
DEF_STMT : '(' define VARIABLE EXP ')'
VARIABLE : id 
```