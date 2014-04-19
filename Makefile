all: crapsql

norun: lex.yy.c parse.tab.c parse.tab.h myfiles
	g++ -c condition.o condition_and.o condition_or.o condition_op_const.o condition_op_column.o node.o

crapsql: lex.yy.c parse.tab.c parse.tab.h myfiles
	g++ -o crapsql lex.yy.c parse.tab.c condition.o condition_and.o condition_or.o condition_op_const.o condition_op_column.o node.o node_join.o node_table.o condition_list.o

myfiles: condition.o condition_and.o condition_or.o condition_op_const.o condition_op_column.o node.o node_table.o node_join.o condition_list.o
#	g++ -c condition.cpp condition_and.cpp condition_op_const.cpp node.cpp

lex.yy.c: lex.l parse.tab.h
	flex lex.l

parse.tab.c parse.tab.h: parse.y
	bison -d parse.y

clean:
	rm *.o crapsql parse.tab.c parse.tab.h lex.yy.c