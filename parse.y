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

vector<pair<column_type::data_type, void*> > insert_values;

condition* where_clause;
node* select_root;

vector <updateInfo> update_vector;
string update_table;
string delete_table;

extern int yylex();
extern int yyparse();

enum action {
	A_SELECT, A_INSERT, A_UPDATE, A_DELETE
};

action query_type;

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
%token COMMA SEMI SELECT FROM WHERE AND OR LP RP VALUES INSERT INTO UPDATE SET DELETE
%left AND OR

%type<vCondition> simple_condition complex_condition
%type<vNode> table_list

%start sql

%%

sql: select
	| update
	| delete
	| insert
;

select: SELECT column_list FROM table_list optional_where SEMI {
			select_root = $4;
			query_type = A_SELECT;
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
					condition_or *c = new condition_or();
					c->left = $1;
					c->right = $3;
					merge_sets(c->table_list, $1->table_list);
					merge_sets(c->table_list, $3->table_list);
					$$ = c;
				}
				| LP simple_condition RP {
					$$ = $2;
				}
				| simple_condition {
					$$ = $1;
				}
;

simple_condition: COLUMN_NAME OPERATOR COLUMN_NAME {
			pair<string,string> l_col = split_full_column_name($1);
			condition_op_column* c = new condition_op_column();
			c->lhs_table_name = l_col.first;
			c->lhs_column_name = l_col.second;
			
			c->op = string($2);
			
			pair<string,string> r_col = split_full_column_name($3);
			c->rhs_table_name = r_col.first;
			c->rhs_column_name = r_col.second;

			$$=c;
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
			pair<string, string> col = split_full_column_name($1);
			condition_op_const* c = new condition_op_const();
			c->lhs_table_name = col.first;
			c->lhs_column_name = col.second;
			c->op = string($2);
			c->value.vFloat = $3;
			c->table_list.insert(col.first);
			$$ = c;
		}
		| COLUMN_NAME OPERATOR CONST_STRING {
			pair<string, string> col = split_full_column_name($1);
			condition_op_const* c = new condition_op_const();
			c->lhs_table_name = col.first;
			c->lhs_column_name = col.second;
			c->op = string($2);
			strncpy(c->value.vString, $3, 100);
			c->table_list.insert(col.first);
			$$ = c;
		}
;

insert: INSERT INTO TABLE_NAME VALUES LP values RP SEMI {query_type = A_INSERT;}
;

values: values COMMA value
		| value
;

value: CONST_INT {
		int* x = (int*)malloc(sizeof(int));
		*x = $1;
		insert_values.push_back(make_pair(column_type::INT, (void*)x));
	}
	| CONST_FLOAT {
		float* x = (float*)malloc(sizeof(float));
		*x = $1;
		insert_values.push_back(make_pair(column_type::FLOAT, (void*)x));
	}
	| CONST_STRING {
		char* x = (char*)malloc(101);
		strncpy(x, $1, 100);
		insert_values.push_back(make_pair(column_type::STRING, (void*)x));
	}
;

update: UPDATE TABLE_NAME SET set_values optional_where 
		{ query_type = A_UPDATE;
			update_table= string($2);		
		};

set_values:	COLUMN_NAME '=' CONST_INT more_set_values{
			
			int* x= (int*) malloc(sizeof(int));
			*x = $3;
			
			updateInfo u;
			u.type= column_type::INT;
			u.ptr_data = (void*)x;
			u.column_name = string($1);

			update_vector.push_back(u);
		} 
		|	COLUMN_NAME '=' CONST_FLOAT more_set_values{
			
			float* x= (float*)malloc(sizeof(float));
			*x = $3;
			
			updateInfo u;
			u.type= column_type::FLOAT;
			u.ptr_data = (void*)x;
			u.column_name = string($1);

			update_vector.push_back(u);

		}
		|	COLUMN_NAME '=' CONST_STRING more_set_values{
			
			char* x= (char*)malloc(101);
			strncpy(x, $3, 100);
						
			updateInfo u;
			u.type= column_type::STRING;
			u.ptr_data = (void*)x;
			u.column_name = string($1);

			update_vector.push_back(u);
		}
		;

more_set_values : 
				| COMMA set_values
				;


delete:	DELETE FROM TABLE_NAME optional_where {
			
			query_type = A_DELETE;
			delete_table = string($3);	
		};


%%

int main(){

	select_root = NULL;
	where_clause = NULL;

	do {
		yyparse();
	} while (!feof(stdin));

	if (query_type == A_UPDATE){
		update_rows(update_table,update_vector,where_clause);
	}
	if (query_type == A_DELETE){
	delete_rows(update_table,where_clause);
	}

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