syntax: calculator.y
	bison -H calculator.y

lexer: calculator.l
	lex calculator.l

calculator: syntax lexer utils.c utils.h
	gcc lex.yy.c calculator.tab.c utils.c -ocalculator -lm

run_test:
	cat test_input | ./calculator

clean:
	rm calculator lex.yy.c calculator.tab.c calculator.tab.h