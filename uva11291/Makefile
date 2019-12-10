11291: parser.tab.o lex.yy.o
	gcc -o 11291 parser.tab.o lex.yy.o -ll
parser.tab.o: parser.tab.c  
	gcc -c -g -I.. parser.tab.c
parser.tab.c: parser.y
	bison -d -o parser.tab.c parser.y
lex.yy.o: lex.yy.c
	gcc -c -g -I.. lex.yy.c
lex.yy.c: scanner.l
	lex scanner.l

clear:
	rm 11291 lex.yy.* parser.tab.*