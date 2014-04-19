#include "node_join.h"
#include <cassert>

node_join::node_join(){

	node_setup();
	lhs_cur_record_present = false;
}

void node_join::refresh(){
	lhs_cur_record_present = false;

	assert(left && right);

	left->refresh();
	right->refresh();
}

record_type node_join::getRecordType(){
	if (my_record_type_generated) return my_record_type;

	assert(left && right);

	record_type l, r;
	l = left->getRecordType();
	r = right->getRecordType();

	join_record_types(l, r, my_record_type);

	return my_record_type;

}

bool node_join::getNextRecord(record& r){

	assert(left && right);

	bool record_available = true;

	record x, y;

	if (!lhs_cur_record_present){
		record_available = left->getNextRecord(x);
		if (!record_available) return false;
	}

	if (right->getNextRecord(y)){
		join_records(x, y, r);
	} else {
		record_available = left->getNextRecord(x);
		if (!record_available) return false;
		right->refresh();
		if (right->getNextRecord(y)){
			join_records(x, y, r);
		} else {
			return false;
		}
	}

	if (cond.eval(my_record_type, r)){
		return true;
	} else {
		return getNextRecord(r);
	}

	//TODO: eliminate tail recursion

}

node::node_type node_join::type(){
	node::NODE_JOIN;
}