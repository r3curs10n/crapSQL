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
	my_record_type_generated=true;

	return my_record_type;

}



int node_join::getNextRecord(record& r){

	assert(left && right);

	int record_id;

	record y;

	if (!lhs_cur_record_present){
		record_id = left->getNextRecord(lhs_cur_record);
		if (record_id < 0) return -1;
		lhs_cur_record_present=true;
	}

	if (right->getNextRecord(y) >= 0){
		join_records(lhs_cur_record, y, r);
	} else {
		record_id = left->getNextRecord(lhs_cur_record);
		if (record_id < 0) return -1;
		right->refresh();
		if (right->getNextRecord(y) >= 0){
			join_records(lhs_cur_record, y, r);
		} else {
			return -1;
		}
	}

	if (cond.eval(getRecordType(), r)){
		return 1;
	} else {
		return getNextRecord(r);
	}

	//TODO: eliminate tail recursion

}

node::node_type node_join::type(){
	return node::NODE_JOIN;
}