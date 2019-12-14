PROB6B : parser.tab.o lex.yy.o
	gcc -o PROB6B parser.tab.o lex.yy.o -ll
parser.tab.o: parser.tab.c  
	gcc -c -g -I.. parser.tab.c
parser.tab.c: PROB6B.y
	bison -d -o parser.tab.c PROB6B.y
lex.yy.o: lex.yy.c
	gcc -c -g -I.. lex.yy.c
lex.yy.c: PROB6B.l
	lex PROB6B.l

clear:
	rm PROB6B lex.yy.* parser.tab.*