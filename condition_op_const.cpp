#include "condition_op_const.h"

#define AS_INT(x) (*(int*)(&(x)))


condition::condition_type condition_op_const::type(){
	return condition::OP_CONST;
}

condition_op_const::condition_op_const(){
	offset=-1;
	index=-1;
}

bool condition_op_const::eval(record_type& rt, record& r){
	if (offset==-1){
		offset = offset_of_column(rt, lhs_table_name, lhs_column_name);
		if (offset==-1) throw string("Undefined column");
	}
	if (index==-1){
		index = index_of_column(rt, lhs_table_name, lhs_column_name);
		if (index==-1) throw string("Undefined column");
	}

	if (rt[index].type == column_type::INT){

		if (op=="<"){
			return AS_INT(r[offset]) < value.vInt;
		} else if (op=="="){
			return AS_INT(r[offset]) == value.vInt;
		} else if (op==">"){
			return AS_INT(r[offset]) > value.vInt;
		}

		throw string("unimplemented operators in condition_op_const");
	}

	throw string("unimplemented datatypes in condition_op_const");

}