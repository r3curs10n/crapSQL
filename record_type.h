#ifndef H_RECORD_TYPE
#define H_RECORD_TYPE

#include <string>
#include <vector>
using namespace std;

struct column_type {

enum data_type{
	INT, FLOAT, STRING
};
	string table_name, column_name;
	data_type type;
	int size;
};

typedef vector<column_type> record_type;
typedef vector<char> record;

inline int offset_of_column(record_type& rt, string& table_name, string& column_name){
	int offset = 0;
	for (vector<column_type>::iterator i = rt.begin(); i!=rt.end(); i++){
		if (table_name == i->table_name && column_name == i->column_name) return offset;
		offset += i->size;
	}
	return -1;
}

inline int index_of_column(record_type& rt, string& table_name, string& column_name){
	int index = 0;
	for (vector<column_type>::iterator i = rt.begin(); i!=rt.end(); i++){
		if (table_name == i->table_name && column_name == i->column_name) return index;
		index++;
	}
	return -1;
}

#endif