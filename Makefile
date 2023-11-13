syntax: parser.y
	yacc -d parser.y

lexer: parser.l
	lex parser.l

parser: syntax lexer
	gcc lex.yy.c y.tab.c -oparser -Wno-format-security -Wno-format-overflow

run_test:
	cat test_input | ./parser
