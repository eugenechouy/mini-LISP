mini-lisp: parser.tab.o lex.yy.o
	g++ -o mini-lisp parser.tab.o lex.yy.o -ll
parser.tab.o: parser.tab.cc
	g++ -c -g -I.. parser.tab.cc
parser.tab.cc: parser.y
	bison -d -o parser.tab.cc parser.y
lex.yy.o: lex.yy.cc
	g++ -c -g -I.. lex.yy.cc
lex.yy.cc: scanner.l
	lex -o lex.yy.cc scanner.l

clear:
	rm mini-lisp lex.yy.* parser.tab.*