#include "node.h"
#include "set_utils.h"
#include "condition_and.h"

node::node(){
	node_setup();
}

void node::node_setup(){
	left = right = NULL;
	//cond = NULL;
	eor = false;
	my_record_type_generated = false;
}

void node::run(){
	cond.sort_conditions();
	if (left) left->run();
	if (right) right->run();
}

void node::unroll_conditions(){
	for (list<condition*>::iterator i = cond.conditions.begin(); i != cond.conditions.end(); i++){
		if ((*i)->type() == condition::AND){
			condition_and* c = dynamic_cast<condition_and*>(*i);
			cond.conditions.push_back(c->left);
			cond.conditions.push_back(c->right);
			c->left = c->right = NULL;
			delete *i;
			cond.conditions.erase(i);
			i = cond.conditions.begin();
		}
	}
}

void node::propogate_conditions(){

	if (type() == node::NODE_TABLE){
		return;
	}

	for (list<condition*>::iterator i = cond.conditions.begin(); i != cond.conditions.end(); i++){
		if ((*i)->type() == condition::AND){
			condition_and* c = dynamic_cast<condition_and*>(*i);
			if (left && set_contains(left->table_list, (*i)->table_list)){
				left->cond.conditions.push_back((*i));
				cond.conditions.erase(i);
			}
			else if (right && set_contains(right->table_list, (*i)->table_list)){
				right->cond.conditions.push_back((*i));
				cond.conditions.erase(i);
			}
		}
	}

	if (left){
		left->unroll_conditions();
		left->propogate_conditions();
	}

	if (right){
		right->unroll_conditions();
		right->propogate_conditions();
	}
}

void node::destroy(){
	if (left) {left->destroy(); delete left;}
	if (right) {right->destroy(); delete right;}
	cond.destroy();
}