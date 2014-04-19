#ifndef H_NODE_TABLE
#define H_NODE_TABLE

#include "node.h"
#include <string>
using namespace std;

class node_table : public node {

private:
	string table_name;
	bool table_open;

public:
	record_type getRecordType();
	bool getNextRecord(record& r);
	void refresh();

	void run();

	node::node_type type ();

	node_table(string tabname);

};

#endif