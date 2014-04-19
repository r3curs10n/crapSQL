#include "node.h"

node::node(){
	node_setup();
}

void node::node_setup(){
	left = right = NULL;
	cond = NULL;
	eor = false;
	my_record_type_generated = false;
}

void node::run(){
	if (left) left->run();
	if (right) right->run();
}

void node::destroy(){
	if (left) {left->destroy(); delete left;}
	if (right) {right->destroy(); delete right;}
	if (cond) {cond->destroy(); delete cond; }
}