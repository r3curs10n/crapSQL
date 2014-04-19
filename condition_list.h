#ifndef H_CONDITION_LIST
#define H_CONDITION_LIST

#include <vector>
#include <algorithm>
#include "condition.h"
using namespace std;

class condition_list {

private:
	static bool condition_comp(condition* l, condition* r);

public:
	vector<condition*> conditions;
	bool eval(record_type& rt, record& r);
	void sort_conditions();

	void destroy();
};

#endif