#ifndef H_NODE
#define H_NODE

#include "record_type.h"
#include "condition.h"

enum node_type {
	NODE_JOIN, NODE_PROJECTION, NODE_CONDITIION, NODE_TABLE
};

class node {

private:
	record_type my_record_type;
	bool my_record_type_generated;

public:
	int level;
	node* left, *right;
	condition* cond;

	bool eor;	//end of records

	virtual node_type type() = 0;

	virtual record_type getRecordType() = 0;
	virtual record getNextRecord() = 0;
//TODO: implement node class and derived classes

	node();

	virtual void destroy();

};

#endif