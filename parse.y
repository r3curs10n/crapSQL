%{

#include <cstdio>
#include <cstring>
#include <string>
#include <iostream>
#include <cstdlib>
#include "includes.h"
#include "parse_utils.h"
#include "set_utils.h"
using namespace std;

vector<pair<string, string> > columns;	//table.column pairs
vector<string> tables;	//list of tables

condition* where_clause;
node* select_root;

extern int yylex();
extern int yyparse();

void yyerror(const char* s);

%}

%union {
	int vInt;
	float vFloat;
	char vString[100];
	node* vNode;
	condition* vCondition;
}

%token<vInt> CONST_INT
%token<vFloat> CONST_FLOAT
%token<vString> CONST_STRING COLUMN_NAME TABLE_NAME OPERATOR
%token COMMA SEMI SELECT FROM WHERE AND OR LP RP
%left AND OR

%type<vCondition> simple_condition complex_condition
%type<vNode> table_list

%start sql

%%

sql: select
;

select: SELECT column_list FROM table_list optional_where SEMI {
			select_root = $4;
		}
;

column_list: column_list COMMA COLUMN_NAME {
				columns.push_back(split_full_column_name($3));
			}
			| COLUMN_NAME {
				columns.push_back(split_full_column_name($1));
			}
;

table_list: table_list COMMA TABLE_NAME {
				tables.push_back(string($3));
				node_join* nj = new node_join();
				//cout<<"joined"<<endl;
				node_table* nt = new node_table($3);
				nt->table_list.insert(string($3));
				nj->left = $1;
				nj->right = nt;
				merge_sets(nj->table_list, nt->table_list);
				$$ = nj;
				//cout<<">"<<$$->type()<<endl;
			}
			| TABLE_NAME {
				tables.push_back(string($1));
				node_table* nt = new node_table($1);
				nt->table_list.insert(string($1));
				$$ = nt;
			}
;

optional_where: 
			| WHERE complex_condition {
				where_clause = $2;
			}
;

complex_condition: complex_condition AND complex_condition {
						condition_and *c = new condition_and();
						c->left = $1;
						c->right = $3;
						merge_sets(c->table_list, $1->table_list);
						merge_sets(c->table_list, $3->table_list);
						$$ = c;
						//cout<<"kjrljrel"<<endl;
				}
				| complex_condition OR complex_condition {
					//TODO
					throw string("unimplemented or in parse.y");
				}
				| LP simple_condition RP {
					$$ = $2;
				}
				| simple_condition {
					$$ = $1;
				}
;

simple_condition: COLUMN_NAME OPERATOR COLUMN_NAME {
			//f
		}
		| COLUMN_NAME OPERATOR CONST_INT {
			pair<string, string> col = split_full_column_name($1);
			condition_op_const* c = new condition_op_const();
			c->lhs_table_name = col.first;
			c->lhs_column_name = col.second;
			c->op = string($2);
			c->value.vInt = $3;
			c->table_list.insert(col.first);
			$$ = c;
		}
		| COLUMN_NAME OPERATOR CONST_FLOAT {
			//TODO
			throw string("unimplemented condition float in parse.y");
		}
		| COLUMN_NAME OPERATOR CONST_STRING {
			//TODO
			throw string("unimplemented condition string in parse.y");
		}
;

%%

int main(){

	select_root = NULL;
	where_clause = NULL;

	do {
		yyparse();
	} while (!feof(stdin));

	

	if (where_clause){
		select_root->cond.conditions.push_back(where_clause);
		select_root->unroll_conditions();

		select_root->propogate_conditions();
		cout<<"parsing done"<<endl;
		select_root->run();
	}

	for (vector<pair<string,string> >::iterator i = columns.begin(); i!=columns.end(); i++){
		cout<<i->first<<" "<<i->second<<endl;
	}
	return 0;
}

void yyerror(const char* s){
	//nothing
	cout<<string(s)<< " ERROR"<<endl;
}