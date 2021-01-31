
#include <stdio.h>  
#include <stdlib.h>
#include <stdarg.h> // for va_list
#include <string.h> // memcpy



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

#ifndef __cplusplus
	#ifndef bool
		typedef int bool;
		#define true 1
		#define false 0
	#endif
#endif



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




// V definitions:
void _STR_PRINT_ARG(const char*, char**, int*, int*, int, ...);
string _STR(const char*, int, ...);
int utf8_str_visible_length(string s);
string tos2(byteptr s);
int vstrlen(byteptr s);
void v_panic(string s);
void string_free(string* s);
void v_free(voidptr ptr);

void _STR_PRINT_ARG(const char *fmt, char** refbufp, int *nbytes, int *memsize, int guess, ...) {
	va_list args;
	va_start(args, guess);
	// NB: (*memsize - *nbytes) === how much free space is left at the end of the current buffer refbufp
	// *memsize === total length of the buffer refbufp
	// *nbytes === already occupied bytes of buffer refbufp
	// guess === how many bytes were taken during the current vsnprintf run
	for(;;) {
		if (guess < *memsize - *nbytes) {
			guess = vsnprintf(*refbufp + *nbytes, *memsize - *nbytes, fmt, args);
			if (guess < *memsize - *nbytes) { // result did fit into buffer
				*nbytes += guess;
				break;
			}
		}
		// increase buffer (somewhat exponentially)
		*memsize += (*memsize + *memsize) / 3 + guess;
		*refbufp = (char*)realloc((void*)*refbufp, *memsize);
	}
	va_end(args);
}

string _STR(const char *fmt, int nfmts, ...) {
	va_list argptr;
	int memsize = 128;
	int nbytes = 0;
	char* buf = (char*)malloc(memsize);
	va_start(argptr, nfmts);
	for (int i=0; i<nfmts; ++i) {
		int k = strlen(fmt);
		bool is_fspec = false;
		for (int j=0; j<k; ++j) {
			if (fmt[j] == '%') {
				j++;
				if (fmt[j] != '%') {
					is_fspec = true;
					break;
				}
			}
		}
		if (is_fspec) {
			char f = fmt[k-1];
			char fup = f & 0xdf; // toupper
			bool l = fmt[k-2] == 'l';
			bool ll = l && fmt[k-3] == 'l';
			if (f == 'u' || fup == 'X' || f == 'o' || f == 'd' || f == 'c') { // int...
				if (ll) _STR_PRINT_ARG(fmt, &buf, &nbytes, &memsize, k+16, va_arg(argptr, long long));
				else if (l) _STR_PRINT_ARG(fmt, &buf, &nbytes, &memsize, k+10, va_arg(argptr, long));
				else _STR_PRINT_ARG(fmt, &buf, &nbytes, &memsize, k+8, va_arg(argptr, int));
			} else if (fup >= 'E' && fup <= 'G') { // floating point
				_STR_PRINT_ARG(fmt, &buf, &nbytes, &memsize, k+10, va_arg(argptr, double));
			} else if (f == 'p') {
				_STR_PRINT_ARG(fmt, &buf, &nbytes, &memsize, k+14, va_arg(argptr, void*));
			} else if (f == 's') { // v string
				string s = va_arg(argptr, string);
				if (fmt[k-4] == '*') { // %*.*s
					int fwidth = va_arg(argptr, int);
					if (fwidth < 0)
						fwidth -= (s.len - utf8_str_visible_length(s));
					else
						fwidth += (s.len - utf8_str_visible_length(s));
					_STR_PRINT_ARG(fmt, &buf, &nbytes, &memsize, k+s.len-4, fwidth, s.len, s.str);
				} else { // %.*s
					_STR_PRINT_ARG(fmt, &buf, &nbytes, &memsize, k+s.len-4, s.len, s.str);
				}
			} else {
				//v_panic(tos3('Invaid format specifier'));
			}
		} else {
			_STR_PRINT_ARG(fmt, &buf, &nbytes, &memsize, k);
		}
		fmt += k+1;
	}
	va_end(argptr);
	buf[nbytes] = 0;
	buf = (char*)realloc((void*)buf, nbytes+1);
#ifdef DEBUG_ALLOC
	//puts('_STR:');
	puts(buf);
#endif
#if _VAUTOFREE
	//g_cur_str = (byteptr)buf;
#endif
	return tos2((byteptr)buf);
}

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

string tos2(byteptr s) {
	if (s == 0) {
		v_panic(_SLIT("tos2: nil string"));
	}
	return (string){.str = s, .len = vstrlen(s)};
}

int vstrlen(byteptr s) {
	return strlen(((charptr)(s)));
}

void v_panic(string s) {
	println(s);
}

void string_free(string* s) {
	#if defined(_VPREALLOC)
	{
	}
	#endif
	if (s->is_lit == -98761234) {
		printf("double string.free() detected\n");
		return;
	}
	if (s->is_lit == 1 || s->len == 0) {
		return;
	}
	v_free(s->str);
	s->is_lit = -98761234;
}

void v_free(voidptr ptr) {
	#if defined(_VPREALLOC)
	{
	}
	#endif
	free(ptr);
}

int utf8_str_visible_length(string s) {
	int l = 0;
	int ul = 1;
	for (int i = 0; i < s.len; i += ul) {
		ul = 1;
		byte c = s.str[i];
		if (((c & (1 << 7))) != 0) {
			for (byte t = ((byte)(1 << 6)); ((c & t)) != 0; t >>= 1) {
				ul++;
			}
		}
		if (i + ul > s.len) {
			return l;
		}
		l++;
		if (c == 0xcc || c == 0xcd) {
			u16 r = ((((u16)(c)) << 8) | s.str[i + 1]);
			if (r >= 0xcc80 && r < 0xcdb0) {
				l--;
			}
		} else if (c == 0xe1 || c == 0xe2 || c == 0xef) {
			u32 r = ((((u32)(c)) << 16) | ((((u32)(s.str[i + 1])) << 8) | s.str[i + 2]));
			if ((r >= 0xe1aab0 && r < 0xe1ac80) || (r >= 0xe1b780 && r < 0xe1b880) || (r >= 0xe28390 && r < 0xe28480) || (r >= 0xefb8a0 && r < 0xefb8b0)) {
				l--;
			}
		}
	}
	return l;
}


void v_main_main() {
	string x =_SLIT("hello world");
	println(_SLIT("testarr"));
	println(x);
}

int main() {
	v_main_main();
	return 0;
}

