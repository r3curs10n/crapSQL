#ifndef H_NODE_JOIN
#define H_NODE_JOIN

#include "node.h"

class node_join : public node {

private:
	record lhs_cur_record;
	bool lhs_cur_record_present;

public:
	int getNextRecord(record& r);
	record_type getRecordType();
	void refresh();

	node::node_type type();

	node_join();
};

#endif