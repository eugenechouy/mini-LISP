#!/bin/bash
bison -d -o parser.tab.c PROB6A.y
gcc -c -g -I.. parser.tab.c
lex PROB6A.l
gcc -c -g -I.. lex.yy.c
gcc -o PROB6A parser.tab.o lex.yy.o -ll
