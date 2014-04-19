#include <iostream>
using namespace std;
#include "node_table.h"
#include "includes.h"

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
	for (list<condition*>::iterator i = cond.conditions.begin(); i!=cond.conditions.end(); i++){
		if ((*i)->type() == condition::OP_CONST){
			condition_op_const* c = dynamic_cast<condition_op_const*>(*i);
			cout<<c->lhs_table_name<<"."<<c->lhs_column_name<<" "<<c->op<<" "<<c->value.vInt<<endl;
		}
	}
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