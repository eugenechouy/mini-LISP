PROB6A : parser.tab.o lex.yy.o
	gcc -o PROB6A parser.tab.o lex.yy.o -ll
parser.tab.o: parser.tab.c  
	gcc -c -g -I.. parser.tab.c
parser.tab.c: PROB6A.y
	bison -d -o parser.tab.c PROB6A.y
lex.yy.o: lex.yy.c
	gcc -c -g -I.. lex.yy.c
lex.yy.c: PROB6A.l
	lex PROB6A.l

clear:
	rm PROB6A lex.yy.* parser.tab.*