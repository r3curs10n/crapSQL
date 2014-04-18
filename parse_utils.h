#include <string>
#include <cstring>
using namespace std;

pair<string, string> split_full_column_name(char* full_column_name){
	char* table_name = strtok(full_column_name, ".");
	char* column_name = strtok(NULL, ".");
	return make_pair(string(table_name), string(column_name));
}