mini-lisp: parser.tab.o lex.yy.o
	g++ -o mini-lisp parser.tab.o lex.yy.o -ll
parser.tab.o: parser.tab.c  
	g++ -c -g -I.. parser.tab.c
parser.tab.c: parser.y
	bison -d -o parser.tab.c parser.y
lex.yy.o: lex.yy.c
	g++ -c -g -I.. lex.yy.c
lex.yy.c: scanner.l
	lex scanner.l

clear:
	rm mini-lisp lex.yy.* parser.tab.*