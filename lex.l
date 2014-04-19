%{

#include <cstdio>
#include <cstdlib>
#include <string>
#include <iostream>
#include "includes.h"
#include "parse.tab.h"
using namespace std;

/*
union any{
	int vInt;
	float vFloat;
	char vString[100];
};

any yylval;

int CONST_INT=0;
int CONST_FLOAT=1;
int SELECT=2;
int FROM=3;
int WHERE=4;
int SEMI=5;
int TABLE_NAME=6;
int COLUMN_NAME=7;
int CONST_STRING=8;
*/

%}

%option noyywrap

%%

[ \t\n]	;
[0-9]+ {yylval.vInt = atoi(yytext); return CONST_INT;}
[0-9]+\.[0-9]+ {yylval.vFloat = atof(yytext); return CONST_FLOAT;}
"SELECT" {return SELECT;}
"FROM" {return FROM;}
"WHERE" {return WHERE;}
"INSERT" {return INSERT;}
"INTO" {return INTO;}
"VALUES" {return VALUES;}
"AND" {return AND;}
"OR" {return OR;}
"UPDATE" {return UPDATE;}
"SET" {return SET;}
"DELETE" {return DELETE;}
"(" {return LP;}
")" {return RP;}
[\<\>\=] {strncpy(yylval.vString, yytext, 100); return OPERATOR;}
";" {return SEMI;}
[a-z]+ {strncpy(yylval.vString, yytext, 100); return TABLE_NAME;}
[a-z]+\.[a-z]+ {strncpy(yylval.vString, yytext, 100); return COLUMN_NAME;}
\'[^\']+\' {strncpy(yylval.vString, yytext+1, 100); yylval.vString[strlen(yylval.vString)-1]=0; return CONST_STRING;}
\, {return COMMA;}

%%

/*int main(){
	while (true){
		cout<<yylex()<<" ";
	}
	return 0;
}*/