syntax: bas.y
	yacc -d bas.y

lexer: bas.l
	lex bas.l

parser: syntax lexer
	gcc lex.yy.c y.tab.c -oparser

run_test:
	cat test_input | ./parser
