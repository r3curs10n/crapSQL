#ifndef H_CONDITION
#define H_CONDITION

#include "record_type.h"

class condition {

public:

enum condition_type{
	AND, OR, OP_CONST, OP_COLUMN
};

	virtual condition_type type() = 0;

	virtual bool eval(record_type& rt, record& r) = 0;

	virtual void destroy();

};

#endif