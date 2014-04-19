#include "node_table.h"

node_table::node_table(string tabname){
	table_name = tabname;
	table_open = false;
	my_record_type_generated = false;

	left = right = NULL;
	//cond = NULL;
	level = 0;
	/*
	shyamal.open(table_name);
	eor = shyamal.eor;
	*/

}

void node_table::refresh(){
	// shyamal.refresh()
	throw string("unimplemented refresh in node_table");
}

node::node_type node_table::type(){
	node::NODE_TABLE;
}

void node_table::run(){
	//TODO: pass a condition to shyamal
}

bool node_table::getNextRecord(record& r){

	/*
	while (shyamal.getNext(r)){
		if (cond.eval(my_record_type, r)) return true;
	}

	return false;
	*/

	throw string("unimplemented getNextRecord in node_table");

}

record_type node_table::getRecordType(){

	/*
	my_record_type_generated = true;
	return my_record_type = hitesh.getRecordType(table_name)
	*/

	throw string("unimplemented getRecordType in node_table");
}