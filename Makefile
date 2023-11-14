syntax: calculator.y
	bison -H calculator.y

lexer: calculator.l
	lex calculator.l

calculator: syntax lexer
	gcc lex.yy.c calculator.tab.c -ocalculator -lm

run_test:
	cat test_input | ./calculator

clean:
	rm y.tab.c y.tab.h lex.yy.c calculator.tab.c calculator.tab.h