
#include <stdio.h>  
#include <stdlib.h>



#if defined(__TINYC__) && defined(__has_include)
// tcc does not support has_include properly yet, turn it off completely
#undef __has_include
#endif

#if defined(__has_include)

#if __has_include(<inttypes.h>)
#include <inttypes.h>
#else
#error VERROR_MESSAGE The C compiler can not find <inttypes.h> . Please install build-essentials
#endif

#else
#include <inttypes.h>
#endif

/*================================== builtin types ================================*/
typedef int64_t i64;
typedef int16_t i16;
typedef int8_t i8;
typedef uint64_t u64;
typedef uint32_t u32;
typedef uint16_t u16;
typedef uint8_t byte;
typedef uint32_t rune;
typedef float f32;
typedef double f64;
typedef int64_t int_literal;
typedef double float_literal;
typedef unsigned char* byteptr;
typedef void* voidptr;
typedef char* charptr;
typedef byte array_fixed_byte_300 [300];


// V type definitions:
struct string {
	byteptr str;
	int len;
	int is_lit;
};

struct array {
	int element_size;
	voidptr data;
	int len;
	int cap;
};

typedef struct string string;


#define _SLIT(s) ((string){.str = (byteptr)("" s), .len = (sizeof(s) - 1), .is_lit = 1})


// stdout, stderr 
void println(string s) {
	#if defined(_WIN32)
	{
	}
	#else
	{
		printf("%.*s\n", s.len, s.str);
	}
	#endif
}

void v_main_main() {
	string x =_SLIT("hello world");
	println(_SLIT("testarr"));
	println(_SLIT("testar igen"));
}

int main() {
	v_main_main();
	return 0;
}

