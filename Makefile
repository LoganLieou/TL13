build:
	flex a.l && bison -d a.y && gcc -L/usr/local/opt/flex/lib -lm -lfl lex.yy.c a.tab.c -o a

test:
	./test.sh
