CC?=cc
CGEN=./gen/c
IDIR =$(CGEN)/include
CFLAGS=-I$(IDIR)
TCCOS := unknown
TCCARCH := unknown
LIB=$(CGEN)/lib
LIBS=-L$(LIB)

#### Platform detections and overrides:
_SYS := $(shell uname 2>/dev/null || echo Unknown)
_SYS := $(patsubst MSYS%,MSYS,$(_SYS))
_SYS := $(patsubst MINGW%,MinGW,$(_SYS))

ifneq ($(filter $(_SYS),MSYS MinGW),)
WIN32 := 1
V:=./v.exe
endif

ifeq ($(_SYS),Linux)
LINUX := 1
TCCOS := linux
endif

ifeq ($(_SYS),Darwin)
MAC := 1
TCCOS := macos
endif

ifeq ($(_SYS),FreeBSD)
TCCOS := freebsd
LDFLAGS += -lexecinfo
endif

ifdef ANDROID_ROOT
ANDROID := 1
undefine LINUX
TCCOS := android
endif
#####

ifdef WIN32
TCCOS := windows
VCFILE := v_win.c
endif

TCCARCH := $(shell uname -m 2>/dev/null || echo unknown)

ifeq ($(TCCARCH),x86_64)
	TCCARCH := amd64
else
ifneq ($(filter x86%,$(TCCARCH)),)
	TCCARCH := i386
else
ifeq ($(TCCARCH),aarch64)
	TCCARCH := arm64
else
ifneq ($(filter arm%,$(TCCARCH)),)
	TCCARCH := arm
# otherwise, just use the arch name
endif
endif
endif
endif

all: main_cc

compiler:
	$(CC) $(CGEN)/src/default.c -c $(CFLAGS) $(LIBS) -o $(LIB)/default.o
	chmod 755 $(LIB)/default.o
clean:
	rm -f $(LIB)/*.o
	

main_cc: 
	v main.v
	./main
	$(CC) $(CGEN)/src/main.c $(CFLAGS) $(LIBS) -o ./v $(LIB)/default.o
	chmod 755 ./v
.PHONY: clean




