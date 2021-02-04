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
typedef unsigned char *byteptr;
typedef void *voidptr;
typedef char *charptr;
typedef byte array_fixed_byte_300[300];
typedef struct string string;

// Built-in type definitions
// V type definitions:

struct array
{
    int element_size;
    voidptr data;
    int len;
    int cap;
};

struct string
{
    byteptr str;
    int len;
    int is_lit;
};

#ifndef __cplusplus
#ifndef bool
typedef int bool;
#define true 1
#define false 0
#endif
#endif

#define _SLIT(s) ((string){.str = (byteptr)("" s), .len = (sizeof(s) - 1), .is_lit = 1})

// V definitions:

void _STR_PRINT_ARG(const char *, char **, int *, int *, int, ...);
string _STR(const char *, int, ...);
int utf8_str_visible_length(string s);
string tos2(byteptr s);
int vstrlen(byteptr s);
void v_panic(string s);
void string_free(string *s);
void v_free(voidptr ptr);

void println(string s);