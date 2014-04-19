#include <string>
#include <cstring>
#include "record_type.h"
using namespace std;

pair<string, string> split_full_column_name(char* full_column_name){
	char* table_name = strtok(full_column_name, ".");
	char* column_name = strtok(NULL, ".");
	return make_pair(string(table_name), string(column_name));
}

typedef struct updateInfo{
	string column_name;
	column_type::data_type type;
	void* ptr_data;
}updateInfo;


void update_rows(string& table_name, vector<updateInfo>& update_vector, condition* where_clause){
	node_table* n = new node_table(table_name);
	int record_id;
	record r;
	if(where_clause)
	n->cond.conditions.push_back(where_clause);
	n->unroll_conditions();

	n->run();

	while(true){
		record_id = n->getNextRecord(r);
	 	if(record_id<0) break;


 	//shyamal.update(record_id, update_vector, table_name);
	}
	n->destroy();
}

void delete_rows(string& table_name,condition* where_clause){
	node_table* n = new node_table(table_name);
	int record_id;
	record r;
	if(where_clause)
	n->cond.conditions.push_back(where_clause);
	n->unroll_conditions();

	n->run();

	while(true){
		record_id = n->getNextRecord(r);
	 	if(record_id<0) break;

	 	//shymal.delete_row(record_id, table_name)
	}
	n->destroy();
}