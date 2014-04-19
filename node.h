#ifndef H_NODE
#define H_NODE

#include "record_type.h"
#include "condition.h"

enum node_type {
	NODE_JOIN, NODE_PROJECTION, NODE_CONDITIION, NODE_TABLE
};

class node {

protected:
	record_type my_record_type;
	bool my_record_type_generated;

public:
	int level;
	node* left, *right;
	condition* cond;

	bool eor;	//end of records

	virtual node_type type() = 0;

	virtual record_type getRecordType() = 0;
	virtual bool getNextRecord(record&) = 0;

	virtual void refresh() = 0;

	void node_setup();
	node();

	virtual void run();

	virtual void destroy();

};

#endif