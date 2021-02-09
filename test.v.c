
#include "default.h"  

// Typedefs
typedef struct main_MyStructThing main_MyStructThing;
struct main_MyStructThing {
	string	test;
};
void v_main_main() {
	string x =_SLIT("hello world baby");
	main_MyStructThing y;
	y.test =_SLIT("this is a cool thing");
	println(_SLIT("testar"));
	println(_SLIT("Åke har en hund"));
	println(x);
	println(y.test);
}

int main() {
	v_main_main();
	return 0;
}

