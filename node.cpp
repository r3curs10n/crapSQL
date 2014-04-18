#include "node.h"

node::node(){
	left = right = NULL;
	cond = NULL;
	eor = false;
}

void node::destroy(){
	if (left) {left->destroy(); delete left;}
	if (right) {right->destroy(); delete right;}
	if (cond) {cond->destroy(); delete cond; }
}