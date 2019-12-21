LEX=lex
YACC=bison
CC=g++
OBJECT=mini-lisp

$(OBJECT): parser.tab.o lex.yy.o ASTTree.o
	$(CC) -o $(OBJECT) ASTTree.o parser.tab.o lex.yy.o -ll
parser.tab.o: parser.tab.cc ASTTree.hh
	$(CC) -c -g -I.. parser.tab.cc
parser.tab.cc parser.tab.hh: parser.y
	$(YACC) -d -o parser.tab.cc parser.y
lex.yy.o: lex.yy.cc parser.tab.hh ASTTree.hh
	$(CC) -c -g -I.. lex.yy.cc
lex.yy.cc: scanner.l
	$(LEX) -o lex.yy.cc scanner.l
ASTTree.o: ASTTree.cc
	$(CC) -c ASTTree.cc

clear:
	rm $(OBJECT) lex.yy.* parser.tab.* ASTTree.o